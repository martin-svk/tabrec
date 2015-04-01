#!/bin/bash

# Break on error
set -e

command_exists () {
  type "$1" &> /dev/null;
}

if command_exists coffee; then
  echo "Compiling coffee scripts."
  coffee -c ./scripts
else
  echo "Can't compile coffee scripts, you need coffeescript compiler to continue!"
  exit
fi

if command_exists sass; then
  echo "Compiling sass stylesheets."
  sass --update ./styles --style compressed
else
  echo "Can't compile sass styles, you need sass compiler to continue!"
  exit
fi

if command_exists pandoc; then
  echo "Converting changelog to HTML."
  pandoc CHANGELOG.md -f markdown -t html -s -o ./pages/CHANGELOG.html
else
  echo "Can't convert changelog to HTML, you need pandoc to continue!"
  exit
fi
