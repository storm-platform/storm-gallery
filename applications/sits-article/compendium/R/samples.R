#' @title Sample temporal extents
#'
#' @rdname samples
#'
#' @description This function creates a data.frame with the start and end dates
#' of each time series period.
#'
#' @param samples  a \code{sits_tibble} with the time series with the
#'                 training samples.
#'
#' @return a \code{data.frame} with start_date and end_date of each time series
#' period.
#'
#' @export
sample_temporal_extents <- function(samples) {
  if (!all(c("start_date", "end_date") %in% colnames(samples))) {
    stop(sprintf("samples must have `start_date` and `end_date` attributes"),
         call. = FALSE)
  }

  # selecting the individual dates available
  individual_dates <- sort(unique(samples$start_date))

  dates_df_lst <- lapply(individual_dates, function(individual_date) {
    date_data <- dplyr::filter(
      samples,
      .data[["start_date"]] == individual_date
    )

    # extract temporal extent
    start_date <- min(date_data$start_date)
    end_date   <- max(date_data$end_date)

    data.frame(start_date = start_date, end_date = end_date)
  })

  dplyr::bind_rows(dates_df_lst)
}
