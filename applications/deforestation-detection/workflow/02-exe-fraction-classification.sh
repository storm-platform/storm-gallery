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
STEP_PATH=compendium/fraction-classification

# Dependency step
DEPENDENCY_STEP_PATH=compendium/endmember-selection


#
# 1. Getting the required data
#
cp -r ${DEPENDENCY_STEP_PATH}/data/derived_data/{brick,endmember,stack} ${STEP_PATH}/data/raw_data

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
    -w /home/jovyan/fraction-classification pkg-fraction-classification \
      workbench exec run --name "Experiment - Fraction classification (2)" make start

#
# 4. Exporting the execution compendium
#
docker exec \
    -w /home/jovyan/fraction-classification pkg-fraction-classification \
      workbench export compendium -o data/derived_data/execution-compendium

#
# 5. Finishing the experiment environment
#
make finishenv
