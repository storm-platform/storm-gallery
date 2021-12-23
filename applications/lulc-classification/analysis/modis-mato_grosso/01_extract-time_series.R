set.seed(777)

#
# General definitions.
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
output_directory <- base_output_directory / "samples"

fs::dir_create(output_directory)

#
# 1. Defining the Data Cube.
#
datacube <- sits::sits_cube(
  source     = "BDC",
  collection = workflow_config$datacube$collection,
  start_date = workflow_config$datacube$start_date,
  end_date   = workflow_config$datacube$end_date,
  bands      = workflow_config$datacube$bands
)

#
# 2. Extracting the time-series of samples from the Data Cube.
#
samples_ts <- sits::sits_get_data(
  cube       = datacube,
  file       = base_input_directory / "01_ground-truth_samples/samples.csv",
  multicores = workflow_config$resources$multicores
)

#
# 3. Saving the extracted time-series.
#
saveRDS(samples_ts, output_directory / "samples-ts.rds")
