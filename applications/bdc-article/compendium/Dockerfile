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
# Installing system packages
#
USER root

RUN apt update --yes \
	&& apt-get install libcairo2-dev git vim --yes \
	&& rm -rf /var/lib/apt/lists/*

#
# Copying the package files.
#
COPY . bdc-article

#
# Installing the package dependencies.
#
RUN cd bdc-article \
	&& mamba env update --file environment.yml \
	# Preparing the Jupyter Notebook kernel
	&& Rscript -e "IRkernel::installspec()" \
	# Installing sits 0.15.1-1 and terra 1.4.22
	# note (2022/02/10): We remove the renv to avoid problems with terra. At this point
	#                    the sits r package have some problems with the newest terra 
	#		     version and the renv was ignoring this and change the versions.
	&& Rscript -e "devtools::install_github('e-sensing/sits@v0.15.1-1')" \
	&& Rscript -e "devtools::install_version('reticulate', version = '1.24', repos = c('https://vps.fmvz.usp.br/CRAN/'), upgrade = 'never')" \
        && Rscript -e "devtools::install_version('keras',  version = '2.8.0',  repos = c('https://vps.fmvz.usp.br/CRAN/'), upgrade = 'never')" \
	&& Rscript -e "devtools::install_version('tidyr',  version = '1.2.0',  repos = c('https://vps.fmvz.usp.br/CRAN/'),  upgrade = 'never')" \
        && Rscript -e "devtools::install_version('raster', version = '3.3-13', repos = c('https://vps.fmvz.usp.br/CRAN/'), upgrade='never')" \
	&& Rscript -e "devtools::install_version('terra',  version = '1.4.22', repos = c('https://vps.fmvz.usp.br/CRAN/'), upgrade = 'never')" \ 
	&& chown -R ${NB_UID}:${NB_GID} /home/${NB_USER}

USER $NB_USER

RUN echo "reticulate::install_miniconda()" | R --no-save && \
    echo "keras::install_keras()" | R --no-save

