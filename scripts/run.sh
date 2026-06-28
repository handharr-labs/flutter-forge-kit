#!/usr/bin/env bash
# Run the Forge Kit playground on the version of Flutter pinned to THIS repo
# (.fvmrc → latest stable), never the machine-global Flutter.
#
# Usage:
#   scripts/run.sh                 # let Flutter pick / prompt for a device
#   scripts/run.sh -d chrome       # web
#   scripts/run.sh -d <device-id>  # any flutter-known device
#   any extra args are forwarded to `flutter run`.
set -euo pipefail

# Repo root = parent of this script's dir, so it works from anywhere.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# fvm resolves .fvmrc by walking up from the cwd, so running inside the repo
# guarantees the pinned SDK regardless of the global default.
cd "$REPO_ROOT"
PINNED="$(python3 -c 'import json;print(json.load(open(".fvmrc"))["flutter"])' 2>/dev/null || echo unknown)"
echo "▶ flutter-forge-kit playground · pinned Flutter: ${PINNED}"

cd "$REPO_ROOT/playground"
exec fvm flutter run "$@"
