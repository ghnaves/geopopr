library(dplyr)
library(readr)
library(here)
library(RSQLite)
library(DBI)

locations = read_rds(here::here("data-raw","locations_names.rds")) |>
  select(global_code,region_code,subregion_code,intermediateregion_code,
         locationId,location,location_iso2code,location_iso3code,
         least_developed_countries_ldc,landlocked_developing_countries_lldc,
         small_island_developing_states_sids)

locations_pt = readRDS(here::here("data-raw","paises_pt.rds")) |>
  rename(location_pt=name_pt)|>
  select(id,location_pt)

locations = locations |>
  left_join(locations_pt |>
              select(location_pt,id),by=c("locationId"="id"))

write_rds(locations,here::here("data-raw","locations_pt.rds"))

db_path <- here::here("inst","extdata", "population_data.sqlite")
db <- dbConnect(RSQLite::SQLite(), db_path)
query <- paste0("DELETE FROM ", "locations", ";")

dbExecute(db, query)

dbWriteTable(db, 'locations', locations, append = TRUE, row.names = FALSE)
dbDisconnect(db)
cat("Processing completed successfully!\n")

rm(db_path,db,locations,locations_pt)

