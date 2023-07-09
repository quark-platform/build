#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

name=$1
file=$2

if [[ ! -d "scripts" ]]; then
  echo "Please run this script from the root of the repository"
  exit 1
fi

if [[ ! -e "$file" ]]; then
  echo "File $file does not exist"
  exit 1
fi

if [[ -e "src/$file" ]]; then
  echo "Input path should be relative to src/"
  exit 1
fi

if [[ -e "patches/$name.patch" ]]; then
  echo "Patch $name already exists"
  exit 1
fi

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

mkdir -p patches

repo_path=$(
  IFS='/' read -ra path <<<"$file"
  join_by "/" "${path[@]:1}"
)
engine_path=".engine/${repo_path}"

diff -u --new-file --recursive --minimal "$engine_path" "$file" >"patches/$name.patch"
