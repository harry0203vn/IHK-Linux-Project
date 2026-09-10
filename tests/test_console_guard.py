"""Local mocked ancestry checks; never touches SSH or the VM."""
from pathlib import Path
import os
import shutil
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]
BASH = r'C:\Program Files\Git\bin\bash.exe' if os.name == 'nt' else shutil.which('bash')

class ConsoleGuardTests(unittest.TestCase):
    def check(self, script):
        return subprocess.run([BASH, '-c', 'source skripte/lib.sh; ' + script],
                              cwd=ROOT, text=True, capture_output=True)

    def test_ssh_environment_rejected(self):
        result = self.check('SSH_CONNECTION=test; console_only')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('not SSH', result.stderr)

    def test_sudo_hidden_ssh_ancestor_rejected(self):
        result = self.check('unset SSH_CONNECTION; ps() { echo sshd-session; }; console_only')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('SSH ancestor', result.stderr)

    def test_unknown_ancestry_rejected(self):
        result = self.check('unset SSH_CONNECTION; ps() { return 1; }; console_only')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Cannot verify', result.stderr)

    def test_mock_console_accepted(self):
        result = self.check('unset SSH_CONNECTION; ps() { if [[ "$*" = *comm=* ]]; then echo sudo; else echo 1; fi; }; console_only')
        self.assertEqual(result.returncode, 0, result.stderr)

if __name__ == '__main__': unittest.main(verbosity=2)
