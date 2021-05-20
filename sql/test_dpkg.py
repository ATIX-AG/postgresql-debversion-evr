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
        text = f"SELECT '{version1}'::debversion_evr < '{version2}'::debversion_evr;\n"
        output.write(text)
        text = f"SELECT '{version1}'::debversion_evr > '{version2}'::debversion_evr;\n"
        output.write(text)
        text = f"SELECT '{version1}'::debversion_evr = '{version2}'::debversion_evr;\n"
        output.write(text)

    output.close()
