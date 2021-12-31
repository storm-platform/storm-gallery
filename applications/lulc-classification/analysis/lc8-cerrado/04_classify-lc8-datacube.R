set.seed(777)

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

fs::dir_create(output_directory)

#
# 1. Loading the required data
#

# Study area tiles reference
study_area_tile_ids <-
  readr::read_csv(base_output_directory / "study-area" / "study-area_tile-ids.csv")


# Trained Random Forest model
rfor_model_trained <-
  readRDS(base_output_directory / "model" / "rfor_cerrado_lc8.rds")

#
# 2. Loading the Data Cube
#

datacube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  start_date = workflow_config$datacube$start_date,
  end_date   = workflow_config$datacube$end_date,
  bands      = workflow_config$datacube$bands,
  tiles      = study_area_tile_ids$tile_id
)


#
# 3. Generating the LULC map by classifying the Data Cube data.
#
tile_classification <- lulc::classify_tile(
  cube       = datacube,
  model      = rfor_model_trained,
  multicores = workflow_config$resources$multicores,
  memsize    = workflow_config$resources$memsize,
  output_dir = output_directory
)

#
# 4. Saving the results
#

# Labels
saveRDS(tile_classification$labels, file = output_directory / "labels.rds")

# Probs
saveRDS(tile_classification$probs, file = output_directory / "probs_cube.rds")

# Smoothed Probs
saveRDS(tile_classification$probs_smooth,
        file = output_directory / "probs_smoothed_cube.rds")
