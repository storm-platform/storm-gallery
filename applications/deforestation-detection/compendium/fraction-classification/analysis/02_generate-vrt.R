# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

set.seed(777)

#
# General definitions.
#

# Workflow Configuration
workflow_config <-
  yaml::read_yaml("analysis/workflow.yaml")

#  > Base input directory
base_input_directory <-
  fs::path(workflow_config$files$base_input_directory)

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#  > Script specific output directory
output_directory <- base_output_directory / "mesma-vrt"
fs::dir_create(output_directory)

#
# 1. Loading the required data
#

# Endmember index
endmember_index <-
  jsonlite::read_json(base_input_directory / "endmember" / "index.json")

#
# 2. Extracting the available endmembers
#
endmember_names <- names(endmember_index[[1]]$endmembers)

#
# 3. Getting the available MESMA results.
#

# Base path to the MESMA result data
mesma_result_directory <- base_output_directory / "mesma"

# Full path files
available_mesma_results <-
  as.vector(fs::dir_ls(mesma_result_directory, regexp = "*.tif"))

#
# 4. Getting the available cloud bands.
#

# Base path to the cloud band data
cloud_band_directory <- base_input_directory / "stack"

# Full path files
available_cloud_band_files <-
  as.vector(fs::dir_ls(cloud_band_directory, regexp = "*.vrt"))

# File names
available_cloud_band_filenames <-
  fs::path_ext_remove(fs::path_file(available_cloud_band_files))

available_cloud_band_filenames <-
  unlist(lapply(available_cloud_band_filenames, function(x) {
    paste(strsplit(x, "_")[[1]][1:8], collapse = "_")
  }))


#
# 5. Generating the VRT files (in the required SITS package format).
#

lapply(available_mesma_results, function(mesma_result) {
  # getting the file name
  result_filename <-
    fs::path_ext_remove(fs::path_file(mesma_result))

  # Copying the cloud band files
  cloud_file <-
    available_cloud_band_files[available_cloud_band_filenames == result_filename]

  file.copy(from = cloud_file,
            to = output_directory / fs::path_file(cloud_file))

  # creating a single VRT for each endmember available
  lapply(1:length(endmember_names), function(index) {
    # defining the VRT filename
    endmember_name <- endmember_names[index]
    vrt_filename <-
      paste0(result_filename, "_", endmember_name, ".vrt")

    # selecting the band and save!
    output_file <- output_directory / vrt_filename

    gdalUtilities::gdalbuildvrt(
      gdalfile   = c(mesma_result),
      output.vrt = output_file,
      b          = index
    )
  })
})
