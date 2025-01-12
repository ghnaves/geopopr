#' Population Data SQLite Database
#'
#' This SQLite database contains population data for analysis of demographic trends,
#' urbanization, housing quality, and related factors.
#'
#' @details
#' The database includes the following key tables:
#'
#' - **`locations`**: Information about locations (countries, regions, etc.).
#'   - Columns:
#'     - `locationId`: Unique identifier for the location.
#'     - `location`: Name of the location.
#'     - `location_iso3code`: ISO 3166-1 alpha-3 code.
#'     - `location_iso2code`: ISO 3166-1 alpha-2 code.
#' - **`times`**: Time periods and their attributes.
#'   - Columns:
#'     - `timeId`: Unique identifier for the time period.
#'     - `timeLabel`: Year or label of the time period (e.g., "2020").
#' - **`data_population_age5_and_sex`**: Population data by age and sex.
#'   - Columns:
#'     - `locationId`: Corresponding location.
#'     - `timeId`: Corresponding time period.
#'     - `ageId`: Age group identifier.
#'     - `sexId`: Sex identifier (1 = Male, 2 = Female).
#'     - `value`: Population count.
#'
#' The database is licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).
#'
#' @source United Nations, World Population Prospects.
#' @source Data licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).
#' For details, visit: https://creativecommons.org/licenses/by/4.0/
#'
#' @examples
#' # Access the database
#' db_path <- system.file("extdata", "population_data.sqlite", package = "geopopr")
#' conn <- DBI::dbConnect(RSQLite::SQLite(), db_path)
#'
#' # List tables
#' DBI::dbListTables(conn)
#'
#' # Query a table
#' DBI::dbGetQuery(conn, "SELECT * FROM locations LIMIT 5")
#'
#' DBI::dbDisconnect(conn)
#'
#' @name population_data
NULL
