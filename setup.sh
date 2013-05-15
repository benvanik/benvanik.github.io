#!/bin/bash

sudo gem update --system
sudo gem install jekyll gsl closure less

sudo npm install -g yuicompressor

git submodule init
git submodule update
