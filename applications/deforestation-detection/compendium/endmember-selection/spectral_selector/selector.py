# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import warnings
from typing import List, Dict, Union

from pathlib import Path

from spectral_selector.comparator.similarity import get_most_similar_spectra


def temporal_endmember_selector(
    brick_reference: Union[Path, str],
    bricks_to_compare: List[Union[Path, str]],
    endmember_geometry_set: dict,
    endmember_distance_threshold: Dict,
    distance_function,
    use_general_endmember=False,
    distance_type="permute",
    **kwargs
) -> List:

    if use_general_endmember:
        warnings.warn(
            "The assume_general_endmember option that allows the use of base "
            + "endmembers in previous times is enabled"
        )

    endmember_per_file = {}
    for endmember_name in endmember_geometry_set:
        endmember_geom = endmember_geometry_set[endmember_name]
        endmember_threshold = endmember_distance_threshold[endmember_name]

        em = get_most_similar_spectra(
            brick_reference,
            bricks_to_compare,
            endmember_geom,
            distance_function,
            endmember_threshold,
            distance_type,
            use_general_endmember,
            **kwargs
        )

        # saving endmembers per file
        for file in em:
            if file not in endmember_per_file:
                endmember_per_file[file] = {"endmembers": {}}
            endmember_per_file[file]["endmembers"][endmember_name] = em[file].tolist()

    return [
        {
            "file_id": Path(em_file).stem,
            "endmembers": endmember_per_file[em_file]["endmembers"],
        }
        for em_file in endmember_per_file
    ]
