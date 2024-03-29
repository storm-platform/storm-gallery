% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tiles.R
\name{crop_tiles}
\alias{crop_tiles}
\alias{mosaic_tiles}
\title{Crop Raster files by shapefile extents}
\usage{
crop_tiles(files_path, shapefile_path, output_dir, ..., cores = 4)

mosaic_tiles(files_path, output_file, ...)
}
\arguments{
\item{files_path}{a \code{character} with the full path of the rasters
that will be used to mosaic.}

\item{shapefile_path}{a \code{character} with full path of the shapefile that
will be used to crop.}

\item{output_dir}{a \code{character} with the directory where the mosaic will
be saved.}

\item{...}{additional parameters.}

\item{cores}{a \code{numeric} with the number of cores.}
}
\value{
a \code{character} with the name of raster files.

todo
}
\description{
This function crops each tile through the shapefile extensions.

This function creates a mosaic from a collection of rasters.
}
