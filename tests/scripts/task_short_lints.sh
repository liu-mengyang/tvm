#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -euxo pipefail

cleanup()
{
  rm -rf /tmp/$$.*
}
trap cleanup 0


echo "Convert scripts to Python..."
tests/scripts/task_convert_scripts_to_python.sh

echo "Check Jenkinsfile generation"
python3 ci/jenkins/generate.py --check

echo "Checking file types..."
python3 tests/lint/check_file_type.py

echo "Checking CMake <-> LibInfo options mirroring"
python3 tests/lint/check_cmake_options.py

echo "Checking that all sphinx-gallery docs override urllib.request.Request"
python3 tests/lint/check_request_hook.py

echo "Docker check..."
tests/lint/docker-format.sh

echo "Checking for non-inclusive language with blocklint..."
tests/lint/blocklint.sh

echo "Checking Rust format..."
tests/lint/rust_format.sh

echo "Linting the JNI code..."
tests/lint/jnilint.sh
