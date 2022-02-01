# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.


import warnings
from typing import List

import numpy as np


def _is_in_threshold(element, threshold):
    threshold_fnc = lambda x: x >= 0 and x <= threshold
    if type(threshold) == tuple:
        threshold_fnc = lambda x: x >= threshold[0] and x <= threshold[1]

    return threshold_fnc(element)


def compare_distance_pair(
    reference_spectra: List[np.ndarray],
    point_spectra: List[np.ndarray],
    distance_function,
    distance_threshold,
    assume_general_endmember,
    random_generator,
    **kwargs
) -> List:

    assert len(reference_spectra) == len(point_spectra)

    distances = []
    for rs, ps in zip(reference_spectra, point_spectra):
        _dst = distance_function(rs, ps, **kwargs)

        distances.append(_dst)
        if distance_threshold != "min":
            if _is_in_threshold(_dst, distance_threshold):
                return ps
    if assume_general_endmember:
        warnings.warn("Pair method | endmember base was used")
        return random_generator.choice(reference_spectra)
    return point_spectra[distances.index(min(distances))]


def compare_distance_permute(
    reference_spectra: List[np.ndarray],
    point_spectra: List[np.ndarray],
    distance_function,
    distance_threshold,
    assume_general_endmember,
    random_generator,
    **kwargs
) -> List:
    minimal_spectra = None
    minimal_distance = None
    for rs in reference_spectra:
        distances = []
        for ps in point_spectra:
            _dst = distance_function(rs, ps, **kwargs)

            distances.append(_dst)
            if distance_threshold != "min":
                if _is_in_threshold(_dst, distance_threshold):
                    return ps

        mdistance_candidate = min(distances)
        mspectral_candidate = minimal_spectra = point_spectra[
            distances.index(mdistance_candidate)
        ]

        if not minimal_distance:
            minimal_spectra = mspectral_candidate
            minimal_distance = mdistance_candidate
        else:
            if mdistance_candidate < minimal_distance:
                minimal_spectra = mspectral_candidate
                minimal_distance = mdistance_candidate
    if distance_threshold != "min" and assume_general_endmember:
        warnings.warn("Permute method | endmember base was used")
        return random_generator.choice(reference_spectra)
    return minimal_spectra
