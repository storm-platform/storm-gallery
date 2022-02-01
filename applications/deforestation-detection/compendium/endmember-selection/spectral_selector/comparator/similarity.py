# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from pathlib import Path
from typing import List, Dict, Union

import numpy as np
import rasterio as rio

from shapely.geometry import Point

from joblib import Parallel, delayed

from spectral_selector.comparator.puzzle import (
    compare_distance_pair,
    compare_distance_permute,
)


def _extract_values_by_geometry(raster_ds, points: List[Point]):
    return list(raster_ds.sample([(p.x, p.y) for p in points]))


def get_most_similar_spectra(
    brick_reference: Union[Path, str],
    bricks_to_compare: List[Union[Path, str]],
    location: List[Point],
    distance_function,
    distance_threshold,
    comparation_type="permute",
    use_general_endmember=False,
    n_jobs=2,
    random_seed=777,
    **kwargs
) -> Dict:

    # Defining a reproducible random values generator
    rng = np.random.default_rng(seed=random_seed)

    # Defining the comparation method
    dst_method = (
        compare_distance_pair
        if comparation_type == "pair"
        else compare_distance_permute
    )

    # Extracting the reference spectra
    reference_rst = rio.open(brick_reference)
    reference_spectra = _extract_values_by_geometry(reference_rst, location)

    # Preparing the processing function
    def _select_spectra_from_vrt(vrt_file):
        """Select the spectra from VRT."""

        rast = rio.open(vrt_file)
        rast_spectra = _extract_values_by_geometry(rast, location)

        selected_spectral = dst_method(
            reference_spectra,
            rast_spectra,
            distance_function,
            distance_threshold,
            use_general_endmember,
            random_generator=rng,
            **kwargs
        )

        return vrt_file, selected_spectral

    # Processing!
    res = Parallel(n_jobs=n_jobs)(
        delayed(_select_spectra_from_vrt)(raster_vrt)
        for raster_vrt in bricks_to_compare
    )

    return {key: value for key, value in res}
