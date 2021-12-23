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
output_directory <- base_output_directory / "study-area"
fs::dir_create(output_directory)

#
# 1. Loading the input geometries.
#

# Cerrado biome geometry
cerrado_biom_geom <-
  sf::read_sf(base_input_directory / "01_study-area_cerrado/cerrado-biome.shp")

# Brazil Data Cube GRID for Landsat-8/OLI
datacube_grid_geom <-
  sf::read_sf(base_input_directory / "02_study-area_datacube-grid/datacube-grid-landsat8.shp")

#
# 2. Calculating the intersection between the loaded geometries.
#
intersection_geom <-
  sf::st_intersection(datacube_grid_geom, cerrado_biom_geom)

#
# 3. Saving the result. For this case, we will save only the tile-id, used as a
#    input to sits package to create the Data Cube.
#

# Selecting the tile ids
study_area_tile_ids <- data.frame(tile_id = intersection_geom$id)

# Saving the tile ids Data Frame
readr::write_csv(x = study_area_tile_ids, file = output_directory / "study-area_tile-ids.csv")
