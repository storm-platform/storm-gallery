#' @title Annual sample filter
#'
#' @rdname filter
#'
#' @description This function filters each time series by the predetermined
#' number of instances.
#'
#' @param samples_ts  a \code{sits_tibble} with the time series with the
#'                    training samples.
#' @param n_instances a \code{numeric} with the number of instances to be
#'                    filtered.
#'
#' @return a \code{sits_tibble} with the time series filtered.
#'
#' @export
filter_annual_samples <- function(samples_ts, n_instances = 24) {

  is_anual_samples <- vapply(
    X = samples_ts[["time_series"]],
    FUN = function(x) nrow(x) == n_instances,
    FUN.VALUE = logical(1)
  )

  samples_ts[is_anual_samples,]
}
