
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geopopr

<!-- badges: start -->
<!-- badges: end -->

The goal of geopopr is to …

Ainda em construção … :-(

## Installation

You can install the development version of geopopr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ghnaves/geopopr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(geopopr)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist    
#>  Min.   : 4.0   Min.   :  2  
#>  1st Qu.:12.0   1st Qu.: 26  
#>  Median :15.0   Median : 36  
#>  Mean   :15.4   Mean   : 43  
#>  3rd Qu.:19.0   3rd Qu.: 56  
#>  Max.   :25.0   Max.   :120
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

# Estrutura de dados

**GeoPackage**: dados geoespaciais

**SQLite**: metadados e tabelas relacionais

**Parquet:** dados tabulares de grandes dimensões

Arquivos binários grandes (geotiff, etc.) armazenados diretamente no
sistema de arquivos, com os caminhos em banco de dados.

# Fonte dos dados

United Nations. (2024). World Population Prospects 2024.
<https://population.un.org/wpp/>
