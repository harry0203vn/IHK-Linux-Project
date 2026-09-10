#!/bin/bash
# Exercises the REAL script with a fixture df in an isolated copied script.
# Never fills the VM disk; clearly labeled simulation.
source "$(dirname -- "$0")/lib.sh"
start_log test-disk-threshold
mkdir -p "$STATE/tests"
run=$(mktemp -d "$STATE/tests/disk-simulation-XXXXXX")
cp "$SELF/check-disk.sh" "$SELF/lib.sh" "$run/"
# Override df as a function AFTER sourcing lib; only the test copy is modified.
python3 - "$run/check-disk.sh" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
s = s.replace('start_log check-disk', '''start_log check-disk
df() { printf 'Filesystem 1024-blocks Used Available Capacity Mounted on\\nfixture 100 80 20 80%% /\\n'; }
printf 'SIMULATION: df fixture at 80 percent, real filesystem not filled\\n' ''')
p.write_text(s)
PY
if bash "$run/check-disk.sh" > "$run/output.txt" 2>&1; then die 'Expected warning exit absent'; else rc=$?; fi
cat "$run/output.txt"
[[ $rc = 1 ]] && grep -q 'WARN disk=80%' "$run/output.txt" || die 'Threshold simulation failed'
printf 'PASS SIMULATION: warning at 80 percent. Not evidence of a physically full disk.\n'
