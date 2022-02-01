set.seed(777)

#
# General definitions.
#

# Workflow Configuration
workflow_config <-
  yaml::read_yaml("analysis/lc8-cerrado/workflow.yaml")

#  > Base input directory
base_input_directory <-
  fs::path(workflow_config$files$base_input_directory)

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#  > Script specific output directory
output_directory <- base_output_directory / "samples"
fs::dir_create(output_directory)

#
# 1. Loading the Study Area Tile IDs.
#
study_area_tile_ids <-
  readr::read_csv(base_output_directory  / "study-area" / "study-area_tile-ids.csv")

#
# 2. Defining the Data Cube.
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
# 3. Extracting the time-series of samples from the Data Cube.
#
samples_ts <- sits::sits_get_data(
  cube       = datacube,
  file       = base_input_directory / "03_ground-truth_samples/samples.csv",
  multicores = workflow_config$resources$multicores
)

#
# 4. Saving the extracted time-series.
#
saveRDS(samples_ts, output_directory / "samples-ts.rds")
