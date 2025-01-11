find_location <- function(input, conn) {
  query <- "
    SELECT *
    FROM locations
    WHERE location_iso3code = ?
       OR location_iso2code = ?
       OR locationId = ?
       OR LOWER(location) = LOWER(?);
  "
  numeric_input <- suppressWarnings(as.numeric(input))  # Tenta converter para número
  input_upper <- toupper(input)  # Normaliza maiusculas
  # Executando a consulta
  result <- RSQLite::dbGetQuery(conn, query, params = list(input_upper, input_upper, numeric_input, input))
  # Retornando o resultado
  if (nrow(result) == 0) {
    return(NULL)  # Nenhum registro encontrado
  }
  return(result)
}

find_year <- function(input, conn) {
  query <- "
    SELECT *
    FROM times
    WHERE timeLabel = ?
       OR timeMid = ?;
  "
  txt_input <- as.character(input)
  # Executando a consulta
  result <- RSQLite::dbGetQuery(conn, query, params = list(txt_input, txt_input))
  # Retornando o resultado
  if (nrow(result) == 0) {
    return(NULL)  # Nenhum registro encontrado
  }
  return(result)
}

population_pyramid <- function(location, year) {
  db_path <- system.file("extdata", "population_data.sqlite", package = "geopopr")
  db <- RSQLite::dbConnect(RSQLite::SQLite(), db_path)

  location_data <- find_location(location, db)
  time_data <- find_year(year, db)

  locationId = location_data$locationId
  timeId = time_data$timeId

  query <- paste0("SELECT * FROM data_population_age5_and_sex WHERE locationId = ", locationId,
    " AND variantId = 4 AND timeId = ", timeId,
    " AND (sexId = 1 OR sexId = 2);")

  data = RSQLite::dbGetQuery(db, query) |>
    dplyr::group_by(.data$locationId,.data$sexId,.data$ageId,.data$value) |>
    dplyr::summarise(sexage_population=sum(.data$value),.groups='drop') |>
    dplyr::ungroup() |>
    dplyr::mutate(sexage_population=dplyr::if_else(.data$sexId==1,
                                                   -.data$sexage_population,.data$sexage_population),
                  total_population = sum(.data$value)) |>
    dplyr::mutate(relative_population=.data$sexage_population/.data$total_population) |>
    dplyr::mutate(age_f = factor(.data$ageId),
                  sex_f = factor(.data$sexId))

  gg=ggplot2::ggplot(data=data,
                     ggplot2::aes(x=.data$age_f, y=.data$relative_population,
                                  group=.data$sex_f, fill=.data$sex_f))+
    ggplot2::geom_bar(stat='identity')+
    ggplot2::coord_flip()+
    ggplot2::labs(caption = "Source: United Nations. World Population Prospects 2022",
         title=paste0('Population Pyramid: ',location),
         subtitle=year)+
    ggplot2::scale_y_continuous(name='Population (%)',
                       labels=scales::label_percent(big.mark = '.', decimal.mark = ','),
                       breaks = seq(-.16,.16,.04))+
    ggplot2::scale_fill_manual(name='Sex',label=c('Male','Female'),
                               values=c('lightpink','lightblue'))+
    ggplot2::scale_x_discrete(name='Age Group')+
    ggplot2::theme_minimal()

  RSQLite::dbDisconnect(db)
  return(gg)
}
