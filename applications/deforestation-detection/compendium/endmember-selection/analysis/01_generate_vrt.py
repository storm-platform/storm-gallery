# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from pathlib import Path

import pandas as pd

from pystac_client import Client as StacClient

from settings import settings
import spectral_selector.virtual as virtual

#
# General definitions
#

# Base input directory
input_dir = Path(settings.general.input_dir)

# Base output directory
output_dir = Path(settings.general.output_dir)

#
# 1. Searching for STAC items
#

# Defining the stac client
stac_parameters = dict(access_token=settings.BDC_ACCESS_TOKEN)
stac_client = StacClient.open(settings.stac.url, parameters=stac_parameters)

# Searching for the STAC items
search_result = stac_client.search(
    bbox=settings.datacube.spatial_extent,
    collections=[settings.datacube.collection],
    datetime=f"{settings.datacube.start_date}/{settings.datacube.end_date}",
)

# Extracting the STAC items returned in the search
items = search_result.get_items()

#
# 2. Filtering items by cloud cover
#
items = list(
    filter(
        lambda item: (
            item.properties["eo:cloud_cover"] < settings.datacube.cloud_cover_threshold
        ),
        items,
    )
)

#
# 3. Generating the brick VRTs files with the spectral bands reference
#
output_brick_dir = output_dir / "brick"
output_brick_dir.mkdir(exist_ok=True, parents=True)

bricks = virtual.item2brick_vrt(
    items, settings.datacube.spectral_bands, output_brick_dir
)

#
# 4. Generating the stack VRT files with the cloud band reference
#
output_stack_dir = output_dir / "stack"
output_stack_dir.mkdir(exist_ok=True, parents=True)

stacks = virtual.item2stack_vrt(items, [settings.datacube.cloud_band], output_stack_dir)

#
# 5. Saving the generated bricks VRTs
#
(pd.DataFrame(dict(bricks=bricks)).to_csv(output_brick_dir / "index.csv"))

