# Carregar dependências
library(here)
library(dplyr)
library(DBI)
library(RSQLite)

db_path <- here::here("inst/extdata", "population_data.sqlite")
db <- dbConnect(RSQLite::SQLite(), db_path)

#dbExecute( db, "DROP TABLE metadata_population_age5_and_sex;")

#Criar tabelas, se necessário
dbExecute(
  db,
  "CREATE TABLE data_population_age5_and_sex (
      timeId INTEGER NOT NULL,
      locationId INTEGER NOT NULL,
      indicatorId INTEGER NOT NULL,
      sexId INTEGER NOT NULL,
      ageId INTEGER NOT NULL,
      sourceId INTEGER NOT NULL,
      variantId INTEGER NOT NULL,
      estimateTypeId INTEGER NOT NULL,
      estimateMethodId INTEGER NOT NULL,
      value REAL NOT NULL,
      FOREIGN KEY (timeId) REFERENCES times (timeId),
      FOREIGN KEY (locationId) REFERENCES locations (locationId),
      FOREIGN KEY (indicatorId) REFERENCES indicators (indicatorId),
      FOREIGN KEY (sexId) REFERENCES sexs (sexId),
      FOREIGN KEY (ageId) REFERENCES ages (ageId),
      FOREIGN KEY (variantId) REFERENCES variants (variantId),
      FOREIGN KEY (estimateTypeId,estimateMethodId) REFERENCES estimates (estimateTypeId, estimateMethodId),
      FOREIGN KEY (sourceId) REFERENCES sources (sourceId),
      FOREIGN KEY (timeId,locationId) REFERENCES variants (timeId, locationId)
    )"
)

dbExecute(db, "CREATE TABLE metadata_population_age5_and_sex (
      year INTEGER NOT NULL,
      location INTEGER NOT NULL,
      processed_at TEXT NOT NULL,
      status TEXT NOT NULL,
      PRIMARY KEY (year, location)
    )")

#dbExecute( db, "DROP TABLE locations;")

dbExecute(db, "CREATE TABLE locations (
      global_code INTEGER NOT NULL,
      region_code INTEGER,
      subregion_code INTEGER,
      intermediateregion_code INTEGER,
      locationId INTEGER NOT NULL,
      location TEXT NOT NULL,
      location_pt TEXT NOT NULL,
      location_iso2code TEXT NOT NULL,
      location_iso3code TEXT NOT NULL,
      least_developed_countries_ldc BOOLEAN NOT NULL,
      landlocked_developing_countries_lldc BOOLEAN NOT NULL,
      small_island_developing_states_sids BOOLEAN NOT NULL,
      PRIMARY KEY (locationId)
    )")

#dbExecute( db, "DROP TABLE indicators;")

#indicators
dbExecute(db, "CREATE TABLE indicators (
      indicatorId INTEGER NOT NULL,
      indicator TEXT NOT NULL,
      indicatorDisplayName TEXT NOT NULL,
      PRIMARY KEY (indicatorId)
    )")

#dbExecute( db, "DROP TABLE sources;")
dbExecute(db, "CREATE TABLE sources (
      sourceId INTEGER NOT NULL,
      source TEXT NOT NULL,
      revision INTEGER NOT NULL,
      PRIMARY KEY (sourceId)
    )")

dbExecute(db, "CREATE TABLE variants (
      variantId INTEGER NOT NULL,
      variant TEXT NOT NULL,
      variantShortName TEXT NOT NULL,
      variantLabel TEXT NOT NULL,
      PRIMARY KEY (variantId)
    )")

#dbExecute( db, "DROP TABLE times;")
dbExecute(db, "CREATE TABLE times (
      timeId INTEGER NOT NULL,
      timeLabel TEXT NOT NULL,
      timeMid TEXT NOT NULL,
      PRIMARY KEY (timeId)
    )")

dbExecute(db, "CREATE TABLE estimates (
      estimateTypeId INTEGER NOT NULL,
      estimateType TEXT NOT NULL,
      estimateMethodId INTEGER NOT NULL,
      estimateMethod TEXT NOT NULL,
      PRIMARY KEY (estimateTypeId, estimateMethodId)
    )")

dbExecute(db, "CREATE TABLE sexs (
      sexId INTEGER NOT NULL,
      sex TEXT NOT NULL,
      PRIMARY KEY (sexId)
    )")

#dbExecute( db, "DROP TABLE ages;")
dbExecute(db, "CREATE TABLE ages (
      ageId INTEGER NOT NULL,
      ageLabel TEXT NOT NULL,
      ageStart INTEGER NOT NULL,
      ageEnd INTEGER,
      ageMid REAL NOT NULL,
      PRIMARY KEY (ageId)
    )")

dbExecute(db, "PRAGMA foreign_keys = ON;")

#print(dbGetQuery(db, "SELECT sql FROM sqlite_master WHERE type='table';"))


# Fechar conexão
dbDisconnect(db)
cat("Processing completed successfully!\n")
