set.seed(777)

#
# 1. Loading the Study Area Tile IDs
#
study_area_tile_ids <-
  read.csv("data/derived_data/study-area_tile-ids.csv")

#
# 2. Defining the Data Cube
#

# Landsat-8/OLI datacube
datacube <- sits::sits_cube(
  source     = "BDC",
  collection = "LC8_30_16D_STK-1",
  start_date = "2017-08-29",
  end_date   = "2018-08-29",
  tiles      = paste("0", study_area_tile_ids$tile_id, sep = "")
)

#
# 3. Extracting the samples time-series from the Data Cube
#
samples_ts <- sits::sits_get_data(cube       = datacube,
                                  file       = "data/raw_data/03_ground-truth_samples/samples.csv",
                                  multicores = 4)

#
# 4. Saving the extracted time-series
#
saveRDS(samples_ts, "data/derived_data/samples-ts.rds")
