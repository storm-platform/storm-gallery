set.seed(777)

#
# CLI (Rscript 04_classify-lc8-datacube.R <TILE-NAME>)
#

# Loading the command arguments
cmdargs <- commandArgs(trailingOnly = TRUE)

# Extracting the Tile ID
tile_id <- args[1]


#
# General definitions
#

# Loading the workflow configurations
workflow_config <- yaml::read_yaml("analysis/workflow.yaml")

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#
# 1. Loading the required data
#

# Study area tiles reference
study_area_tile_ids <-
  readr::read_csv(output_directory / "study-area" / "study-area_tile-ids.csv")


# Trained Random Forest (trees = 200) model
rfor_model_trained <-
  readRDS(output_directory / "model" / "rfor200_cerrado-lc8.rds")

#
# 2. Loading the Data Cube
#

# Landsat-8/OLI Data Cube
datacube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  start_date = workflow_config$datacube$start_date,
  end_date   = workflow_config$datacube$end_date,
  bands      = workflow_config$datacube$bands,
  tiles      = tile_id
)


#
# 3. Generating the LULC map by classifying the Data Cube data.
#
tile_classification <- cerradolulc::classify_tile(
  cube       = datacube,
  model      = rfor_model_trained,
  multicores = workflow_config$resources$multicores,
  memsize    = workflow_config$resources$memsize,
)

#
# 4. Saving the results
#
output_directory <-
  base_output_directory / "lulc-classification" / tile_id
fs::dir_create(output_directory)

# Labels
saveRDS(tile_classification$labels, file = output_directory / "labels.rds")

# Probs
saveRDS(tile_classification$probs, file = output_directory / "probs_cube.rds")

# Smoothed Probs
saveRDS(tile_classification$probs_smooth,
        file = output_directory / "probs_smoothed_cube.rds")
