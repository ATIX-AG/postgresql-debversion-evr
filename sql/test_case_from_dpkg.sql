CREATE EXTENSION debversion;
SELECT '1.0-1'::debversion < '2.0-2'::debversion;
SELECT '1.0-1'::debversion > '2.0-2'::debversion;
SELECT '1.0-1'::debversion = '2.0-2'::debversion;
SELECT '2.2~rc-4'::debversion < '2.2-1'::debversion;
SELECT '2.2~rc-4'::debversion > '2.2-1'::debversion;
SELECT '2.2~rc-4'::debversion = '2.2-1'::debversion;
SELECT '2.2-1'::debversion < '2.2~rc-4'::debversion;
SELECT '2.2-1'::debversion > '2.2~rc-4'::debversion;
SELECT '2.2-1'::debversion = '2.2~rc-4'::debversion;
SELECT '1.0000-1'::debversion < '1.0-1'::debversion;
SELECT '1.0000-1'::debversion > '1.0-1'::debversion;
SELECT '1.0000-1'::debversion = '1.0-1'::debversion;
SELECT '1'::debversion < '0:1'::debversion;
SELECT '1'::debversion > '0:1'::debversion;
SELECT '1'::debversion = '0:1'::debversion;
SELECT '0'::debversion < '0:0-0'::debversion;
SELECT '0'::debversion > '0:0-0'::debversion;
SELECT '0'::debversion = '0:0-0'::debversion;
SELECT '2:2.5'::debversion < '1:7.5'::debversion;
SELECT '2:2.5'::debversion > '1:7.5'::debversion;
SELECT '2:2.5'::debversion = '1:7.5'::debversion;
SELECT '1:0foo'::debversion < '0foo'::debversion;
SELECT '1:0foo'::debversion > '0foo'::debversion;
SELECT '1:0foo'::debversion = '0foo'::debversion;
SELECT '0:0foo'::debversion < '0foo'::debversion;
SELECT '0:0foo'::debversion > '0foo'::debversion;
SELECT '0:0foo'::debversion = '0foo'::debversion;
SELECT '0foo'::debversion < '0foo'::debversion;
SELECT '0foo'::debversion > '0foo'::debversion;
SELECT '0foo'::debversion = '0foo'::debversion;
SELECT '0foo-0'::debversion < '0foo'::debversion;
SELECT '0foo-0'::debversion > '0foo'::debversion;
SELECT '0foo-0'::debversion = '0foo'::debversion;
SELECT '0foo'::debversion < '0foo-0'::debversion;
SELECT '0foo'::debversion > '0foo-0'::debversion;
SELECT '0foo'::debversion = '0foo-0'::debversion;
SELECT '0foo'::debversion < '0fo'::debversion;
SELECT '0foo'::debversion > '0fo'::debversion;
SELECT '0foo'::debversion = '0fo'::debversion;
SELECT '0foo-0'::debversion < '0foo+'::debversion;
SELECT '0foo-0'::debversion > '0foo+'::debversion;
SELECT '0foo-0'::debversion = '0foo+'::debversion;
SELECT '0foo~1'::debversion < '0foo'::debversion;
SELECT '0foo~1'::debversion > '0foo'::debversion;
SELECT '0foo~1'::debversion = '0foo'::debversion;
SELECT '0foo~foo+Bar'::debversion < '0foo~foo+bar'::debversion;
SELECT '0foo~foo+Bar'::debversion > '0foo~foo+bar'::debversion;
SELECT '0foo~foo+Bar'::debversion = '0foo~foo+bar'::debversion;
SELECT '0foo~~'::debversion < '0foo~'::debversion;
SELECT '0foo~~'::debversion > '0foo~'::debversion;
SELECT '0foo~~'::debversion = '0foo~'::debversion;
SELECT '1~'::debversion < '1'::debversion;
SELECT '1~'::debversion > '1'::debversion;
SELECT '1~'::debversion = '1'::debversion;
SELECT '12345+that-really-is-some-ver-0'::debversion < '12345+that-really-is-some-ver-10'::debversion;
SELECT '12345+that-really-is-some-ver-0'::debversion > '12345+that-really-is-some-ver-10'::debversion;
SELECT '12345+that-really-is-some-ver-0'::debversion = '12345+that-really-is-some-ver-10'::debversion;
SELECT '0foo-0'::debversion < '0foo-01'::debversion;
SELECT '0foo-0'::debversion > '0foo-01'::debversion;
SELECT '0foo-0'::debversion = '0foo-01'::debversion;
SELECT '0foo.bar'::debversion < '0foobar'::debversion;
SELECT '0foo.bar'::debversion > '0foobar'::debversion;
SELECT '0foo.bar'::debversion = '0foobar'::debversion;
SELECT '0foo.bar'::debversion < '0foo1bar'::debversion;
SELECT '0foo.bar'::debversion > '0foo1bar'::debversion;
SELECT '0foo.bar'::debversion = '0foo1bar'::debversion;
SELECT '0foo.bar'::debversion < '0foo0bar'::debversion;
SELECT '0foo.bar'::debversion > '0foo0bar'::debversion;
SELECT '0foo.bar'::debversion = '0foo0bar'::debversion;
SELECT '0foo1bar-1'::debversion < '0foobar-1'::debversion;
SELECT '0foo1bar-1'::debversion > '0foobar-1'::debversion;
SELECT '0foo1bar-1'::debversion = '0foobar-1'::debversion;
SELECT '0foo2.0'::debversion < '0foo2'::debversion;
SELECT '0foo2.0'::debversion > '0foo2'::debversion;
SELECT '0foo2.0'::debversion = '0foo2'::debversion;
SELECT '0foo2.0.0'::debversion < '0foo2.10.0'::debversion;
SELECT '0foo2.0.0'::debversion > '0foo2.10.0'::debversion;
SELECT '0foo2.0.0'::debversion = '0foo2.10.0'::debversion;
SELECT '0foo2.0'::debversion < '0foo2.0.0'::debversion;
SELECT '0foo2.0'::debversion > '0foo2.0.0'::debversion;
SELECT '0foo2.0'::debversion = '0foo2.0.0'::debversion;
SELECT '0foo2.0'::debversion < '0foo2.10'::debversion;
SELECT '0foo2.0'::debversion > '0foo2.10'::debversion;
SELECT '0foo2.0'::debversion = '0foo2.10'::debversion;
SELECT '0foo2.1'::debversion < '0foo2.10'::debversion;
SELECT '0foo2.1'::debversion > '0foo2.10'::debversion;
SELECT '0foo2.1'::debversion = '0foo2.10'::debversion;
SELECT '1.09'::debversion < '1.9'::debversion;
SELECT '1.09'::debversion > '1.9'::debversion;
SELECT '1.09'::debversion = '1.9'::debversion;
SELECT '1.0.8+nmu1'::debversion < '1.0.8'::debversion;
SELECT '1.0.8+nmu1'::debversion > '1.0.8'::debversion;
SELECT '1.0.8+nmu1'::debversion = '1.0.8'::debversion;
SELECT '3.11'::debversion < '3.10+nmu1'::debversion;
SELECT '3.11'::debversion > '3.10+nmu1'::debversion;
SELECT '3.11'::debversion = '3.10+nmu1'::debversion;
SELECT '0.9j-20080306-4'::debversion < '0.9i-20070324-2'::debversion;
SELECT '0.9j-20080306-4'::debversion > '0.9i-20070324-2'::debversion;
SELECT '0.9j-20080306-4'::debversion = '0.9i-20070324-2'::debversion;
SELECT '1.2.0~b7-1'::debversion < '1.2.0~b6-1'::debversion;
SELECT '1.2.0~b7-1'::debversion > '1.2.0~b6-1'::debversion;
SELECT '1.2.0~b7-1'::debversion = '1.2.0~b6-1'::debversion;
SELECT '1.011-1'::debversion < '1.06-2'::debversion;
SELECT '1.011-1'::debversion > '1.06-2'::debversion;
SELECT '1.011-1'::debversion = '1.06-2'::debversion;
SELECT '0.0.9+dfsg1-1'::debversion < '0.0.8+dfsg1-3'::debversion;
SELECT '0.0.9+dfsg1-1'::debversion > '0.0.8+dfsg1-3'::debversion;
SELECT '0.0.9+dfsg1-1'::debversion = '0.0.8+dfsg1-3'::debversion;
SELECT '4.6.99+svn6582-1'::debversion < '4.6.99+svn6496-1'::debversion;
SELECT '4.6.99+svn6582-1'::debversion > '4.6.99+svn6496-1'::debversion;
SELECT '4.6.99+svn6582-1'::debversion = '4.6.99+svn6496-1'::debversion;
SELECT '53'::debversion < '52'::debversion;
SELECT '53'::debversion > '52'::debversion;
SELECT '53'::debversion = '52'::debversion;
SELECT '0.9.9~pre122-1'::debversion < '0.9.9~pre111-1'::debversion;
SELECT '0.9.9~pre122-1'::debversion > '0.9.9~pre111-1'::debversion;
SELECT '0.9.9~pre122-1'::debversion = '0.9.9~pre111-1'::debversion;
SELECT '2:2.3.2-2+lenny2'::debversion < '2:2.3.2-2'::debversion;
SELECT '2:2.3.2-2+lenny2'::debversion > '2:2.3.2-2'::debversion;
SELECT '2:2.3.2-2+lenny2'::debversion = '2:2.3.2-2'::debversion;
SELECT '1:3.8.1-1'::debversion < '3.8.GA-1'::debversion;
SELECT '1:3.8.1-1'::debversion > '3.8.GA-1'::debversion;
SELECT '1:3.8.1-1'::debversion = '3.8.GA-1'::debversion;
SELECT '1.0.1+gpl-1'::debversion < '1.0.1-2'::debversion;
SELECT '1.0.1+gpl-1'::debversion > '1.0.1-2'::debversion;
SELECT '1.0.1+gpl-1'::debversion = '1.0.1-2'::debversion;
SELECT '1a'::debversion < '1000a'::debversion;
SELECT '1a'::debversion > '1000a'::debversion;
SELECT '1a'::debversion = '1000a'::debversion;
