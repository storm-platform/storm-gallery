set.seed(777)

library(magrittr)

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
output_directory <-
  base_output_directory / "lulc-classification-mosaic"

fs::dir_create(output_directory)

#
# 1. Loading the required data
#

# Mato Grosso State geometry
mato_grosso_state_geom <-
  sf::read_sf(base_input_directory / "02_study-area_mato-grosso" / "mato-grosso_state.shp")

#
# 2. Transform the Shapefile CRS to the LULC Map CRS
#

# Loading raster CRS
lulc_raster_files <- fs::dir_ls(
  base_output_directory / "lulc-classification",
  recurse = T,
  regexp = "*class_v1.tif"
)

raster_crs <- terra::rast(lulc_raster_files[1]) %>% terra::crs()

# Creating the results directory
output_directory_geom <- output_directory / "shapefile"
study_area_geom_shp   <- output_directory_geom / "mato-grosso.shp"

fs::dir_create(output_directory_geom)

# Transforming the shapefile CRS and saving it.
sf::st_transform(mato_grosso_state_geom, raster_crs) %>%
  sf::write_sf(study_area_geom_shp)


#
# 3. Mosaicing each available year data
#

# Defining the output directory to the mosaics
output_directory_mosaic <- output_directory / "mosaic"
fs::dir_create(output_directory_mosaic)

# Getting the available years directories
lulc_generated_years <-
  fs::dir_ls(path = base_output_directory / "lulc-classification")

# Mosaicing!
lapply(lulc_generated_years, function(year_row) {
  #
  # 1. Listing the available LULC map files
  #
  lulc_raster_files <-
    fs::dir_ls(year_row,
               recurse = T,
               regexp = "*class_v1.tif")

  #
  # 2. Crop the available LULC raster by the shapefile extents
  #

  # Extracting the year
  current_year <- fs::path_file(year_row)

  # Creating the output directory
  output_directory_crop <- output_directory / "crop" / current_year
  fs::dir_create(output_directory_crop)

  # Cropping the raster files
  lulc_raster_files_cropped <-
    lulc::crop_tiles(
      file_path      = lulc_raster_files,
      shapefile_path = study_area_geom_shp,
      output_dir     = output_directory_crop,
      cores          = workflow_config$resources$multicores
    )

  #
  # 3. Mosaic the cropped rasters
  #

  # Making the mosaic
  lulc::mosaic_tiles(
    file_path   = unlist(lulc_raster_files_cropped, use.names = FALSE),
    output_file = output_directory_mosaic / paste0("mato-grosso", "_", current_year, ".tif")
  )
})
