# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from pathlib import Path

import pandas as pd
import geopandas as gpd
from shapely.geometry import Point

import rasterio as rio

from settings import settings

#
# General definitions
#

# Base input directory
input_dir = Path(settings.general.input_dir)

# Base output directory
output_dir = Path(settings.general.output_dir)

#
# 1. Loading the required data
#

# Normalized validation sample
samples = pd.read_csv(output_dir / "normalized-samples" / "validation-samples.csv")

# Deforestation map
deforestation_map = rio.open(
    input_dir
    / "deforestation-map"
    / "LANDSAT-8_OLI_038047_2018-08-29_2019-08-29_class_v1.tif"
)

#
# 2. Creating a spatial data frame with the samples
#

# Creating the point geometry
geometries = samples.assign(
    geometry=[Point(x.longitude, x.latitude) for idx, x in samples.iterrows()]
)
geometries = gpd.GeoDataFrame(geometries, crs=4326)
geometries = geometries.to_crs(deforestation_map.crs)

#
# 3. Extracting the values from the deforestation map
#

# Location points
sample_points = [(p.x, p.y) for p in geometries.geometry.values]

# Extracting
values_extracted = list(deforestation_map.sample(sample_points))

# Saving the extracted result
samples["label_predicted"] = [val[0] for val in values_extracted]

# Removing na values (values out of raster extents)
samples = samples[~(samples["label_predicted"] == 0)]

#
# 4. Saving the samples dataset
#

# Defining the output directory
output_dir_samples = output_dir / "samples-with-predicted-values"
output_dir_samples.mkdir(exist_ok=True, parents=True)

# Saving the data
samples.to_csv(output_dir_samples / "validation-samples.csv", index=False)
