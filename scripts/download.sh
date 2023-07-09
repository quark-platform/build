#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

version="115.0.1esr"
to_copy=("build" "other-licenses" "python" "testing" "third_party/python" "LICENSE" ".gitignore" "mach" "mach.cmd" "mach.ps1")

if [[ ! -d "scripts" ]]; then
  echo "Please run this script from the root of the repository"
  exit 1
fi

# shellchack source=./download_int.sh
source ./scripts/download_int.sh

create_engine $version
copy_needed "${to_copy[@]}"
apply_patches patches/*.patch
