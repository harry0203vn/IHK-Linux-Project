"""Local package integrity regression: clean extraction passes, tampering fails."""
from pathlib import Path
import subprocess
import sys
import tempfile
import zipfile

root = Path(__file__).resolve().parents[1]
base = (root / 'deployment').resolve()
with tempfile.TemporaryDirectory(prefix='package-check-', dir=base) as tmp:
    target = Path(tmp).resolve()
    assert target.is_relative_to(base)
    with zipfile.ZipFile(base / 'ihk-linux-deployment.zip') as archive:
        assert archive.testzip() is None
        for name in archive.namelist():
            assert (target / name).resolve().is_relative_to(target)
        archive.extractall(target)
    command = [sys.executable, str(target / 'skripte/verify-package.py')]
    good = subprocess.run(command, capture_output=True, text=True)
    assert good.returncode == 0, good.stderr
    print(good.stdout.strip())
    with (target / 'daten/users.csv').open('a') as f:
        f.write('tampered\n')
    bad = subprocess.run(command, capture_output=True, text=True)
    assert bad.returncode != 0 and 'Package mismatch' in bad.stderr
    print('PASS: modified CSV detected and rejected before VM commands')
