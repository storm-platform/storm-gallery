# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

exe-produce:  ## Execute the experiment
	workflow/01-exe-extract-timeseries.sh
	workflow/02-exe-cbers4-processing.sh
	workflow/03-exe-landsat8-processing.sh
	workflow/04-exe-sentinel2-processing.sh


rep-prepare:  ## Prepare the environment to reproduce the experiment
	workflow/05-rep-prepare-environment.sh


rep-reproduce: ##  Reproduce the experiment
	workflow/06-rep-extract-timeseries.sh
	workflow/07-rep-cbers4-processing.sh
	workflow/08-rep-landsat8-processing.sh
	workflow/09-rep-sentinel2-processing.sh

checksum:  ##  Generate compendium files checksum
	mkdir -p checksums

	find ./compendium -type f -exec md5sum {} > checksums/md5sums.txt \;
	find ./compendium -type f -exec sha256sum {} > checksums/sha256sums.txt \;
	find ./compendium -type f -exec sha512sum {} > checksums/sha512sums.txt \;

#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
