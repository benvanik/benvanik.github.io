#!/bin/bash

jekyll build

TEMP=`mktemp -d -t ghpage`

mkdir $TEMP
cp -R _site/ $TEMP/
pushd $TEMP

git init
git add .
git commit -m "Rebuilding site."
git remote add origin git@github.com:benvanik/benvanik.github.io.git
git push origin master --force

popd
rm -rf $TEMP
