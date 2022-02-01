

#' @title Sample temporal extents
#'
#' @rdname samples
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
sample_temporal_extents <- function(samples) {
  if (!all(c("start_date", "end_date") %in% colnames(samples))) {
    stop(sprintf("samples must have `start_date` and `end_date` attributes"),
         call. = FALSE)
  }

  # selecting the individual dates available
  individual_dates <- sort(unique(samples$start_date))

  dplyr::bind_rows(lapply(individual_dates, function(individual_date) {
    date_data <- dplyr::filter(samples, start_date == individual_date)

    # extract temporal extent
    start_date <- min(date_data$start_date)
    end_date   <- max(date_data$end_date)

    data.frame(start_date = start_date, end_date = end_date)
  }))
}
