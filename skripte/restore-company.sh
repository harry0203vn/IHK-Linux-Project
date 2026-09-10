#!/bin/bash
# Restore a single missing regular file; never overwrite a directory/tree.
source "$(dirname -- "$0")/lib.sh"
start_log restore-company
[[ $# = 2 ]] || die 'Usage: restore-company.sh ARCHIVE RELATIVE_FILE (e.g. sales/test.txt)'
archive=$1; rel=$2
safe_dir "$BACKUP"
[[ $(dirname -- "$archive") = "$BACKUP" && ! -L $archive && -f $archive ]] || die 'Archive must be a regular project backup'
[[ $(basename -- "$archive") =~ ^company-[0-9]{8}T[0-9]{6}-[0-9]+\.tar\.gz$ ]] || die 'Invalid archive name'
[[ $rel =~ ^(it|sales|accounting|management|public)/[a-zA-Z0-9._/-]+$ && $rel != *..* && $rel != */ ]] || die 'Unsafe relative path'
target=/company/$rel
safe_dir "$(dirname -- "$target")"
[[ -d $(dirname -- "$target") && ! -e $target && ! -L $target ]] || die 'Parent missing or destination already exists'
[[ -f $archive.sha256 && ! -L $archive.sha256 ]] || die 'Checksum missing'
sha256sum --check "$archive.sha256"
python3 - "$archive" "company/$rel" <<'PY'
import sys, tarfile
with tarfile.open(sys.argv[1], 'r:gz') as t:
    items = [m for m in t.getmembers() if m.name == sys.argv[2]]
    if len(items) != 1 or not items[0].isfile():
        raise SystemExit('Restore requires exactly one regular member')
PY
tar --acls --xattrs --numeric-owner --keep-old-files -xzpf "$archive" -C / "company/$rel"
stat "$target"; sha256sum "$target"
printf 'RESTORE_OK %s\n' "$target"
