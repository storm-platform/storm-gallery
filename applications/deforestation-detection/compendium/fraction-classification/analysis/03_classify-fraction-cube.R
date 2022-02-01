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
output_directory <- base_output_directory / "mesma-classification"
fs::dir_create(output_directory)

#
# SITS Package configuration
#

# Defining the SITS configuration (to support the fraction bands)
Sys.setenv("SITS_CONFIG_USER_FILE" = "config/sits.yml")

#
# Load the required data
#

# Defining the samples source file
samples_file <- output_directory / "deforestation-samples.csv"

#
# 1. Converting the deforestation sample from OGC GeoPackage to CSV (required to use SITS Package)
#

# Read the deforestation sample from the OGC GeoPackage
deforestation_samples <-
  sf::st_read(dsn   = base_input_directory / "samples-database.gpkg",
              layer = "deforestation-samples")

# Converting to CSV
deforestation_samples <-
  sf::st_as_sf(
    x      = deforestation_samples,
    coords = c("longitude", "latitude"),
    crs    = 4326
  )

# Saving the CSV with the deforestation samples
sf::st_write(
  obj          = deforestation_samples,
  dsn          = samples_file,
  delete_dsn   = TRUE
)

#
# 2. Creating the Data Cube
#

# Defining the data cube source
vrt_dir <- base_output_directory / "mesma-vrt"

# Creating the data cube
fraction_cube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  data_dir   = vrt_dir,
  delim      = workflow_config$datacube$delim,
  parse_info = workflow_config$datacube$parse_info
)

#
# 3. Extracting the Time Series from the Data Cube
#

# Extracting the Time Series
samples_ts <- sits::sits_get_data(
  cube       = fraction_cube,
  file       = samples_file,
  multicores = workflow_config$resources$multicores
)

# Filtering NA values (caused by the interpolation method)
samples_ts <-
  samples_ts[!sapply(samples_ts$time_series, function(x) {
    any(is.na(x))
  }), ]


#
# 4. Training the Machine Learning Model
#

# Defining a Random Forest model
ml_model <- sits::sits_rfor(num_trees = 200)

# Training!
ml_model <- sits::sits_train(data      = samples_ts,
                             ml_method = ml_model)

#
# 5. Classifying the Data Cube
#

# Classifying!
probs <- sits::sits_classify(
  data       = fraction_cube,
  ml_model   = ml_model,
  memsize    = workflow_config$resources$memsize,
  multicores = workflow_config$resources$multicores,
  output_dir = output_directory
)

# Smoothing the classification probabilities
probs_smoothed <- sits::sits_smooth(
  cube       = probs,
  type       = "bayes",
  output_dir = output_directory,
  memsize    = workflow_config$resources$memsize,
  multicores = workflow_config$resources$multicores
)

# Generating the LULC labels
labels  <- sits::sits_label_classification(
  cube       = probs_smoothed,
  output_dir = output_directory,
  memsize    = workflow_config$resources$memsize,
  multicores = workflow_config$resources$multicores
)

#
# 6. Saving the results
#

# Labels
saveRDS(labels, file = output_directory / "labels.rds")

# Probabilities
saveRDS(probs, file = output_directory / "probs_cube.rds")

# Probabilities (Smoothed)
saveRDS(probs_smoothed, file = output_directory / "probs_smoothed_cube.rds")

# Time Series
saveRDS(samples_ts, file = output_directory / "samples_ts.rds")

# ML Model (Trained)
saveRDS(ml_model, file = output_directory / "trained_model.rds")
