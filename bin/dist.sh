#!/bin/bash

# Cleaning previous release
rm -rf ./dist/

echo "Copying js files."
mkdir -p ./dist/scripts/modules
cp ./scripts/*.js ./dist/scripts/
cp ./scripts/modules/*.js ./dist/scripts/modules/

echo "Copying css files."
mkdir ./dist/styles/
cp ./styles/*.css ./dist/styles/

echo "Copying html files."
cp ./*.html ./dist/

echo "Copying image files."
cp -r ./images/ ./dist/images/

echo "Copying locale files."
cp -r ./_locales/ ./dist/_locales/

echo "Copying jquery files."
mkdir -p ./dist/bower_components/jquery/dist/
cp ./bower_components/jquery/dist/jquery.min.js ./dist/bower_components/jquery/dist/
cp ./bower_components/jquery/dist/jquery.min.map ./dist/bower_components/jquery/dist/

echo "Copying jshashes files."
mkdir -p ./dist/bower_components/jshashes/
cp ./bower_components/jshashes/hashes.min.js ./dist/bower_components/jshashes/hashes.min.js

echo "Copying manifest files. Don't forget to update version!"
cp ./manifest.json ./dist/
