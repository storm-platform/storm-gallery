# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

.PHONY: exe-* help buildenv startenv

#
# Infrastructure commands  (High-level commands)
#
buildenv:  ## Build the experiment docker environment
	docker build --no-cache -t "stormproject/pkg-bdc-article:0.2" .

startenv:  ## Start the experiment docker environment
	docker run -d -ti \
		--name pkg-bdc-article \
		--publish 8888:8888 \
		--volume ${PWD}:/home/jovyan/bdc-article \
	stormproject/pkg-bdc-article:0.2

finishenv:  ## Finalize the environment
	docker rm -f pkg-bdc-article

#
# Start the LULC classification workflow (High-level commands)
#
exe-start: data/derived_data/notebook/CB4_64_16D_STK-1%.ipynb data/derived_data/notebook/LC8_30_16D_STK-1%.ipynb data/derived_data/notebook/S2-SEN2COR_10_16D_STK-1%.ipynb ## Run the complete LULC classification workflow
	@echo "Classification workflow finished"

exe-clean:  ## Clean the generated results
	rm -rf data/derived_data

exe-timeseries: data/derived_data/samples/train/%.rds ## Workflow Step 1 - Extract time series
	@echo "Processed"

exe-cbers4: data/derived_data/notebook/CB4_64_16D_STK-1%.ipynb ## Workflow Step 2 - Processing CBERS-4/AWFI data
	@echo "Processed"

exe-landsat8: data/derived_data/notebook/LC8_30_16D_STK-1%.ipynb ## Workflow Step 3 - Processing Landsat-8/OLI data
	@echo "Processed"

exe-sentinel2: data/derived_data/notebook/S2-SEN2COR_10_16D_STK-1%.ipynb  ## Workflow Step 4 - Processing Sentinel-2/MSI data
	@echo "Processed"

#
# Processing commands
#

# Extract the sample time series from the data cubes
data/derived_data/samples/train/%.rds:
	@echo "Creating the output directory"
	mkdir -p data/derived_data/notebook

	@echo "Extracting the time series"
	cd analysis/ \
		&& papermill \
			01_ExtractTimeSeries.ipynb \
			../data/derived_data/notebook/01_ExtractTimeSeries.ipynb \
			$(ARGS)


# Create the LULC map using the CBERS-4 (16 days Stack) data cube
data/derived_data/notebook/CB4_64_16D_STK-1%.ipynb:
	@echo "Classifying the data cube (CBERS-4)"
	cd analysis/ \
		&& papermill \
			02_CB4_64_16D_STK-1_Classification.ipynb \
			../data/derived_data/notebook/02_CB4_64_16D_STK-1_Classification.ipynb \
			$(ARGS)

	@echo "Calculating the LULC classification accuracy"
	cd analysis/ \
		&& papermill \
			03_CB4_64_16D_STK-1_Validation.ipynb \
			../data/derived_data/notebook/03_CB4_64_16D_STK-1_Validation.ipynb \
			$(ARGS)


# Create the LULC map using the Landsat-8 (16 days Stack) data cube
data/derived_data/notebook/LC8_30_16D_STK-1%.ipynb:
	@echo "Classifying the data cube (Landsat-8)"
	cd analysis/ \
		&& papermill \
			04_LC8_30_16D_STK-1_Classification.ipynb \
			../data/derived_data/notebook/04_LC8_30_16D_STK-1_Classification.ipynb \
			$(ARGS)

	@echo "Calculating the LULC classification accuracy"
	cd analysis/ \
		&& papermill \
			05_LC8_30_16D_STK-1_Validation.ipynb \
			../data/derived_data/notebook/05_LC8_30_16D_STK-1_Validation.ipynb \
			$(ARGS)


# Create the LULC map using the Sentinel-2 (16 days Stack) data cube
data/derived_data/notebook/S2-SEN2COR_10_16D_STK-1%.ipynb:
	@echo "Classifying the data cube (Sentinel-2)"
	cd analysis/ \
		&& papermill \
			06_S2-SEN2COR_10_16D_STK-1_Classification.ipynb \
			../data/derived_data/notebook/06_S2-SEN2COR_10_16D_STK-1_Classification.ipynb \
			$(ARGS)

	@echo "Calculating the LULC classification accuracy"
	cd analysis/ \
		&& papermill \
			07_S2-SEN2COR_10_16D_STK-1_Validation.ipynb \
			../data/derived_data/notebook/07_S2-SEN2COR_10_16D_STK-1_Validation.ipynb \
			$(ARGS)


#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
