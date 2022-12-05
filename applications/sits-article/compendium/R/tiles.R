#' @title Crop Raster files by shapefile extents
#'
#' @rdname tiles
#'
#' @description This function crops each tile through the shapefile extensions.
#'
#' @param files_path     a \code{character} with the full path of the rasters
#'                       that will be cropped.
#' @param shapefile_path a \code{character} with full path of the shapefile that
#'                       will be used to crop.
#' @param output_dir     a \code{character} with the directory where the images
#'                       cropped will be stored.
#' @param ...            additional parameters.
#' @param cores          a \code{numeric} with the number of cores.
#'
#' @return a \code{character} with the name of raster files.
#' @export
crop_tiles <- function(files_path, shapefile_path, output_dir, ..., cores = 4) {
  future::plan(future::multisession, workers = cores)

  furrr::future_map(files_path, function(file) {
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
#' @description This function creates a mosaic from a collection of rasters.
#'
#' @param files_path a \code{character} with the full path of the rasters
#'                   that will be used to mosaic.
#' @param output_dir a \code{character} with the directory where the mosaic will
#'                   be saved.
#' @param ...        additional parameters.
#'
#' @return todo
#' @export
mosaic_tiles <- function(files_path, output_file, ...) {
  gdalUtils::mosaic_rasters(
    files_path,
    output_file,
    force_ot = "UInt16",
    co = c("COMPRESS=LZW", "BIGTIFF=YES"),
    verbose = TRUE,
    ...
  )
}
