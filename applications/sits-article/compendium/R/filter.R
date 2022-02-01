

#' @title Annual sample filter
#'
#' @rdname filter
#'
#' @description
#' description
#'
#' @param ... ...
#'
#' @param ... ...
#'
#' @return todo
#' @export
filter_annual_samples <- function(samples_ts) {
  anual_samples <- c()
  
  for (i in 1:length(samples_ts$time_series)) {
    anual_samples <-
      c(anual_samples, nrow(samples_ts$time_series[[i]]) == 24)
  }
  
  samples_ts[anual_samples,]
}
