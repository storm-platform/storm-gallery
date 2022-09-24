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
STEP_PATH=compendium

STEP_EXECUTION_COMPENDIUM_STEP=data/derived_data/execution-compendium/timeseries

EXECUTION_COMPENDIUM_FILE=bdc-article.zip

#
# 1. Accessing the compendium step directory
#
cd ${STEP_PATH}

#
# 2. Accessing the execution compendium directory
#
cd ${STEP_EXECUTION_COMPENDIUM_STEP}

#
# 3. Extracting the execution compendium data
#
workbench import compendium -f ${EXECUTION_COMPENDIUM_FILE} -o files

#
# 4. Reproducing
#
cd files

workbench exec rerun
