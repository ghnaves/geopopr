#' Handle API Responses
#'
#' Validates the API response and extracts its content.
#'
#' @param response An `httr` response object.
#'
#' @return The content of the response as a character string.
#' @keywords internal
handle_response <- function(response) {
  if (httr::status_code(response) != 200) {
    stop(paste("Error: HTTP status", httr::status_code(response)))
  }
  httr::content(response, "text", encoding = "UTF-8")
}
#' Download Pages from WPP API
#'
#' Downloads paginated data from the WPP API and combines it into a single data frame.
#'
#' @param url A string containing the URL of the API's first page.
#' @param headers A list of HTTP headers, typically including authorization.
#'
#' @return A data frame containing the combined data from all pages.
#' @export
#'
#' @examples
#' headers <- httr::add_headers(Authorization = Sys.getenv("WPP_ONU_BEARER"))
#' base_url <- "https://population.un.org/dataportalapi/api/v1"
#' target <- paste0(base_url, "/indicators/")
#' indicators <- download_pages_WPP(target,headers)
#' print(indicators$name)
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
