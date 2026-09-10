#!/bin/bash
# Entry point for the EXTRACTED deployment ZIP. Captures real batch output.
set -Eeuo pipefail
HERE=$(cd -- "$(dirname -- "$0")" && pwd)
PACKAGE=$(cd "$HERE/.." && pwd)
mode=${1:-preflight}
python3 "$HERE/verify-package.py"
if [[ $mode != preflight ]]; then
    printf 'Only preflight is unlocked at this checkpoint. Follow DEPLOYMENT after review.\n' >&2
    exit 2
fi
mkdir -p "$PACKAGE/results"
out=$(mktemp "$PACKAGE/results/preflight-$(date +%Y%m%dT%H%M%S)-XXXXXX.txt")
rc=0
sudo bash "$HERE/preflight.sh" 2>&1 | tee "$out" || rc=$?
printf '\nPREFLIGHT_EXIT=%s\n' "$rc" | tee -a "$out"
printf '\nRETURN THIS FILE: %s\nNo installation was performed.\n' "$out"
exit "$rc"
