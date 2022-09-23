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
	workflow/04-exe-cbers4-processing.sh


rep-prepare:  ## Prepare the environment to reproduce the experiment
	@echo "To be done"


rep-reproduce: ##  Reproduce the experiment
	@echo "To be done"

#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
