#!/bin/bash

echo "Copying project js files."
mkdir -p ./dist/scripts/modules
cp ./scripts/*.js ./dist/scripts/
cp ./scripts/modules/*.js ./dist/scripts/modules/

echo "Copying project css files."
mkdir ./dist/styles/
cp ./styles/*.css ./dist/styles/

echo "Copying image files."
mkdir ./dist/images/
cp -r ./images/ ./dist/images/

echo "Copying locale files."
mkdir ./dist/_locales/
cp -r ./_locales/ ./dist/_locales/
