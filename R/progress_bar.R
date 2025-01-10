#' Custom Progress Bar
#'
#' This function creates a simple progress bar for tracking iterations.
#'
#' @param iter Current iteration number.
#' @param total Total number of iterations.
#'
#' @return Prints a progress bar to the console.
#' @export
#' @examples
#' # Example usage:
#' for (i in 1:50) {
#'   Sys.sleep(0.1) # Simulate work
#'   progress_bar(i, 50)
#' }
#' cat("\nDone!\n")
progress_bar <- function(iter, total) {
  # Proporção concluída
  progress <- iter / total
  # Número de "blocos" preenchidos
  num_filled <- round(progress * 20)
  # Montar a barra
  bar <- paste0("|", strrep("=", num_filled), strrep(" ", 20 - num_filled), "|")
  # Mostrar progresso
  cat(paste0(sprintf("\r%s %d%%", bar, round(progress * 100))))
  flush.console()
}
