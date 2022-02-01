# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import json
from pathlib import Path

import pandas as pd
import geopandas as gpd

from settings import settings

import spectral_selector.selector as selector
from spectral_selector.comparator import distance

#
# General definitions
#

# Base input directory
input_dir = Path(settings.general.input_dir)

# Base output directory
output_dir = Path(settings.general.output_dir)

#
# Load required data (generated in the previous script/step)
#

# Bricks index file
bricks = pd.read_csv(output_dir / "brick" / "index.csv")
bricks = bricks["bricks"].to_list()


#
# 1. Loading the endmember samples
#
endmember_samples = {
    endmember_name: (
        gpd.read_file(settings.samples.database_file, layer=endmember_name)
        .to_crs(settings.datacube.crs)
        .geometry.tolist()
    )
    for endmember_name in settings.samples.endmember_samples_layers
}

#
# 2. Selecting the endmembers
#

# Selecting the scene reference
reference_scene_brick = list(
    filter(lambda x: settings.samples.scene_id_reference in str(x), bricks)
)

reference_scene_brick = reference_scene_brick[0]

# Generating the endmembers
endmember_selected = selector.temporal_endmember_selector(
    reference_scene_brick,
    bricks,
    endmember_samples,
    settings.endmember.endmember_similarity_threshold,
    distance.distance_inverse_bray_curtis_similarity,
    use_general_endmember=False,
    distance_type="permute",
    factor=10000,
    n_jobs=settings.resources.n_jobs,
)

#
# 3. Filtering the selected endmembers
#
endmember_selected = list(
    filter(
        lambda x: (
            all(
                all(val > 0 for val in x["endmembers"][em_name])
                for em_name in x["endmembers"]
            )
        ),
        endmember_selected,
    )
)

#
# 4. Saving the results
#
output_endmember_dir = output_dir / "endmember"
output_endmember_dir.mkdir(exist_ok=True, parents=True)

json.dump(endmember_selected, (output_endmember_dir / "index.json").open(mode="w"))
