

#' @title Crop Raster files by shapefile extents
#'
#' @rdname tiles
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
crop_tiles <-
  function(file_path,
           shapefile_path,
           output_dir,
           ...,
           cores = 4) {
    future::plan(future::multisession, workers = cores)

    furrr::future_map(file_path, function(file) {
      result_file <- fs::path(output_dir) / basename(file)

      gdalUtilities::gdalwarp(
        srcfile = file,
        dstfile = result_file,
        cutline = shapefile_path,
        crop_to_cutline = TRUE,
        co = c("COMPRESS=LZW", "BIGTIFF=YES"),
        srcnodata = 0,
        ...
      )

      result_file
    })
  }

#' @title Mosaic rasters
#'
#' @rdname tiles
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
mosaic_tiles <- function(file_path, output_file, ...) {
  gdalUtils::mosaic_rasters(
    file_path,
    output_file,
    force_ot = "UInt16",
    co = c("COMPRESS=LZW", "BIGTIFF=YES"),
    verbose = TRUE,
    ...
  )
}
