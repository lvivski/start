#!/bin/bash

set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" )/.. && pwd )

echo "Analyzing library for warnings or type errors"
dart_analyzer --fatal-warnings --fatal-type-errors lib/*.dart
rm -r out

for test in $DIR/test/*_test.dart
do
	echo -e "\nRunning test suite: $(basename $test)"
	dart --checked $test
done

echo -e "\n[32m✓ OK[0m"
