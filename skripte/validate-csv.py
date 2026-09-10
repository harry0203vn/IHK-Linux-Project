#!/usr/bin/env python3
"""Validate the complete input before any account is changed. No shell evaluation."""
import csv
import re
import sys
from pathlib import Path

def read(path, header):
    with Path(path).open(encoding='utf-8-sig', newline='') as f:
        reader = csv.reader(f)
        if next(reader, None) != header:
            raise ValueError(f'{path}: incorrect header')
        rows = list(reader)
    if not rows:
        raise ValueError(f'{path}: empty input')
    for number, row in enumerate(rows, 2):
        if len(row) != len(header) or any('\n' in x or '\r' in x or '\t' in x for x in row):
            raise ValueError(f'{path}:{number}: invalid column count/control characters')
        if any(x != x.strip() for x in row):
            raise ValueError(f'{path}:{number}: surrounding whitespace')
    return rows

def validate(groups_path, users_path):
    groups = read(groups_path, ['groupname', 'description'])
    users = read(users_path, ['username', 'primary_group', 'additional_group', 'fullname'])
    names = set()
    for name, desc in groups:
        if not re.fullmatch(r'[a-z][a-z0-9._-]{0,30}', name) or name in names or not desc:
            raise ValueError('Invalid or duplicate group')
        names.add(name)
    seen = set()
    for name, primary, additional, full in users:
        if not re.fullmatch(r'[a-z][a-z0-9._-]{0,30}', name) or name in seen:
            raise ValueError('Invalid or duplicate user')
        if name in {'root', 'admin', 'harry'} or primary not in names or (additional and additional not in names):
            raise ValueError('Reserved user or unknown group')
        if not full or ':' in full or ',' in full:
            raise ValueError('Invalid full name')
        seen.add(name)
    return groups, users

if __name__ == '__main__':
    try:
        g, u = validate(sys.argv[1], sys.argv[2])
        # TSV is deliberately delimiter-safe. Empty extra group represented by '-'.
        if len(sys.argv) == 4 and sys.argv[3] == 'users':
            for name, primary, extra, full in u:
                print('\t'.join([name, primary, extra or '-', full]))
        elif len(sys.argv) == 4 and sys.argv[3] == 'groups':
            for name, _ in g:
                print(name)
        else:
            print(f'CSV valid: {len(g)} groups, {len(u)} users')
    except (ValueError, OSError, IndexError, csv.Error) as exc:
        print(f'CSV ERROR: {exc}', file=sys.stderr)
        sys.exit(2)
