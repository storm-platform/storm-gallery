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
output_directory <- base_output_directory / "mesma"
fs::dir_create(output_directory)

#
# 1. Loading the required data
#

# Endmember index
endmember_index <-
  jsonlite::read_json(base_input_directory / "endmember" / "index.json")

#
# 2. Getting the available bricks
#

# base path to the brick data
brick_directory <- base_input_directory / "brick"

# Full path files
available_bricks <- as.vector(fs::dir_ls(brick_directory))

# File names
available_brick_filenames <-
  fs::path_ext_remove(fs::path_file(available_bricks))

#
# 3. Applying the Multiple Endmember Spectral Mixture Analysis (MESMA)
#

# defining the scale factor to be applied in the data.
scale_factor = 10000  # also used by the `fraction::mesma`

lapply(endmember_index, function(endmember_row) {
  # loading the endmember spectra
  endmember_spectra <-
    fraction::as.endmember.data.frame(endmember_row$endmembers) / scale_factor

  # getting the endmember file
  endmember_raster_file <-
    available_bricks[endmember_row$file_id == available_brick_filenames]

  # defining the output file
  output_file <-
    output_directory / paste0(endmember_row$file_id, ".tif")

  # do MESMA!
  fraction::mesma(
    raster_in    = endmember_raster_file,
    raster_out   = output_file,
    endmember    = endmember_spectra,
    multicores   = workflow_config$resources$multicores,
  )
})
