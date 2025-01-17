% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pop_pyr.R
\name{pop_pyr}
\alias{pop_pyr}
\title{Generate a Population Pyramid}
\usage{
pop_pyr(location, year)
}
\arguments{
\item{location}{A character or numeric input specifying the location. This can be:
\itemize{
\item ISO3 code (e.g., "BRA" for Brazil)
\item ISO2 code (e.g., "BR")
\item A numeric \code{locationId} (e.g., 76 for Brazil)
\item The name of the location (e.g., "Brazil").
}}

\item{year}{A character or numeric input specifying the year. This can be:
\itemize{
\item The year label (e.g., "2020").
\item The \code{timeMid} value (e.g., 2020).
}}
}
\value{
A ggplot object representing the population pyramid. The x-axis shows
age groups, and the y-axis represents the relative population percentage. Males
are represented with negative values, and females with positive values.
}
\description{
The \code{pop_pyr} function generates a population pyramid for a specified location and year
using data from the World Population Prospects. The pyramid is visualized as a
horizontal bar chart, showing the distribution of population by age and sex.
}
\details{
The function retrieves data from a SQLite database (\code{population_data.sqlite})
included in the package. The database must include the required tables:
\itemize{
\item \code{locations}: Contains location information.
\item \code{times}: Contains temporal data.
\item \code{data_population_age5_and_sex}: Contains population data by age and sex.
}

If the specified location or year is not found, the function will stop with an error.
}
\examples{
# Example 1: Population pyramid for Brazil in 2020
pop_pyr("Brazil", 2000)

# Example 2: Population pyramid for Brazil using ISO3 code and timeMid
pop_pyr("BRA", 2000)

# Example 3: Population pyramid for a locationId
pop_pyr(76, "2000")

}
