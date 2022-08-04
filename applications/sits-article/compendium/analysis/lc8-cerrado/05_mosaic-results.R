set.seed(777)

library(magrittr)

#
# General definitions
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
output_directory <-
  base_output_directory / "lulc-classification-mosaic"

fs::dir_create(output_directory)

#
# 1. Loading the required data
#

# LULC classification maps
lulc_raster_files <-
  fs::dir_ls(
    base_output_directory / "lulc-classification",
    recurse = T,
    regexp = "*class_v1.tif"
  )

# Cerrado biome geometry
cerrado_biom_geom <-
  sf::read_sf(base_input_directory / "01_study-area_cerrado/cerrado-biome.shp")

#
# 2. Transform the Shapefile CRS to LULC Map CRS
#

# Loading raster CRS
raster_crs <- terra::rast(lulc_raster_files[1]) %>% terra::crs()

# Creating the results directory
output_directory_geom <- output_directory / "shapefile"
output_directory_geom_shp <- output_directory_geom / "cerrado.shp"

fs::dir_create(output_directory_geom)

# Transforming the shapefile CRS and saving it.
sf::st_transform(cerrado_biom_geom, raster_crs) %>%
  sf::write_sf(output_directory_geom_shp)

#
# 3. Crop the LULC raster by the shapefile extents
#

# Creating the output directory
output_directory_crop <- output_directory / "crop"

fs::dir_create(output_directory_crop)

# Cropping the raster files
lulc_raster_files_cropped <-
  lulc::crop_tiles(
    files_path      = lulc_raster_files,
    shapefile_path = output_directory_geom_shp,
    output_dir     = output_directory_crop,
    cores          = workflow_config$resources$multicores
  )


#
# 4. Mosaic the cropped rasters
#

# Creating the output directory
output_directory_mosaic <- output_directory / "mosaic"

fs::dir_create(output_directory_mosaic)

# Making the mosaic
lulc::mosaic_tiles(files_path   = names(lulc_raster_files_cropped),
                   output_file = output_directory_mosaic / "cerrado.tif")
