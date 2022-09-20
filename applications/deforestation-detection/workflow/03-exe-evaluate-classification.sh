#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

#
# General definitions
#

# Experiment step path
STEP_PATH=compendium/evaluate-classification

# Dependency step
DEPENDENCY_STEP_PATH=compendium/fraction-classification

#
# 1. Getting the required data
#
cp \
  ${DEPENDENCY_STEP_PATH}/data/derived_data/mesma-classification/*.tif \
  ${STEP_PATH}/data/raw_data/deforestation-map

#
# 2. Accessing the compendium step directory
#
cd ${STEP_PATH}

#
# 3. Creating the experiment environment
#
make startenv

#
# 4. Executing the experiment
#
docker exec \
    -w /home/jovyan/evaluate-classification pkg-evaluate-classification \
      workbench exec run --name "Experiment - Evaluate classification (3)" make start

#
# 4. Exporting the execution compendium
#
docker exec \
    -w /home/jovyan/evaluate-classification pkg-evaluate-classification \
      workbench export compendium -o data/devired_data/execution-compendium

#
# 5. Finishing the experiment environment
#
make finishenv
