#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Fail when a local source of the PKGBUILD does not match its sha256sum.
# Remote and VCS sources (those with a URL) are skipped.
# shellcheck disable=SC2154
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source PKGBUILD

status=0
for i in "${!source[@]}"; do
  entry=${source[$i]}
  case $entry in *://*) continue ;; esac
  file=${entry##*::}
  actual=$(sha256sum -- "$file" | cut -d' ' -f1)
  if [ "$actual" != "${sha256sums[$i]}" ]; then
    echo "checksum mismatch: $file" >&2
    status=1
  fi
done
exit "$status"
