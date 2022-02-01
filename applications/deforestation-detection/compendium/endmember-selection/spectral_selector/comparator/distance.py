# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import math
import numpy as np


def distance_spectral_angle(
    reference_spectra: np.ndarray, point_spectra: np.ndarray, factor: int
) -> float:
    """Function to calculate the distance between spectral elements using Spectral Angle Algorithm.

    Args:
        reference_spectra (np.ndarray): Reference spectrum

        point_spectra (np.ndarray): Pixel spectrum

        factor (int): Factor to be used on data

    Returns:
        float: Distance between spectral elements

    See:
        https://semiautomaticclassificationmanual-v4.readthedocs.io/en/latest/remote_sensing.html#spectral-angle
    """
    point_spectra = point_spectra / factor
    reference_spectra = reference_spectra / factor

    # generate equation terms
    numerator = np.dot(reference_spectra, point_spectra)
    denominator_term_one = math.sqrt(np.sum(point_spectra ** 2))
    denominator_term_two = math.sqrt(np.sum(reference_spectra ** 2))

    return math.cos((numerator / (denominator_term_one * denominator_term_two)))


def distance_euclidian(
    reference_spectra: np.ndarray, point_spectra: np.ndarray, factor: int
) -> float:
    """Function to calculate the distance between spectral elements using Euclidian Distance.

    Args:
        reference_spectra (np.ndarray): Reference spectrum

        point_spectra (np.ndarray): Pixel spectrum

        factor (int): Factor to be used on data

    Returns:
        float: Distance between spectral elements

    See:
        https://semiautomaticclassificationmanual-v4.readthedocs.io/en/latest/remote_sensing.html#euclidean-distance
    """
    point_spectra = point_spectra / factor
    reference_spectra = reference_spectra / factor

    return math.sqrt(np.sum((reference_spectra - point_spectra) ** 2))


def distance_inverse_bray_curtis_similarity(
    reference_spectra: np.ndarray, point_spectra: np.ndarray, factor: int
) -> float:
    """Function to calculate the distance between spectral elements using Bray-Curtis Similarity
    method (With inverted values).

    This function calculates the spectral distance between a ``reference_spectra`` and ``point_spectra``.
    In this function, this is done by using the Bray-Curtis Similarity with the result values inverted. So,
    the range of more distant (0) and less distant (100) becomes more distant (100) and less distant (0).

    Args:
        reference_spectra (np.ndarray): Reference spectrum

        point_spectra (np.ndarray): Pixel spectrum

        factor (int): Factor to be used on data

    Returns:
        float: Distance between spectral elements

    See:
        https://semiautomaticclassificationmanual-v4.readthedocs.io/en/latest/remote_sensing.html#bray-curtis-similarity
    """
    point_spectra = point_spectra / factor
    reference_spectra = reference_spectra / factor

    # generate equation terms
    numerator = np.sum(np.abs(reference_spectra - point_spectra))
    denominator = np.sum(reference_spectra) + np.sum(point_spectra)

    return 100 - (100 - (numerator / denominator) * 100)
