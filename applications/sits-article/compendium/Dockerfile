# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

FROM brazildatacube/sits-jupyter:0.16.2
# DIGEST: sha256:0881e3ee8266983797c4462e1acba5322854fb63252ded5bfc75592aee33bb0b

EXPOSE 8888

#
# Installing system packages
#
USER root

RUN apt update --yes \
	&& apt-get install \
		libcairo2-dev \
		git \
		vim  --yes \
	&& rm -rf /var/lib/apt/lists/*

#
# Copying the package files.
#
COPY . sits-article

#
# Configuring the package files
#
RUN chown -R ${NB_USER}:${NB_USER} sits-article

USER $NB_USER

