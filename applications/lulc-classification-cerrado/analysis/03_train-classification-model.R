set.seed(777)

#
# 1. Loading the samples with the extracted time-series
#

samples_ts <- readRDS(file = "data/derived_data/samples-ts.rds")


#
# 2. Filtering the annual samples (with 24 time attributes).
#

annual_samples <- cerradolulc::filter_annual_samples(samples_ts)


#
# 3. Creating the Random Forest Model (with 200 Trees)
#
rfor_model <- sits::sits_rfor(num_trees = 200)


#
# 4. Training the model
#
rfor_model_trained <- sits::sits_train(annual_samples, rfor_model)


#
# 5. Saving the trained model
#
saveRDS(rfor_model_trained, file = "data/derived_data/rfor200_cerrado-lc8.rds")
