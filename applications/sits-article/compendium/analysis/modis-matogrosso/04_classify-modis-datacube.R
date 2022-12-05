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
  yaml::read_yaml("analysis/modis-mato_grosso/workflow.yaml")

#  > Base input directory
base_input_directory <-
  fs::path(workflow_config$files$base_input_directory)

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#  > Script specific output directory
output_directory <- base_output_directory / "lulc-classification"

fs::dir_create(output_directory)

#
# 1. Loading the required data
#

# Samples
sample_year_extents <-
  readr::read_csv(file = base_output_directory / "samples" / "samples-temporal-extents.csv")

# Support Vector Machine model (Radial Kernel)
svm_model_trained <-
  readRDS(base_output_directory / "model" / "svm-trained_magro-grosso_modis.rds")

# Region of Interest shapefile (Mato Grosso State - Brazil)
shapefile_roi <-
  sf::read_sf(base_input_directory / "02_study-area_mato-grosso" / "mato-grosso_state.shp")


#
# 2. Defining the output directory based on the classification year selected.
#

# Selecting the classification year based on the index defined by the user.
selected_year_extent <-
  sample_year_extents[classification_year_index, ]

# Defining the output directory
output_directory <-
  output_directory / format(selected_year_extent$start_date, "%Y")

# Creating the directory
fs::dir_create(output_directory)

#
# 3. Preparing the ROI bbox object
#

# Calculating the bbox
study_area_bbox <- sf::st_bbox(shapefile_roi)

# Changing the object names
names(study_area_bbox) <-
  c("lon_min", "lat_min", "lon_max", "lat_max")


#
# 4. Loading the Data Cube
#
datacube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  start_date = selected_year_extent$start_date,
  end_date   = selected_year_extent$end_date,
  bands      = workflow_config$datacube$bands,
  roi        = study_area_bbox
)

#
# 5. Generating the LULC map by classifying the Data Cube data.
#
tile_classification <- lulc::classify_tile(
  cube       = datacube,
  model      = svm_model_trained,
  multicores = workflow_config$resources$multicores,
  memsize    = workflow_config$resources$memsize,
  output_dir = output_directory,
  roi        = study_area_bbox
)

#
# 6. Saving the results
#

# Labels
saveRDS(tile_classification$labels, file = output_directory / "labels.rds")

# Probs
saveRDS(tile_classification$probs, file = output_directory / "probs_cube.rds")

# Smoothed Probs
saveRDS(tile_classification$probs_smooth,
        file = output_directory / "probs_smoothed_cube.rds")
