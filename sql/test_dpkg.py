#!/usr/bin/env python3
# coding: utf-8

# # This file generates "SELECT" test statements for dpkg test cases

with open("test_dpkg") as f:
    output = open("test_case_from_dpkg.sql", "wt")
    for line in f:
        if line == '\n':
            continue
        data = line.split()
        version1 = data[0]
        version2 = data[1]
        output.write(f"SELECT deb_version_cmp('{version1}', '{version2}');\n")

    output.close()
