CREATE EXTENSION debversion_evr;

--equal versions
SELECT '1:2.3-bla-1'::debversion_evr = '1:2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr != '1:2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr <= '1:2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr >= '1:2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr < '1:2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr > '1:2.3-bla-1'::debversion_evr;

-- different epoch
SELECT '1:2.3-bla-1'::debversion_evr = '2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr != '2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr <= '2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr >= '2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr < '2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr > '2.3-bla-1'::debversion_evr;

-- different revision
SELECT '1:2.3-bla-1'::debversion_evr = '1:2.3-bla-2'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr != '1:2.3-bla-2'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr <= '1:2.3-bla-2'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr >= '1:2.3-bla-2'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr < '1:2.3-bla-2'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr > '1:2.3-bla-2'::debversion_evr;

--different versions
SELECT '1:2.3-bla-1'::debversion_evr = '1:2.3-blaa-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr != '1:2.3-blaa-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr <= '1:2.3-blaa-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr >= '1:2.3-blaa-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr < '1:2.3-blaa-1'::debversion_evr;
SELECT '1:2.3-bla-1'::debversion_evr > '1:2.3-blaa-1'::debversion_evr;

--real world examples
SELECT '1.60-26+b1'::debversion_evr < '1.60+git20161116.90da8a0-1'::debversion_evr;

--non-valid versions (but dpkg can handle these with warning message)
SELECT '1:bla-1'::debversion_evr < '1:2.3-bla-1'::debversion_evr;
SELECT '1:bla-1'::debversion_evr > '1:2.3-bla-1'::debversion_evr;

SELECT '1:2.3-bla-a'::debversion_evr < '1:2.3-bla-1'::debversion_evr;
SELECT '1:2.3-bla-a'::debversion_evr > '1:2.3-bla-1'::debversion_evr;

--these throw errors in dpkg (dpkg cannot handle them)
--SELECT '1:2.3-bla-1'::debversion_evr < '1:2.3-bla-'::debversion_evr;
--SELECT '1:2.3-bla-1'::debversion_evr > '1:2.3-bla-'::debversion_evr;

--long numeric values in version
SELECT '1.0.20181217162649+dfsg-10'::debversion_evr != '1.0.20181217162649+dfsg-10'::debversion_evr;
SELECT '1.0.20181217162649+dfsg-10'::debversion_evr = '1.0.20181217162649+dfsg-10'::debversion_evr;
