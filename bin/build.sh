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

echo "Copying manifest files. Don't forget to update version!"
cp ./manifest.json ./dist/

echo "Copying bootstrap js and css files."
mkdir -p ./dist/bower_components/bootstrap/dist/css/
cp ./bower_components/bootstrap/dist/css/bootstrap.min.css ./dist/bower_components/bootstrap/dist/css/
mkdir -p ./dist/bower_components/bootstrap/dist/js/
cp ./bower_components/bootstrap/dist/js/bootstrap.min.js ./dist/bower_components/bootstrap/dist/js/

echo "Copying jquery files."
mkdir -p ./dist/bower_components/jquery/dist/
cp ./bower_components/jquery/dist/jquery.min.js ./dist/bower_components/jquery/dist/

echo "Copying sweetalert files."
mkdir -p ./dist/bower_components/sweetalert/lib/
cp ./bower_components/sweetalert/lib/sweet-alert.min.js ./dist/bower_components/sweetalert/lib/
cp ./bower_components/sweetalert/lib/sweet-alert.css ./dist/bower_components/sweetalert/lib/