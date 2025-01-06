library(jsonlite)
library(httr)

# Função para tratar a resposta da API
handle_response <- function(response) {
  if (httr::status_code(response) != 200) {
    stop(paste("Error: HTTP status", httr::status_code(response)))
  }
  httr::content(response, "text", encoding = "UTF-8")
}

# Função principal para baixar páginas
download_pages_WPP <- function(url, headers) {
  ext_json <- list(nextPage = url)
  ext <- NULL
  
  while (!is.null(ext_json$nextPage)) {
    # Fazer a requisição
    response <- httr::GET(ext_json$nextPage, headers)
    json_text <- handle_response(response)
    
    # Parse da resposta
    ext_json <- jsonlite::fromJSON(json_text)
    
    # Combinar dados
    ext <- if (is.null(ext)) {
      ext_json$data
    } else {
      rbind(ext, ext_json$data)
    }
  }
  
  return(ext)
}

## Indicators
headers <- httr::add_headers(Authorization = Sys.getenv("WPP_ONU_BEARER"))
base_url <- "https://population.un.org/dataportalapi/api/v1"
target <- paste0(base_url, "/indicators/")
indicators <- download_pages_WPP(target,headers)

target <- paste0(base_url, "/locations?sort=id")
locations <- baixar_páginas(target)





