#!/usr/bin/env python
# coding: utf-8

# # This file generates outputfile for debversioncompare tests using the built in version compare from dpkg.

from subprocess import run
import re

def compare(version1, version2, op):
    dictionary = {"<":"lt", ">":"gt", "<=":"le", ">=":"ge", "=":"eq", "!=":"ne"}
    dpkg_op = dictionary[op] 
    command = f"dpkg --compare-versions {version1} {dpkg_op} {version2}"
    result = run(command.split())
    if result.returncode == 0:
        return 't'
    else:
        return 'f'

with open("../sql/debversion_test.sql") as f:
    fin = f.readlines()

output = open("debversion_test.out", "wt")
for line in fin:
    if line == '\n':
        continue
    output.write(line)
    if line.startswith("SELECT '1:bla-1'::debversion"):
    	output.write("WARNING:  version 1:bla-1 has bad syntax: version number does not start with digit\n")
    if line.startswith("SELECT"):
        mask = re.compile(r"SELECT '([0-9a-zA-Z\+\-\.\:\~]+)'::debversion ([\>\<\=\!]+) '([0-9a-zA-Z\+\-\.\:\~]+)'::debversion;")
        match = mask.match(line)
        version1 = match.group(1)
        op = match.group(2)
        version2 = match.group(3)
        letter = compare(version1, version2, op)
        text = f" ?column? \n----------\n {letter}\n(1 row)\n\n"
        output.write(text)

output.close()



with open("../sql/test_case_from_dpkg.sql") as f:
    fin = f.readlines()

output = open("test_case_from_dpkg.out", "wt")
for line in fin:
    if line == '\n':
        continue
    output.write(line)
    if line.startswith("SELECT"):
        mask = re.compile(r"SELECT '([0-9a-zA-Z\+\-\.\:\~]+)'::debversion ([\>\<\=\!]+) '([0-9a-zA-Z\+\-\.\:\~]+)'::debversion;")
        match = mask.match(line)
        version1 = match.group(1)
        op = match.group(2)
        version2 = match.group(3)
        letter = compare(version1, version2, op)
        text = f" ?column? \n----------\n {letter}\n(1 row)\n\n"
        output.write(text)

output.close()

