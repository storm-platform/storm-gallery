# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

FROM jupyter/base-notebook:lab-3.2.8
# DIGEST: sha256:9bd31d97f8a5510b795b9519e5cb2d0804aa98f574a052af0700cda29dcfc40c

EXPOSE 8888

#
# Fixing SSL error (https://github.com/brazil-data-cube/stac.py/issues/112)
#
ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

#
# Installing system packages
#
USER root

RUN apt update --yes \
	&& apt-get install \
		libcairo2-dev \
		git \
		wget \
		curl \
		vim \
		build-essential \
		--yes \
	&& rm -rf /var/lib/apt/lists/*


#
# Copying the package files.
#
COPY . /home/${NB_USER}/endmember-selection

#
# Installing the package dependencies.
#
RUN cd /home/${NB_USER}/endmember-selection \
	&& mamba env update -f environment.yml \
    	&& mamba run --name base pip install . \
	&& chown -R ${NB_UID}:${NB_GID} /home/${NB_USER}

#
# Installing the Storm Workbench
#
RUN pip install git+https://github.com/storm-platform/storm-workbench


USER $NB_USER
