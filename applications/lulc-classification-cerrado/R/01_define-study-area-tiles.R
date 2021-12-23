#
# 1. Loading the input geometries
#

# Cerrado biom geometry
cerrado_biom_geom <-
  sf::read_sf("data/raw_data/01-study-area_cerrado/cerrado-biome.shp")

# Brazil Data Cube GRID for Landsat-8/OLI
datacube_grid_geom <-
  sf::read_sf("data/raw_data/02_study-area_datacube-grid/datacube-grid-landsat8.shp")

#
# 2. Calculating the intersection between the loaded geometries
#
intersection_geom <-
  sf::st_intersection(datacube_grid_geom, cerrado_biom_geom)

#
# 3. Saving the result. For this case, we will save only the tile-id, used as a
#    input to sits package to create the datacube.
#

# Selecting and saving the tile id results
study_area_tile_ids <- data.frame(tile_id = intersection_geom$id)

# Saving the Data Frame
write.csv(study_area_tile_ids, file = "data/derived_data/study-area_tile-ids.csv")

# ToDo: paste("0", study_area_tile_ids$tile_id, sep = "")
