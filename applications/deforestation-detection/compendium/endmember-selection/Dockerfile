# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

FROM condaforge/mambaforge:4.11.0-0

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y \
        wget \
        curl \
        vim \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/app/spectral-selector
WORKDIR /opt/app/spectral-selector

RUN mamba env create -f environment.yml \
    && mamba run --name spectral-selector pip install .
