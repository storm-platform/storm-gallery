# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

.PHONY: start clean help buildenv startenv

#
# Infrastructure commands
#
buildenv:  ## Build the experiment docker environment
	docker build --no-cache -t "stormproject/pkg-fraction-classification:0.1" .

startenv:  ## Start the experiment docker environment
	docker run -d -ti \
		--name pkg-fraction-classification \
		--publish 8888:8888 \
		--volume ${PWD}/data:/home/jovyan/fraction-classification/data \
		stormproject/pkg-fraction-classification:0.1

#
# Start the Deforestation detection classification workflow
#
BASE_TARGET_DEPS := data/derived_data/mesma/%.tif data/derived_data/mesma-vrt/%.vrt

BASE_TARGET_DEPS += data/derived_data/mesma-classification/%.tif
BASE_TARGET_DEPS += data/derived_data/mesma-classification/%.rds
BASE_TARGET_DEPS += data/derived_data/mesma-classification/%.csv

start: $(BASE_TARGET_DEPS)  ## Run the complete LULC classification workflow
	@echo "Classification workflow finished"

clean:  ## Clean the generated results
	rm -rf data/derived_data

#
# Processing commands
#

# Generate the Fraction Image using MESMA
data/derived_data/mesma/%.tif:
	@echo "Creating the output directory"
	mkdir -p data/derived_data/mesma

	@echo "Generating the Fraction Images using MESMA"
	Rscript analysis/01_generate-image-fraction.R


# Generate the VRT in a way supported by the SITS R Package to create local cubes
data/derived_data/mesma-vrt/%.vrt: data/derived_data/mesma/%.tif
	@echo "Creating the output directory"
	mkdir -p data/derived_data/mesma-vrt

	@echo "Generating the VRTs"
	Rscript analysis/02_generate-vrt.R


# Create the deforestation map using the Fraction Image Data Cube
CLASSIFICATION_TARGET_FILES := data/derived_data/mesma-classification/%.tif
CLASSIFICATION_TARGET_FILES += data/derived_data/mesma-classification/%.rds
CLASSIFICATION_TARGET_FILES += data/derived_data/mesma-classification/%.csv

$(CLASSIFICATION_TARGET_FILES): data/derived_data/mesma-vrt/%.vrt
	@echo "Creating the output directory"
	mkdir -p data/derived_data/mesma-classification

	@echo "Generating the deforestation map"
	Rscript analysis/03_classify-fraction-cube.R


#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
