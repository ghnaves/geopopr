library(dplyr)
library(readr)

locations = read_rds(here::here("data-raw","locations_names.rds")) |>
  select(global_code,region_code,subregion_code,intermediateregion_code,
         locationId,location,location_iso2code,location_iso3code,
         least_developed_countries_ldc,landlocked_developing_countries_lldc,
         small_island_developing_states_sids)

locations_pt = readRDS(here::here("data-raw","paises_pt.rds")) |>
  rename(location_pt=name_pt)|>
  select(id,location_pt)

locations = locations |>
  mutate(least_developed_countries_ldc = if_else(is.na(least_developed_countries_ldc),FALSE,TRUE),
         landlocked_developing_countries_lldc = if_else(is.na(landlocked_developing_countries_lldc),FALSE,TRUE),
         small_island_developing_states_sids = if_else(is.na(small_island_developing_states_sids),FALSE,TRUE)) |>
  left_join(locations_pt |>
              select(location_pt,id),by=c("locationId"="id"))

write_rds(locations,here::here("data-raw","locations_pt.rds"))

db_path <- here::here("data", "population_data.sqlite")
db <- dbConnect(RSQLite::SQLite(), db_path)
dbWriteTable(db, 'locations', locations, append = TRUE, row.names = FALSE)
dbDisconnect(db)
cat("Processing completed successfully!\n")

rm(db_path,db,locations,locations_pt)

