#!/usr/bin/env python
# coding: utf-8

# # This file generates "SELECT" test statements for dpkg test cases

with open("../sql/test_dpkg") as f:
    fin = f.readlines()

output = open("test_case_from_dpkg.sql", "wt")
output.write("CREATE EXTENSION debversion;\n")
for line in fin:
    if line == '\n':
        continue
    data = line.split()
    version1 = data[0]
    version2 = data[1]
    text = f"SELECT '{version1}'::debversion < '{version2}'::debversion;\n"
    output.write(text)
    text = f"SELECT '{version1}'::debversion > '{version2}'::debversion;\n"
    output.write(text)
    text = f"SELECT '{version1}'::debversion = '{version2}'::debversion;\n"
    output.write(text)

output.close()

