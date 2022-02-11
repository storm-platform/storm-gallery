#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

docker run -d -ti \
	--name pkg-sits-article \
	--publish 8888:8888 \
	--volume ${PWD}/data:/home/jovyan/sits-article/data \
	stormproject/pkg-sits-article:0.1

