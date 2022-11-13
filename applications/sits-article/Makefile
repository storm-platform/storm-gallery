# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

exe-cerrado-produce:  ## Execute the Cerrado LULC classification experiment
	workflow/cerrado/01-exe-cerrado-classification.sh
exe-matogrosso-produce:  ## Execute the Mato Grosso LULC classification experiment
	workflow/matogrosso/01-exe-matogrosso-classification.sh

rep-cerrado-prepare:  ## Prepare the environment to reproduce the experiment (Cerrado classification)
	workflow/cerrado/02-rep-prepare-environment.sh
rep-matogrosso-prepare:  ## Prepare the environment to reproduce the experiment (Mato Grosso classification)
	workflow/matogrosso/02-rep-prepare-environment.sh

rep-cerrado-reproduce:  ## Reproduce the experiment (Cerrado classification)
	workflow/cerrado/03-rep-cerrado-classification.sh
rep-matogrosso-reproduce:  ## Reproduce the experiment (Mato Grosso classification)
	workflow/matogrosso/03-rep-matogrosso-classification.sh

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
