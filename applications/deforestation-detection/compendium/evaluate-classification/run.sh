#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

docker run --rm -ti \
	--name pkg-evaluate-classification \
	--publish 8888:8888 \
	--volume ${PWD}:/home/${NB_USER}/evaluate-classification \
	stormproject/pkg-evaluate-classification:0.1

