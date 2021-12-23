set.seed(777)

#
# General definitions.
#

# Loading the workflow configurations
workflow_config <- yaml::read_yaml("analysis/workflow.yaml")

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#
# 1. Loading the Study Area Tile IDs.
#
study_area_tile_ids <-
  read.csv(base_output_directory  / "study-area" / "study-area_tile-ids.csv")

#
# 2. Defining the Data Cube.
#

# Landsat-8/OLI datacube
datacube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  start_date = workflow_config$datacube$start_date,
  end_date   = workflow_config$datacube$end_date,
  bands      = workflow_config$datacube$bands,
  tiles      = study_area_tile_ids$tile_id
)

#
# 3. Extracting the samples time-series from the Data Cube.
#
samples_ts <- sits::sits_get_data(
  cube       = datacube,
  file       = "data/raw_data/03_ground-truth_samples/samples.csv",
  multicores = workflow_config$resources$multicores
)

#
# 4. Saving the extracted time-series.
#
output_directory <- base_output_directory / "samples"
fs::dir_create(output_directory)

saveRDS(samples_ts, output_directory / "samples-ts.rds")
