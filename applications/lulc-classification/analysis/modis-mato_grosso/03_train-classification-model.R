set.seed(777)

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
output_directory <- base_output_directory / "model"

fs::dir_create(output_directory)

#
# 1. Loading the samples with the extracted time-series.
#
samples_ts <-
  readRDS(file = base_output_directory / "samples" / "samples-ts.rds")

#
# 2. Creating the Support Vector Machine model (Radial Kernel).
#
svm_model <- sits::sits_svm()

#
# 3. Training the model
#
svm_model_trained <- sits::sits_train(samples_ts, svm_model)

#
# 4. Saving the trained model
#
saveRDS(svm_model_trained, file = output_directory / "svm-radial_magro-grosso_modis.rds")
