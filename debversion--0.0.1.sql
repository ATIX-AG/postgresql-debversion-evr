\echo Use "CREATE EXTENSION debversion" to load this file. \quit

-- function for version comparison

--compare two numbers
CREATE OR REPLACE FUNCTION deb_version_cmp_num(_left text, _right text) 
RETURNS integer 
--return -1 if left > right
--return 0 if left = right
--return 1 if left < right
AS $$
DECLARE
  lint integer;
  rint integer;
BEGIN
  --'0' and '' are compared as equal in the dpkg implementation
  IF _left = '' THEN
    _left = '0';
  END IF;
  IF _right = '' THEN
    _right = '0';
  END IF;
  lint := CAST (_left AS integer);
  rint := CAST (_right AS integer);
  IF lint < rint THEN
    RETURN -1;
  ELSIF lint > rint THEN
    RETURN 1;
  ELSE 
    RETURN 0;
  END IF;
END;
$$ IMMUTABLE STRICT LANGUAGE plpgsql;

--compare two strings without digits
CREATE OR REPLACE FUNCTION deb_version_cmp_al(_left text, _right text)
RETURNS integer
--return -1 if left > right
--return 0 if left = right
--return 1 if left < right
AS $$
DECLARE
  lpair text ARRAY[2];
  rpair text ARRAY[2];
BEGIN
  --go through the string character by character and compare
  lpair := ARRAY['', _left];
  rpair := ARRAY['', _right];

  LOOP
  --for each character do:
    IF lpair[2] = '' AND rpair[2] = '' THEN
      --both strings are equal and remaining characters are empty
      return 0;
    END IF;
    
    --get the next character into l/rpair[1]
    lpair := regexp_matches(lpair[2], '(.?)(.*)');
    rpair := regexp_matches(rpair[2], '(.?)(.*)');

    IF lpair[1] = rpair[1] THEN
      --characters are equal, continue with next character
      CONTINUE;
    END IF;
    --tilde comes before any other character and befor the empty string
    IF lpair[1] = '~' THEN
      RETURN -1;
    END IF;
    IF rpair[1] = '~' THEN
      RETURN 1;
    END IF;
    --next check for empty string
    IF lpair[1] = '' THEN
      RETURN -1;
    END IF;
    IF rpair[1] = '' THEN
      RETURN 1;
    END IF;
    --else order by ascii value of character
    IF lpair[1] SIMILAR TO '[a-zA-Z]' THEN
      IF rpair[1] SIMILAR TO '[a-zA-Z]' AND ascii(lpair[1]) > ascii(rpair[1]) THEN
        RETURN 1;
      END IF;
      RETURN -1;
    END IF;
    IF rpair[1] SIMILAR TO '[a-zA-Z]' THEN
      RETURN 1;
    END IF;
    IF ascii(lpair[1]) < ascii(rpair[1]) THEN
      RETURN -1;
    END IF;
    RETURN 1;
  END LOOP;
END;
$$ IMMUTABLE STRICT LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deb_version_cmp_string(lstring text, rstring text, _left text, _right text, version boolean)
RETURNS integer
--return -1 if left > right
--return 0 if left = right
--return 1 if left < right
AS $$
DECLARE
  lpair text ARRAY[2];
  rpair text ARRAY[2];
  res integer;
BEGIN
  --split of digits and non-digits part
  lpair[1] := LEFT (lstring, 1);
  rpair[1] := LEFT (rstring, 1);
  lpair[2] := lstring;
  rpair[2] := rstring;

  
  --if first characters are digit and non-digit (this is faulty for version)
  IF lpair[1] SIMILAR TO '[a-zA-Z\.\:\+\~\-]' THEN
    IF version THEN
      RAISE WARNING 'version % has bad syntax: version number does not start with digit', _left;
    END IF;
    IF rpair[1] SIMILAR TO '[0-9]' THEN
      RETURN 1;
    END IF;
  ELSIF rpair[1] SIMILAR TO '[a-zA-Z\.\:\+\~\-]' THEN
    IF version THEN
      RAISE WARNING 'version % has bad syntax: version number does not start with digit', _right;
    END IF;
    RETURN -1;
  END IF;

  --compare versions
  LOOP
    --if no more characters to compare, strings are equal
    IF lpair[2] = '' AND rpair[2] = '' THEN
      return 0;
    END IF;

    --cut off digit part starting from beginning and rest
    lpair := regexp_matches(lpair[2], '([0-9]*)(.*)');
    rpair := regexp_matches(rpair[2], '([0-9]*)(.*)');
    
    --compare digit part
    res := deb_version_cmp_num(lpair[1], rpair[1]);
    IF res != 0 THEN
      RETURN res;
    END IF;

    --cut off into largest non-digit part starting from beginning and rest
    lpair := regexp_matches(lpair[2], '([^0-9]*)(.*)');
    rpair := regexp_matches(rpair[2], '([^0-9]*)(.*)');

    --compare non-digit part
    res := deb_version_cmp_al(lpair[1], rpair[1]);
    IF res != 0 THEN
      RETURN res;
    END IF;
  END LOOP;
END
$$ IMMUTABLE STRICT LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION deb_version_cmp(_left text, _right text)
RETURNS integer
--return -1 if left > right
--return 0 if left = right
--return 1 if left < right
AS $$
DECLARE
  lepochver text ARRAY[2];
  repochver text ARRAY[2];
  lverrev text ARRAY[2];
  rverrev text ARRAY[2];
  res integer;
BEGIN
  --split in epoch and version+revision
  lepochver := regexp_matches(_left, '(?:([0-9]*):)?(.*)');
  lepochver[1] := coalesce(lepochver[1], '0');
  repochver := regexp_matches(_right, '(?:([0-9]*):)?(.*)');
  repochver[1] := coalesce(repochver[1], '0');
  
  --compare epoch
  res := deb_version_cmp_num(lepochver[1], repochver[1]);
  IF res != 0 THEN
    RETURN res;
  END IF;
  
  --split in version and revision
  lverrev := regexp_matches(lepochver[2], '(.*?)(?:-([a-zA-Z0-9\+\.~]*))?$');
  lverrev[2] := coalesce(lverrev[2], '');
  rverrev := regexp_matches(repochver[2], '(.*?)(?:-([a-zA-Z0-9\+\.~]*))?$');
  rverrev[2] := coalesce(rverrev[2], '');
  
  --compare version
  res := deb_version_cmp_string(lverrev[1], rverrev[1], _left, _right, TRUE);
  IF res != 0 THEN
    RETURN res;
  END IF;
  
  --compare revision
  res := deb_version_cmp_string(lverrev[2], rverrev[2], _left, _right, FALSE);
  RETURN res;
END
$$ IMMUTABLE STRICT LANGUAGE plpgsql;

-- new data type debversion
--debversion is a subtype from "text"

CREATE TYPE debversion;

CREATE OR REPLACE FUNCTION debversionin(cstring)
  RETURNS debversion
  AS 'textin'
  LANGUAGE internal
  IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION debversionout(debversion)
  RETURNS cstring
  AS 'textout'
  LANGUAGE internal
  IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION debversionrecv(internal)
  RETURNS debversion
  AS 'textrecv'
  LANGUAGE internal
  STABLE STRICT;

CREATE OR REPLACE FUNCTION debversionsend(debversion)
  RETURNS bytea
  AS 'textsend'
  LANGUAGE internal
  STABLE STRICT;

CREATE TYPE debversion (
    LIKE           = text,
    INPUT          = debversionin,
    OUTPUT         = debversionout,
    RECEIVE        = debversionrecv,
    SEND           = debversionsend,
    -- make it a non-preferred member of string type category
    CATEGORY       = 'S',
    PREFERRED      = false
);

COMMENT ON TYPE debversion IS 'Debian package version number';

CREATE OR REPLACE FUNCTION debversion(bpchar)
  RETURNS debversion
  AS 'rtrim1'
  LANGUAGE internal
  IMMUTABLE STRICT;

CREATE CAST (debversion AS text)    WITHOUT FUNCTION AS IMPLICIT;
CREATE CAST (debversion AS varchar) WITHOUT FUNCTION AS IMPLICIT;
CREATE CAST (debversion AS bpchar)  WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (text AS debversion)    WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (varchar AS debversion) WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (bpchar AS debversion)  WITH FUNCTION debversion(bpchar);

-- how to compare the new data type debversion via version compare function

CREATE OR REPLACE FUNCTION debversion_cmp (version1 debversion, version2 debversion)
  RETURNS integer
  AS $$
  DECLARE ret integer;
  begin
  SELECT deb_version_cmp(version1, version2) INTO ret;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_cmp (debversion, debversion)
  IS 'Compare Debian versions';

CREATE OR REPLACE FUNCTION debversion_eq (version1 debversion, version2 debversion)
  RETURNS boolean 
  AS $$
  DECLARE 
    sol integer;
    ret boolean;
  begin
  SELECT deb_version_cmp(version1, version2) INTO sol;
  case sol
    when 0 then ret := TRUE;
    else ret := FALSE;
  end case;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_eq (debversion, debversion)
  IS 'debversion equal';

CREATE OR REPLACE FUNCTION debversion_ne (version1 debversion, version2 debversion)
  RETURNS boolean 
  AS $$
  DECLARE 
    sol integer;
    ret boolean;
  begin
  SELECT deb_version_cmp(version1, version2) INTO sol;
  case sol
    when 0 then ret := FALSE;
    else ret := TRUE;
  end case;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_ne (debversion, debversion)
  IS 'debversion not equal';

CREATE OR REPLACE FUNCTION debversion_lt (version1 debversion, version2 debversion)
  RETURNS boolean 
  AS $$
  DECLARE 
    sol integer;
    ret boolean;
  begin
  SELECT deb_version_cmp(version1, version2) INTO sol;
  case sol
    when -1 then ret := TRUE;
    else ret := FALSE;
  end case;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_lt (debversion, debversion)
  IS 'debversion less-than';

CREATE OR REPLACE FUNCTION debversion_gt (version1 debversion, version2 debversion)
  RETURNS boolean 
  AS $$
  DECLARE 
    sol integer;
    ret boolean;
  begin
  SELECT deb_version_cmp(version1, version2) INTO sol;
  case sol
    when 1 then ret := TRUE;
    else ret := FALSE;
  end case;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_gt (debversion, debversion)
  IS 'debversion greater-than';

CREATE OR REPLACE FUNCTION debversion_le (version1 debversion, version2 debversion)
  RETURNS boolean 
  AS $$
  DECLARE 
    sol integer;
    ret boolean;
  begin
  SELECT deb_version_cmp(version1, version2) INTO sol;
  case sol
    when -1 then ret := TRUE;
    when 0 then ret := TRUE;
    else ret := FALSE;
  end case;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_le (debversion, debversion)
  IS 'debversion less-than-or-equal';

CREATE OR REPLACE FUNCTION debversion_ge (version1 debversion, version2 debversion)
  RETURNS boolean 
  AS $$
  DECLARE 
    sol integer;
    ret boolean;
  begin
  SELECT deb_version_cmp(version1, version2) INTO sol;
  case sol
    when 1 then ret := TRUE;
    when 0 then ret := TRUE;
    else ret := FALSE;
  end case;
  return ret;
  end;
  $$
  LANGUAGE plpgsql
  IMMUTABLE STRICT;
COMMENT ON FUNCTION debversion_ge (debversion, debversion)
  IS 'debversion greater-than-or-equal';

-- define operators for comparison

CREATE OPERATOR = (
  PROCEDURE = debversion_eq,
  LEFTARG = debversion,
  RIGHTARG = debversion,
  COMMUTATOR = =,
  NEGATOR = !=,
  RESTRICT = eqsel,
  JOIN = eqjoinsel
);
COMMENT ON OPERATOR = (debversion, debversion)
  IS 'debversion equal';

CREATE OPERATOR != (
  PROCEDURE = debversion_ne,
  LEFTARG = debversion,
  RIGHTARG = debversion,
  COMMUTATOR = !=,
  NEGATOR = =,
  RESTRICT = neqsel,
  JOIN = neqjoinsel
);
COMMENT ON OPERATOR != (debversion, debversion)
  IS 'debversion not equal';

CREATE OPERATOR < (
  PROCEDURE = debversion_lt,
  LEFTARG = debversion,
  RIGHTARG = debversion,
  COMMUTATOR = >,
  NEGATOR = >=,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);
COMMENT ON OPERATOR < (debversion, debversion)
  IS 'debversion less-than';

CREATE OPERATOR > (
  PROCEDURE = debversion_gt,
  LEFTARG = debversion,
  RIGHTARG = debversion,
  COMMUTATOR = <,
  NEGATOR = >=,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);
COMMENT ON OPERATOR > (debversion, debversion)
  IS 'debversion greater-than';

CREATE OPERATOR <= (
  PROCEDURE = debversion_le,
  LEFTARG = debversion,
  RIGHTARG = debversion,
  COMMUTATOR = >=,
  NEGATOR = >,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);
COMMENT ON OPERATOR <= (debversion, debversion)
  IS 'debversion less-than-or-equal';

CREATE OPERATOR >= (
  PROCEDURE = debversion_ge,
  LEFTARG = debversion,
  RIGHTARG = debversion,
  COMMUTATOR = <=,
  NEGATOR = <,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);
COMMENT ON OPERATOR >= (debversion, debversion)
  IS 'debversion greater-than-or-equal';

CREATE OPERATOR CLASS debversion_ops
DEFAULT FOR TYPE debversion USING btree AS
  OPERATOR 1 <  (debversion, debversion),
  OPERATOR 2 <= (debversion, debversion),
  OPERATOR 3 =  (debversion, debversion),
  OPERATOR 4 >= (debversion, debversion),
  OPERATOR 5 >  (debversion, debversion),
  FUNCTION 1 debversion_cmp(debversion, debversion);

