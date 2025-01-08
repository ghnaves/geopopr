locations_pt = readRDS(here::here("data-raw","paises_pt.rds")) |>
  rename(country_or_area_name_pt=name_pt)
locations = readxl::read_excel(here::here("data-raw","locationsWithAggregates.xlsx"))

names(locations) = c("global_code",'global_name',
                     'region_code','region_name',
                     'subregion_code','subregion_name',
                     'intermediateregion_code','intermediateregion_name',
                     'country_or_area_name','country_or_area_m49code',
                     'country_or_area_iso2code','country_or_area_iso3code',
                     'least_developed_countries_ldc','landlocked_developing_countries_lldc',
                     'small_island_developing_states_sids')

locations_names = locations |>
  mutate(least_developed_countries_ldc = if_else(is.na(least_developed_countries_ldc),FALSE,TRUE),
         landlocked_developing_countries_lldc = if_else(is.na(landlocked_developing_countries_lldc),FALSE,TRUE),
         small_island_developing_states_sids = if_else(is.na(small_island_developing_states_sids),FALSE,TRUE)) |>
  left_join(locations_pt |>
              select(country_or_area_name_pt,id),by=c("country_or_area_m49code"="id"))

write_rds(locations_names,here::here("data","locations_names.rds"))

rm(locations_pt,locations,locations_names)

