# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import json
from pathlib import Path

import numpy as np
import pandas as pd

from settings import settings
from evaluator.sample import generate_metrics_for_multilabel_classification

np.random.seed(777)

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

# Samples with the predicted values associated
samples = pd.read_csv(
    output_dir / "samples-with-predicted-values" / "validation-samples.csv"
)

#
# 2. Sampling the samples
#
sampled_samples = samples.groupby("label").sample(settings.sample.sampling_size)

#
# 3. Evaluating!
#
metrics = generate_metrics_for_multilabel_classification(
    y_true=sampled_samples["label"],
    y_pred=sampled_samples["label_predicted"],
    labels=[1, 2, 3],
    label_names=settings.map.pixel_class_semantic.keys(),
)

#
# 4. Saving the results
#

# Defining the output directory
output_dir_metrics = output_dir / "metrics"
output_dir_metrics.mkdir(exist_ok=True, parents=True)

# Metrics file
output_metrics_file = output_dir_metrics / "metrics.json"

# Saving the data
json.dump(metrics, output_metrics_file.open(mode="w"))
