#!/bin/bash
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#
# General definitions
#

# Experiment step path
STEP_PATH=compendium

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
    -e BDC_ACCESS_KEY="${BDC_ACCESS_TOKEN}" \
    -w /home/jovyan/bdc-article pkg-bdc-article \
      workbench exec run --name "Experiment - CBERS-4A/AWFI classification and validation (2)" make exe-cbers4

#
# 4. Exporting the execution compendium
#
docker exec \
    -w /home/jovyan/bdc-article pkg-bdc-article \
      workbench export compendium -o data/derived_data/execution-compendium/cbers4

#
# 5. Finishing the experiment environment
#
make finishenv
