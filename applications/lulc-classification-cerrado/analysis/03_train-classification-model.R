set.seed(777)

#
# General definitions
#

# Loading the workflow configurations
workflow_config <- yaml::read_yaml("analysis/workflow.yaml")

#  > Base output directory
base_output_directory <-
  fs::path(workflow_config$files$base_output_directory)

#
# 1. Loading the samples with the extracted time-series.
#
samples_ts <-
  readRDS(file = base_output_directory / "samples" / "samples-ts.rds")


#
# 2. Filtering the annual samples (with 24 temporal attributes).
#
annual_samples <- cerradolulc::filter_annual_samples(samples_ts)


#
# 3. Creating the Random Forest Model (with 200 Trees)
#
rfor_model <- sits::sits_rfor(num_trees = workflow_config$model$num_trees)


#
# 4. Training the model
#
rfor_model_trained <- sits::sits_train(annual_samples, rfor_model)


#
# 5. Saving the trained model
#
output_directory <- base_output_directory / "model"
fs::dir_create(output_directory)

saveRDS(rfor_model_trained, file = output_directory / "rfor200_cerrado-lc8.rds")
