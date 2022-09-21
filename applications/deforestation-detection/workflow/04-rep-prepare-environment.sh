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
PYTHON_VERSION=3.8.0

PYTHON_VIRTUALENV=deforestation-detection

#
# 1. Installing python
#
pyenv install ${PYTHON_VERSION}

#
# 2. Configuring the reproduction environment using pyenv
#
pyenv virtualenv ${PYTHON_VERSION} ${PYTHON_VIRTUALENV}
pyenv local ${PYTHON_VIRTUALENV}

pip install --upgrade pip

#
# 3. Installing the dependencies
#

# 3.1. Installing poetry
pip install poetry
poetry config virtualenvs.create false

# 3.2. Installing reproduction dependency
poetry install
