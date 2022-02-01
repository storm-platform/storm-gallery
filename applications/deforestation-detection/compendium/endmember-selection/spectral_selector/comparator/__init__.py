# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from .distance import (
    distance_euclidian,
    distance_spectral_angle,
    distance_inverse_bray_curtis_similarity,
)

from .puzzle import (
    compare_distance_pair,
    compare_distance_permute,
)

from .similarity import get_most_similar_spectra


__all__ = (
    # Distances
    "distance_euclidian",
    "distance_spectral_angle",
    "distance_inverse_bray_curtis_similarity",
    # Puzzle (Distance comparation methods)
    "compare_distance_pair",
    "compare_distance_permute",
    # Similarity
    "get_most_similar_spectra",
)
