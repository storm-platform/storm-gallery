#!/bin/bash
#
# Copyright (C) 2021 Storm Gallery.
#
# storm-gallery is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#
# 1. Installing Pyenv
#
curl https://pyenv.run | bash

echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(pyenv init -)"' >> /home/vagrant/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> /home/vagrant/.bashrc

exec $SHELL
