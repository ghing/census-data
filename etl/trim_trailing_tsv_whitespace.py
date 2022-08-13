#!/usr/bin/env python
import sys

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: trim_trailing_tsv_whitespace.py file.tsv", file=sys.stderr)
        sys.exit(1)
    with open(sys.argv[1], 'tr') as f:
        for line in f:
            print(line.rstrip())
