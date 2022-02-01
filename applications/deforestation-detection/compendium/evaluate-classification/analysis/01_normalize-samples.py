# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from pathlib import Path

import pandas as pd
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

# Validation sample
samples = pd.read_csv(input_dir / "samples" / "validation-samples.csv")

#
# 2. Normalizing the sample labels
#

# Load the pixel-class relations
normalization_rule = settings.map.pixel_class_semantic

# Normalizing the labels
samples["label"] = samples["label"].replace(normalization_rule)

#
# 3. Saving the changed samples dataset
#

# Defining the output directory
output_dir_samples = output_dir / "normalized-samples"
output_dir_samples.mkdir(exist_ok=True, parents=True)

# Saving the data
samples.to_csv(output_dir_samples / "validation-samples.csv", index=False)
