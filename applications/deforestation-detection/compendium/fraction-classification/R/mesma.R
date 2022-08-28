# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

#' @title Parallel job process using Snowball (Internal method with specific cluster
#' configuration method).
#'
#' @rdname apply-custer
#'
#' @description This function applies a data into a parallel function.
#'
#' @param cl a \code{Snowball cluster object}.
#' @param x a \code{list} of objects to be processed.
#' @param fun a \code{function} to be executed in a parallel way based on the data
#' defined.
#' @param ... extra options for the job function handler.
#'
#' @return a \code{list} with the description of the executed job.
#'
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


#' @title Parallel worker unit function to generate fraction image.
#'
#' @rdname mixture-model
#'
#' @description This function calculates a fraction image for a piece of a
#' Raster Brick.
#'
#' @param job  a \code{list} with the definitions of the worker job to be executed
#' in the function.
#' @param em a \code{data.frame} with the definitions of the endmembers.
#'
#' @return a \code{list} with the description of the executed job.
#'
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


#' @title Generate job objects.
#'
#' @rdname make-jobs
#'
#' @description This function generates mesma job objects.
#'
#' @param f  a \code{character} with the path to the image to be processed.
#' @param dtype_out a \code{character} describing the output data type.
#' @param no_data_out a \code{numeric} value to used as the default no data value
#' in the generated raster.
#' @param gdal_options a \code{character} with extra options for the GDAL.
#' @param data_factor a \code{numeric} value defining the multiplication factor
#' for the image pixel values.
#' @param endmember a \code{data.frame} with the endmembers.
#'
#' @return a \code{list} with the description of the executed job.
#'
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

#' @title Parallel job process using Snowball (Internal method with specific cluster
#' configuration method).
#'
#' @rdname do-parallel-jobs
#'
#' @description This function generates mesma job objects.
#'
#' @param cl a \code{Snowball cluster object}.
#' @param x a \code{list} of objects to be processed.
#' @param fun a \code{function} to be executed in a parallel way based on the data
#' defined.
#' @param no_data_out a \code{numeric} value to used as the default no data value
#' in the generated raster.
#' @param gdal_options a \code{character} with extra options for the GDAL.
#' @param data_factor a \code{numeric} value defining the multiplication factor
#' for the image pixel values.
#' @param endmember a \code{data.frame} with the endmembers.
#'
#' @return a \code{list} with the description of the executed job.
#'
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


#' @title Generate fraction images applying the mesma linear mixture model.
#'
#' @rdname mesma
#'
#' @description This function generates fraction images using mesma mixture model.
#' To calculate the endmember fractions, the non-negative least squares (NNLS)
#' solver is used. The NNLS implementation was made by Jakob Schwalb-Willmann in
#' RStoolbox package (licensed as GPL>=3).
#'
#' @param raster_in a \code{character} with the path to the input Raster Brick.
#' @param raster_out a \code{character} with the path to the output Raster Brick.
#' @param endmember a \code{data.frame} with the definitions of the endmembers.
#' @param ... extra options for the job generator function (\code{make_jobs}).
#' @param multicores a \code{numeric} value defining the number of CPU cores to
#' be used to generate fraction images.
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
