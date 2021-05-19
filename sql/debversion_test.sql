CREATE EXTENSION debversion_evr;

--equal versions
SELECT deb_version_cmp('1:2.3-bla-1', '1:2.3-bla-1');

-- different epoch
SELECT deb_version_cmp('1:2.3-bla-1', '2.3-bla-1');

-- different revision
SELECT deb_version_cmp('1:2.3-bla-1', '1:2.3-bla-2');

--different versions
SELECT deb_version_cmp('1:2.3-bla-1', '1:2.3-blaa-1');

--real world examples
SELECT deb_version_cmp('1.60-26+b1', '1.60+git20161116.90da8a0-1');

--non-valid versions (but dpkg can handle these with warning message)
SELECT deb_version_cmp('1:bla-1', '1:2.3-bla-1');

SELECT deb_version_cmp('1:2.3-bla-a', '1:2.3-bla-1');

--these throw errors in dpkg (dpkg cannot handle them)
--SELECT deb_version_cmp('1:2.3-bla-1', '1:2.3-bla-');

--long numeric values in version
SELECT deb_version_cmp('1.0.20181217162649+dfsg-10', '1.0.20181217162649+dfsg-10');
