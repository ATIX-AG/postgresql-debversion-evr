EXTENSION = debversion        # the extensions name
DATA = debversion--0.0.1.sql  # script files to install
REGRESS = debversion_test test_case_from_dpkg    # our test script file (without extension)


# postgres build stuff
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
