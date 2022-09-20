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
STEP_PATH=compendium/endmember-selection

#
# 1. Accessing the compendium step directory
#
cd ${STEP_PATH}


#
# 2. Creating the experiment environment
#
make startenv

#
# 3. Executing the experiment
#
docker exec \
    -e SPECTRAL_SELECTOR_BDC_ACCESS_TOKEN="${BDC_ACCESS_TOKEN}" \
    -w /home/jovyan/endmember-selection pkg-endmember-selection \
      workbench exec run --name "Experiment - Endmember selection (1)" make start

#
# 4. Exporting the execution compendium
#
docker exec \
    -w /home/jovyan/endmember-selection pkg-endmember-selection \
      workbench export compendium -o data/derived_data/execution-compendium

#
# 5. Finishing the experiment environment
#
make finishenv
