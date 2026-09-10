"""Local pure validation tests. No Linux account/database mutations."""
import importlib.util
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('validator', ROOT / 'skripte/validate-csv.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

class CsvTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.g = Path(self.tmp.name) / 'groups.csv'
        self.u = Path(self.tmp.name) / 'users.csv'
        self.g.write_bytes((ROOT / 'daten/groups.csv').read_bytes())
        self.u.write_bytes((ROOT / 'daten/users.csv').read_bytes())

    def test_valid_empty_extra(self):
        g, u = module.validate(self.g, self.u)
        self.assertEqual((len(g), len(u)), (5, 7))
        self.assertEqual(u[-1][2], '')

    def test_duplicate(self):
        self.u.write_text(self.u.read_text() + 'sales01,sales,employees,Duplicate\n')
        with self.assertRaises(ValueError): module.validate(self.g, self.u)

    def test_unknown_group(self):
        self.u.write_text(self.u.read_text().replace('sales01,sales,', 'sales01,unknown,'))
        with self.assertRaises(ValueError): module.validate(self.g, self.u)

    def test_bad_columns(self):
        self.u.write_text(self.u.read_text() + 'bad,line\n')
        with self.assertRaises(ValueError): module.validate(self.g, self.u)

    def test_reserved(self):
        self.u.write_text(self.u.read_text().replace('sales01,', 'root,'))
        with self.assertRaises(ValueError): module.validate(self.g, self.u)

    def test_injection(self):
        self.u.write_text(self.u.read_text().replace('sales01,', 'x;touch-hacked,'))
        with self.assertRaises(ValueError): module.validate(self.g, self.u)

    def test_crlf(self):
        self.u.write_bytes(self.u.read_bytes().replace(b'\n', b'\r\n'))
        self.assertEqual(len(module.validate(self.g, self.u)[1]), 7)

    def test_header(self):
        self.u.write_text(self.u.read_text().replace('username,', 'name,'))
        with self.assertRaises(ValueError): module.validate(self.g, self.u)

if __name__ == '__main__': unittest.main(verbosity=2)
