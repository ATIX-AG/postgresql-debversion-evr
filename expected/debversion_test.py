#!/usr/bin/env python3
# coding: utf-8

# # This file generates outputfile for debversioncompare tests using the built in version compare from dpkg.

from subprocess import run
import re
import apt_pkg

FILES=[ 'debversion_test', 'test_case_from_dpkg', 'brute-force-test' ]

apt_pkg.init_system()

def compare_lib(version1, version2):
    res = apt_pkg.version_compare(version1, version2)

    if (res > 0):
        return 1;
    elif (res < 0):
        return -1;
    else:
        return 0;

def compare_cmd(version1, version2, op):
    dictionary = {"<":"lt", ">":"gt", "<=":"le", ">=":"ge", "=":"eq", "!=":"ne"}
    dpkg_op = dictionary[op]
    command = f"dpkg --compare-versions {version1} {dpkg_op} {version2}"
    result = run(command.split())
    if result.returncode == 0:
        return 't'
    else:
        return 'f'

def create_output(line):
    mask = re.compile(r"SELECT deb_version_cmp\('([0-9a-zA-Z\+\-\.\:\~]+)', '([0-9a-zA-Z\+\-\.\:\~]+)'\);")
    match = mask.match(line)
    version1 = match.group(1)
    version2 = match.group(2)
    letter = compare(version1, version2)
    return f" deb_version_cmp \n-----------------\n              {str(letter).rjust(2)}\n(1 row)\n\n"

# CHANGEME to use apt-pkg library or dpkg command for comparing
compare = compare_lib

for filename in FILES:
    print(f"Processing {filename}...", end='')
    try:
        with open(f"../sql/{filename}.sql") as fin:
            output = open(f"{filename}.out", "wt")
            for line in fin:
                if line == '\n':
                    continue
                output.write(line)
                if line.startswith("SELECT deb_version_cmp('1:bla-1'"):
                  output.write("WARNING:  version 1:bla-1 has bad syntax: version number does not start with digit\n")
                if line.startswith("SELECT"):
                    output.write(create_output(line))
            output.close()
        print('done')
    except IOError:
        print("File not accessible")
