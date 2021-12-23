set.seed(777)

#
# CLI (Rscript 04_classify-modis-datacube.R <Classification Year Index [1:16]>)
#

# Loading the command arguments
cmdargs <- commandArgs(trailingOnly = TRUE)

# Extracting the Classification Year Index
classification_year_index <- as.numeric(cmdargs[1])

#
# General definitions
#

# Workflow Configuration
workflow_config <-
  yaml::read_yaml("analysis/lc8-cerrado/workflow.yaml")

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#  > Script specific output directory
output_directory <-
  base_output_directory / "lulc-classification"

#
# 1. Loading the required data
#

# Samples
sample_year_extents <-
  readr::read_csv(file = base_output_directory / "samples" / "samples-temporal-extents.csv")

# Trained Random Forest (trees = 200) model
rfor_model_trained <-
  readRDS(base_output_directory / "model" / "rfor200_cerrado_lc8.rds")


#
# 2. Defining the output directory based on the classification year selected.
#

# Selecting the classification year based on the index defined by the user.
selected_temporal_extent <-
  sample_temporal_extents[classification_year_index, ]

# Defining the output directory
output_directory <-
  output_directory / format(selected_temporal_extent$start_date, "%Y")

# Creating the directory
fs::dir_create(output_directory)

#
# 3. Loading the Data Cube
#
datacube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  start_date = selected_temporal_extent$start_date,
  end_date   = selected_temporal_extent$end_date,
  bands      = workflow_config$datacube$bands
)

#
# 4. Generating the LULC map by classifying the Data Cube data.
#
tile_classification <- lulc::classify_tile(
  cube       = datacube,
  model      = rfor_model_trained,
  multicores = workflow_config$resources$multicores,
  memsize    = workflow_config$resources$memsize,
  output_dir = output_directory
)

#
# 5. Saving the results
#

# Labels
saveRDS(tile_classification$labels, file = output_directory / "labels.rds")

# Probs
saveRDS(tile_classification$probs, file = output_directory / "probs_cube.rds")

# Smoothed Probs
saveRDS(tile_classification$probs_smooth,
        file = output_directory / "probs_smoothed_cube.rds")
