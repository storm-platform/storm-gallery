# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

do_mixture_model <- function(job, em) {
  b <- raster::stack(job$f)

  # crop to job
  b <-
    raster::crop(b,
                 raster::extent(b, job$row, job$row + job$nrows - 1, 1,
                                raster::ncol(b)))
  # doing MESMA
  probs <-
    RStoolbox::mesma(b / job$factor, job$endmember, method = "NNLS")

  # ceiling
  probs <- ceiling(probs * job$factor)

  raster::writeRaster(
    x         = probs,
    filename  = job$f_out,
    datatype  = job$dtype,
    format    = job$format,
    overwrite = TRUE,
    NAflag    = job$no_data,
    options   = job$options
  )

  return(job)
}


make_jobs <- function(f,
                      dtype_out    = "Int16",
                      no_data_out  = -9999,
                      gdal_options = "COMPRESS=LZW",
                      data_factor  = 10000,
                      endmember    = NULL) {
  b <- raster::brick(f)
  bs <- raster::blockSize(b)
  bs$n <- NULL

  jobs <- unname(do.call(mapply, args = c(list(
    FUN      = list,
    SIMPLIFY = FALSE,
    f        = f
  ), bs)))

  # generate jobs specification
  jobs <- lapply(jobs, function(x) {
    x$f_out <- tempfile(
      pattern = paste(tools::file_path_sans_ext(basename(x$f)), sep = "_"),
      tmpdir = dirname(x$f),
      fileext = ".tif"
    )

    x$dtype     <- dtype_out
    x$no_data   <- no_data_out
    x$options   <- gdal_options
    x$endmember <- endmember
    x$factor    <- data_factor
    x$format    <- "GTiff"
    x
  })
  return(jobs)
}


.apply_cluster <- function(cl, x, fun, ..., .quiet = FALSE) {
  if (!.quiet)
    pb <- txtProgressBar(max = length(x) + 1, style = 3)

  argfun <- function(i) {
    if (!.quiet)
      setTxtProgressBar(pb, i)
    c(list(x[[i]]), list(...))
  }

  if (!is.null(cl)) {
    res <- snow::dynamicClusterApply(cl, fun, length(x), argfun)
  } else {
    res <- lapply(x, function(i) {
      do.call(fun, args = argfun(i))
    })
  }

  if (!.quiet) {
    setTxtProgressBar(pb, length(x) + 1)
    close(pb)
  }

  return(res)
}


do_parallel_jobs <-
  function(file_out,
           jobs,
           multicores = 4) {
    # create snow cluster (SOCK)
    cl <- snow::makeSOCKcluster(multicores)
    on.exit({
      snow::stopCluster(cl)
    })

    # process
    message("Processing...")
    snow::clusterEvalQ(cl, library(raster))

    l <- .apply_cluster(cl  = cl,
                        x   = jobs,
                        fun = do_mixture_model)

    # merge results (call system gdalwarp)
    message("Merging result...")
    files <- paste(sapply(l, function(x)
      x$f_out), collapse = " ")
    cmd <-
      sprintf("gdalwarp -co COMPRESS=LZW %s %s", files, file_out)
    system(cmd, wait = TRUE, show.output.on.console = TRUE)

    return(invisible(NULL))
  }

#' @title Crop Raster files by shapefile extents
#'
#' @rdname mesma
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
mesma <-
  function(raster_in,
           raster_out,
           endmember,
           ...,
           multicores = 4) {
    mesma_jobs <- make_jobs(f         = raster_in,
                            endmember = endmember,
                            ...)

    do_parallel_jobs(file_out     = raster_out,
                     jobs         = mesma_jobs,
                     multicores   = multicores)
  }
