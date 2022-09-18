#!/bin/bash
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#
# 1. Updating the environment
#
apt-get update -y
apt-get install -y \
            ca-certificates curl \
            gnupg lsb-release \
            vim htop \
            make build-essential \
            libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev \
            libsqlite3-dev wget curl \
            llvm libncursesw5-dev xz-utils \
            tk-dev libxml2-dev libxmlsec1-dev \
            libffi-dev liblzma-dev
