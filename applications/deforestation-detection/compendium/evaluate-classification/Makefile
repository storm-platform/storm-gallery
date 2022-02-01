# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

.PHONY: start clean help

#
# Start the evaluation workflow
#
BASE_TARGET_DEPS := data/derived_data/normalized-samples/validation-samples.csv
BASE_TARGET_DEPS += data/derived_data/samples-with-predicted-values/validation-samples.csv
BASE_TARGET_DEPS += data/derived_data/metrics/metrics.json

start: $(BASE_TARGET_DEPS)  ## Run the complete evaluation workflow
	@echo "Evaluation workflow finished"

clean:  ## Clean the generated results
	rm -rf data/derived_data

#
# Processing commands
#

# Normalize the original classes with the predicted values
data/derived_data/normalized-samples/validation-samples.csv:
	@echo "Creating the output directory"
	mkdir -p data/derived_data/normalized-samples

	@echo "Normalizing the classes"
	python3 analysis/01_normalize-samples.py


# Extract the predicted values from the deforestation map
data/derived_data/samples-with-predicted-values/validation-samples.csv: data/derived_data/normalized-samples/validation-samples.csv
	@echo "Creating the output directory"
	mkdir -p data/derived_data/samples-with-predicted-values

	@echo "Extracting the predicted values"
	python3 analysis/02_extract-predicted-classes.py

# Evaluate the predicted values
data/derived_data/metrics/metrics.json: data/derived_data/samples-with-predicted-values/validation-samples.csv
	@echo "Creating the output directory"
	mkdir -p data/derived_data/metrics

	@echo "Evaluating the predicted values"
	python3 analysis/03_evaluate.py

#
# Documentation function (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
#
help:  ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
