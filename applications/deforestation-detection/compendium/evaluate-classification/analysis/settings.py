# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from dynaconf import Dynaconf

settings = Dynaconf(
    settings_files=["analysis/workflow.toml"], envvar_prefix="EVALUATOR"
)
