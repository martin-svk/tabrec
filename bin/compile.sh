#!/bin/bash

echo "Compiling coffee scripts."
coffee -c ./scripts

echo "Compiling sass stylesheets."
sass --update ./styles
