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
buildenv:
	docker build --no-cache -t "stormproject/pkg-sits-article:0.1" .

startenv:
	docker run -d -ti \
		--name pkg-sits-article \
		--publish 8888:8888 \
		--volume ${PWD}:/home/jovyan/sits-article \
	stormproject/pkg-sits-article:0.1

#
# Start the LULC classification workflow (High-level commands)
#
startclassification-cerrado:  ## Start the cerrado classification workflow
    workbench exec run \
        --name "Experiment - Cerrado LULC classification" \
        --stormfile workflow/Stormfile.cerrado.yaml

startclassification-matogrosso:  ## Start the Mato Grosso classification workflow
    workbench exec run \
        --name "Experiment - Mato grosso LULC classification" \
        --stormfile workflow/Stormfile.matogrosso.yaml

clean:
    rm -rf data/derived_data

#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
