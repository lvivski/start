#!/bin/bash

set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" )/.. && pwd )

echo "Analyzing library for warnings or type errors"
dartanalyzer --show-package-warnings --package-root lib start.dart
rm -r out

for test in $DIR/test/*_test.dart
do
	echo -e "\nRunning test suite: $(basename $test)"
	dart --checked $test
done

echo -e "\n[32m✓ OK[0m"
