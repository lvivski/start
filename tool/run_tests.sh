#!/bin/bash

set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" )/.. && pwd )

echo "Analyzing library for warnings or type errors"
dartanalyzer --show-package-warnings $DIR/lib/start.dart
dart --checked $DIR/test/start_test.dart

echo -e "\n[32m✓ OK[0m"
