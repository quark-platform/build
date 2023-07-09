#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

engine=.engine
source=src

function create_engine {
  local version=$1
  local source_url="https://archive.mozilla.org/pub/firefox/releases/$version/source/firefox-$version.source.tar.xz"
  local tar_file=".cache/firefox-$version.tar.xz"

  if [[ -e "$engine" ]]; then
    return 0
  fi

  if [[ ! -e "$tar_file" ]]; then
    mkdir -p .cache
    wget -O "$tar_file" "$source_url"
  fi

  rm -rf "$engine"
  mkdir "$engine"
  tar --strip-components=1 -xf "$tar_file" -C "$engine"
}

function copy_needed {
  rm -rf "$source"
  mkdir -p "$source"

  for file in "${@}"; do
    echo "Copying $file"

    if [[ -d "$engine/$file" ]]; then
      mkdir -p "$source/$file"
      cp -r "$engine/$file"/* "$source/$file"
      continue
    fi

    cp "$engine/$file" "$source"
  done
}

function apply_patches {
  local patches=("$@")

  for patch in "${patches[@]}"; do
    echo "Applying patch $patch"
    dest_path="$(grep -Po "\+\+\+ \K[^\t]*" <"$patch")"

    patch -u --quiet "$dest_path" <"$patch"
  done
}
