"""Create a deployment-only ZIP with checksums; never include evidence or secrets."""
from pathlib import Path
import hashlib
import json
import zipfile

root = Path(__file__).resolve().parents[1]
dest = root / 'deployment'
dest.mkdir(exist_ok=True)
paths = []
for folder in ['skripte', 'daten', 'konfiguration', 'tests']:
    paths.extend(p for p in (root / folder).rglob('*')
                 if p.is_file() and p.suffix in {'.sh', '.py', '.csv', '.conf'}
                 and '__pycache__' not in p.parts)
for name in ['DEPLOYMENT.md', 'ADMIN_CASES.md']:
    paths.append(root / 'dokumentation' / name)
manifest = {}
for p in sorted(paths):
    data = p.read_bytes()
    if b'\r' in data:
        raise SystemExit(f'Non-LF source refused: {p.name}')
    manifest[p.relative_to(root).as_posix()] = hashlib.sha256(data).hexdigest()
zip_path = dest / 'ihk-linux-deployment.zip'
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
    for p in sorted(paths):
        z.write(p, p.relative_to(root).as_posix())
    z.writestr('MANIFEST.json', json.dumps(manifest, indent=2) + '\n')
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
    for name, expected in manifest.items():
        assert hashlib.sha256(z.read(name)).hexdigest() == expected
digest = hashlib.sha256(zip_path.read_bytes()).hexdigest()
(dest / 'SHA256SUMS.txt').write_text(f'{digest}  {zip_path.name}\n', encoding='utf-8')
print(f'PACKAGE CHECKED: {len(paths)} files; ZIP CRC and member hashes match')
print(f'{zip_path}\nSHA256 {digest}')
