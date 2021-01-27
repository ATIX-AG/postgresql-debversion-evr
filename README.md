postgresql-debversion
====================

This extension to postgreSQL implements a new data type for versions of debian packages and the comparison of debian package versions in PL/pgSQL.

About
---------
Debian version numbers, used to version Debian binary and source
packages, have a defined format, including specifications for how
versions should be compared in order to sort them.  This package
implements a `debversion` type to represent Debian version numbers
within the PostgreSQL database.  This also includes operators for
version comparison and index operator classes for creating indexes on
the debversion type.

Version comparison uses the algorithm used by the Debian package
manager, dpkg, using the implementation from libapt-pkg.  This means
that columns in tables using the debversion type may be sorted and
compared correctly using the same logic as `dpkg --compare-versions`.
It is also possible to create indexes on these columns.

postgresql-debversion implements the following features:

* The `debversion` type (internally derived from the `text` type)
* A full set of operators for version comparison (< <= = != >= >)
  including commutator and negator optimisation hints


How to
----------

How to install the extension:

- download the extension
- go to folder containing the extension and run `make install`
- inside the postgres database run `CREATE EXTENSION debversion;`
- to uninstall extension from postgres run `DROP EXTENSION debversion;` in database

How to run tests:

- go to file `sql/debversion_test.sql`

- add test statements as `SELECT` commands, eg 

  `SELECT '1.60-26+b1'::debversion < '1.60+git20161116.90da8a0-1'::debversion;`

- go to folder `expected/`and run `python3 debversion_test.py` (this generates the output file `debversion_test.out` using the `dpkg --compare-versions` command in bash)

- in main directory run `make installcheck`


Copyright and License
---------------------

Some parts have been taken from an already existing extension `postgresql-debversion` from Roger Leigh which stands under the GNU General Public License and can be found at `https://salsa.debian.org/postgresql/postgresql-debversion/-/tree/master`.

The PL/pgSQL function for debian version comparison has been implemented by Katharina Kreuzer based on an implentation by Matthias Dellweg.