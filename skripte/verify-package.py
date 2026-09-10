#!/usr/bin/env python3
"""Check the extracted deployment manifest before privileged execution."""
import hashlib
import json
from pathlib import Path, PurePosixPath

root = Path(__file__).resolve().parents[1]
manifest = root / 'MANIFEST.json'
if not manifest.is_file():
    raise SystemExit('MANIFEST.json missing: use the extracted deployment package')
entries = json.loads(manifest.read_text())
for name, expected in entries.items():
    relative = PurePosixPath(name)
    if relative.is_absolute() or '..' in relative.parts or '\\' in name:
        raise SystemExit(f'Unsafe manifest entry: {name}')
    path = root.joinpath(*relative.parts)
    if path.is_symlink() or not path.resolve().is_relative_to(root):
        raise SystemExit(f'Unsafe package path: {name}')
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
        raise SystemExit(f'Package mismatch: {name}')
print(f'PACKAGE HASH CHECK PASS: {len(entries)} files (integrity, not VM verification)')
