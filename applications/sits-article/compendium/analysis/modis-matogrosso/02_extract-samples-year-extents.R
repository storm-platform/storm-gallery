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
# 1. Loading the samples with the extracted time-series.
#
samples_ts <-
  readRDS(file = output_directory / "samples-ts.rds")

#
# 2. Extracting the temporal extents of samples of each year available.
#
temporal_exents <- lulc::sample_temporal_extents(samples_ts)

#
# 3. Saving the extracted time extents.
#
readr::write_csv(x = temporal_exents,
                 file = output_directory / "samples-temporal-extents.csv")
