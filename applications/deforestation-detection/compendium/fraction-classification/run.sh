#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

docker run -d -ti \
	--name pkg-fraction-classification \
	--publish 8888:8888 \
	--volume ${PWD}/data:/home/jovyan/fraction-classification/data \
	stormproject/pkg-fraction-classification:0.1

