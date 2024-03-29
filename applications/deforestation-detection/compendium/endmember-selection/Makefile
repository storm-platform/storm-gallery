# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

.PHONY: start clean help buildenv startenv finishenv

#
# Infrastructure commands
#
buildenv:  ## Build the experiment docker environment
	docker build --no-cache -t "stormproject/pkg-endmember-selection:0.2" .

startenv:  ## Start the experiment docker environment
	docker run -d -ti \
	--name pkg-endmember-selection \
	--publish 8888:8888 \
	--volume ${PWD}/data/derived_data/:/home/jovyan/endmember-selection/data/derived_data \
	stormproject/pkg-endmember-selection:0.2

finishenv:  ## Finalize the environment
	docker rm -f pkg-endmember-selection

#
# Start the Spectral Unmixing endmember selection
#
BASE_TARGET_DEPS := data/derived_data/endmember/%.json

start: $(BASE_TARGET_DEPS)  ## Run the complete workflow
	@echo "Endmember selection workflow finished"

clean:  ## Clean the generated results
	rm -rf data/derived_data

#
# Processing commands
#

# Generate the base VRTs for the Endmember selection
ENDMEMBER_TARGET_OUTS := data/derived_data/brick/%.csv data/derived_data/brick/%.vrt data/derived_data/stack/%.vrt

$(ENDMEMBER_TARGET_OUTS):
	@echo "Creating the output directory"
	mkdir -p data/derived_data/brick
	mkdir -p data/derived_data/stack

	@echo "Generating the base VRTs for the Endmember selection"
	python3 analysis/01_generate_vrt.py


# Select the endmember for each image (VRTs) produced in the previous step.
data/derived_data/endmember/%.json: $(ENDMEMBER_TARGET_OUTS)
	@echo "Creating the output directory"
	mkdir -p data/derived_data/endmember

	@echo "Selecting the endmembers"
	python3 analysis/02_select_endmembers.py

#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
