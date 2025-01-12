# Função para processar dados de um local e ano específico
process_location_data <- function(location, year, base_url, headers) {
  target <- paste0(base_url,
                   "/data/indicators/46/locations/", location,
                   "/start/", year, "/end/", year,
                   "?pagingInHeader=false&format=json")
  # Fazer o download e processar os dados
  download_pages_WPP(target, headers)
}

insert_if_not_exists <- function(conn, table_name, data, key_columns) {
  # Ler os registros existentes da tabela
  existing_data <- dbReadTable(conn, table_name)
  # Identificar os novos registros com base nas colunas-chave
  new_data <- anti_join(data, existing_data, by = key_columns)
  # Inserir apenas os novos registros
  if (nrow(new_data) > 0) {
    dbWriteTable(conn, table_name, new_data, append = TRUE, row.names = FALSE)
  }
}

# Função para salvar dados no banco de dados
save_to_database <- function(data, db, table_name) {
  #save indicator
  indicators = data |>
    select(indicatorId, indicator, indicatorDisplayName) |>
    distinct()
  insert_if_not_exists(db, "indicators", indicators, key_columns = "indicatorId")

  #save source
  sources = data |>
    select(sourceId, source, revision) |>
    distinct()
  insert_if_not_exists(db, "sources", sources, key_columns = "sourceId")

  #save variant
  variants = data |>
    select(variantId, variant, variantShortName, variantLabel) |>
    distinct()
  insert_if_not_exists(db, "variants", variants, key_columns = "variantId")

  #save time
  times = data |>
    select(timeId, timeLabel, timeMid) |>
    distinct()
  insert_if_not_exists(db, "times", times, key_columns = "timeId")

  #save estimates
  estimates = data |>
    select(estimateTypeId, estimateType, estimateMethodId, estimateMethod) |>
    distinct()
  insert_if_not_exists(db, "estimates", estimates, key_columns = c("estimateTypeId","estimateMethodId"))

  #save sex
  sexs = data |>
    select(sexId, sex) |>
    distinct()
  insert_if_not_exists(db, "sexs", sexs, key_columns = "sexId")

  #save ages
  ages = data |>
    select(ageId, ageLabel,ageStart,ageEnd,ageMid) |>
    distinct()
  insert_if_not_exists(db, "ages", ages, key_columns = "ageId")

  #save values
  values = data |>
    select(timeId,locationId, indicatorId, sexId, ageId, sourceId, variantId,
      estimateTypeId, estimateMethodId, value)
  dbWriteTable(db, "data_population_age5_and_sex", values, append = TRUE, row.names = FALSE)
}

# Função para salvar metadados no banco de dados
save_metadata <- function(year, location, db) {
  metadata <- data.frame(
    year = year,
    location = location,
    processed_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z"),
    status = "Processed"
  )
  dbWriteTable(db, "metadata_population_age5_and_sex", metadata, append = TRUE, row.names = FALSE)
}

# Função para verificar se os dados já foram processados
check_metadata <- function(year, location, db) {
  query <- dbGetQuery(
    db,
    paste0("SELECT COUNT(*) AS count FROM metadata_population_age5_and_sex WHERE year = ", year,
           " AND location = ", location, " AND status = 'Processed'")
  )
  return(query$count > 0)
}

# Função para processar todos os anos e locais
process_all_data <- function(locations, years, base_url, headers, db) {
  for (year in years) {
    cat(paste0("\rProcessing year: ", year, "\n"))
    n <- 0
    for (location in locations$locationId) {
      n <- n + 1
      progress_bar(n, nrow(locations))

      # Verificar se os dados já foram processados
      if (check_metadata(year, location, db)) {
        cat(paste0("Skipping: Year ", year, ", Location ", location, "\n"))
        next
      }

      # Processar dados
      wpp_raw <- process_location_data(location, year, base_url, headers)

      # Salvar os dados e os metadados
      save_to_database(wpp_raw, db, "population_data")
      save_metadata(year, location, db)
    }
  }
}

# Execução principal
main <- function(locations_names, years, db_path) {
  # Conectar ao banco de dados
  db <- dbConnect(RSQLite::SQLite(), db_path)
  # Processar os dados de população
  process_all_data(locations_names, years, base_url, headers, db)
  # Fechar conexão
  dbDisconnect(db)
  cat("\rProcessing completed successfully!\n")
}

# ----
#EXECUÇÃO DO PROGRAMA

# Carregar dependências
library(here)
library(dplyr)
library(DBI)
library(RSQLite)

# Configurações globais
base_url <- "https://population.un.org/dataportalapi/api/v1"
headers <- c("Authorization" = Sys.getenv("WPP_ONU_BEARER"))
db_path <- here::here("inst/extdata", "population_data.sqlite")


# Carregar dados necessários
locations_students = readRDS(here::here("draft", "alunos_2024_2.rds")) |>
  mutate(iso = stringr::str_extract(pais, "(?<=Cod ISO: )\\w{3}")) |>
  filter(!is.na(iso)) |>
  select(iso)|>
  distinct()
locations <- readRDS(here::here("data-raw", "locations_names.rds")) |>
  filter(location_iso3code %in% c(locations_students$iso,'BRA'))

years <- c(seq(1975, 2100, 30))

# Executar o programa principal

main(locations, years, db_path)

query = paste0(
  "SELECT DISTINCT year FROM metadata_population_age5_and_sex;")
db_path = system.file("extdata", "population_data.sqlite", package = "geopopr")
conn = RSQLite::dbConnect(RSQLite::SQLite(), db_path)
RSQLite::dbGetQuery(conn, query)
RSQLite::dbDisconnect(conn)

