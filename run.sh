#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <path_to_testfiles>"
  exit 1
fi

TESTFILES=$1

echo "Running calculate_metrics on all JSON files in $TESTFILES...\n"
for arquivo in "$TESTFILES"/*.json; do
  if [ -f "$arquivo" ]; then
    echo "Processing $arquivo...\n"
    mix calculate_metrics "$arquivo"
  else
    echo "File $arquivo does not exist or is not a regular file."
  fi
done

echo "Running list_locations on all JSON files in $TESTFILES...\n"
for arquivo in "$TESTFILES"/*.json; do
  if [ -f "$arquivo" ]; then
    echo "Processing $arquivo...\n"
    mix list_locations "$arquivo"
  else
    echo "File $arquivo does not exist or is not a regular file."
  fi
done


