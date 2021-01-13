CREATE EXTENSION debversion;

--equal versions
SELECT '1:2.3-bla-1'::debversion = '1:2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion != '1:2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion <= '1:2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion >= '1:2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion < '1:2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion > '1:2.3-bla-1'::debversion;

-- different epoch
SELECT '1:2.3-bla-1'::debversion = '2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion != '2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion <= '2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion >= '2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion < '2.3-bla-1'::debversion;
SELECT '1:2.3-bla-1'::debversion > '2.3-bla-1'::debversion;

-- different revision
SELECT '1:2.3-bla-1'::debversion = '1:2.3-bla-2'::debversion;
SELECT '1:2.3-bla-1'::debversion != '1:2.3-bla-2'::debversion;
SELECT '1:2.3-bla-1'::debversion <= '1:2.3-bla-2'::debversion;
SELECT '1:2.3-bla-1'::debversion >= '1:2.3-bla-2'::debversion;
SELECT '1:2.3-bla-1'::debversion < '1:2.3-bla-2'::debversion;
SELECT '1:2.3-bla-1'::debversion > '1:2.3-bla-2'::debversion;

--different versions
SELECT '1:2.3-bla-1'::debversion = '1:2.3-blaa-1'::debversion;
SELECT '1:2.3-bla-1'::debversion != '1:2.3-blaa-1'::debversion;
SELECT '1:2.3-bla-1'::debversion <= '1:2.3-blaa-1'::debversion;
SELECT '1:2.3-bla-1'::debversion >= '1:2.3-blaa-1'::debversion;
SELECT '1:2.3-bla-1'::debversion < '1:2.3-blaa-1'::debversion;
SELECT '1:2.3-bla-1'::debversion > '1:2.3-blaa-1'::debversion;

--real world examples
SELECT '1.60-26+b1'::debversion < '1.60+git20161116.90da8a0-1'::debversion;

--non-valid versions (but dpkg can handle these with warning message)
SELECT '1:bla-1'::debversion < '1:2.3-bla-1'::debversion;
SELECT '1:bla-1'::debversion > '1:2.3-bla-1'::debversion;

SELECT '1:2.3-bla-a'::debversion < '1:2.3-bla-1'::debversion;
SELECT '1:2.3-bla-a'::debversion > '1:2.3-bla-1'::debversion;

--these throw errors in dpkg (dpkg cannot handle them)
--SELECT '1:2.3-bla-1'::debversion < '1:2.3-bla-'::debversion;
--SELECT '1:2.3-bla-1'::debversion > '1:2.3-bla-'::debversion;

