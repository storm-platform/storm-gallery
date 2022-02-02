#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

docker run -d -ti \
	--name pkg-endmember-selection \
	--publish 8888:8888 \
	--volume ${PWD}/data/derived_data/:/home/jovyan/endmember-selection/data/derived_data \
	stormproject/pkg-endmember-selection:0.1

