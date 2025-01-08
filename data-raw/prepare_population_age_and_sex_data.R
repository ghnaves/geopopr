
locations_names = readRDS(here::here("data","locations_names.rds"))
location_str = temp_selection<-paste(locations_names$country_or_area_m49code,collapse = ",")

headers <- httr::add_headers(Authorization = Sys.getenv("WPP_ONU_BEARER"))
base_url <- "https://population.un.org/dataportalapi/api/v1"
population_age_and_sex_data=NULL
for(year in seq(1950,2100,5)){
  for(location in locations_names$country_or_area_m49code){
    target <- paste0(base_url,
                     "/data/indicators/46/locations/",location,
                     "/start/",year,"/end/",year)
    if(is.null(population_age_and_sex_data=NULL)){
      population_age_and_sex_data = download_pages_WPP(target,headers)
    } else{
      population_age_and_sex_data = population_age_and_sex_data |>
        dplyr::bind_rows(download_pages_WPP(target,headers))
    }
  }
}

write_rds(population_age_and_sex_data,here::here("data","population_age_and_sex_data.rds"))

rm(locations_names,headers,target,base_url,location_str)

