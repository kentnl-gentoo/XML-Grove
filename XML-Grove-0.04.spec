Summary: Perl module for simple, non-validating XML objects
Name: XML-Grove
Version: 0.04
Release: 1
Source: ftp://ftp.uu.net/vendor/bitsko/gdo/XML-Grove-0.04.tar.gz
Copyright: distributable
Group: Applications/Publishing/XML
URL: http://www.bitsko.slc.ut.us/
Packager: ken@bitsko.slc.ut.us (Ken MacLeod)
BuildRoot: /tmp/XML-Grove

#
# $Id: XML-Grove.spec,v 1.5 1998/04/11 15:42:26 ken Exp $
#

%description
XML::Grove is a Perl module that provides simple objects for parsed
XML documents.  The objects may be modified but no checking is
performed by XML::Grove.  XML::Grove objects do not include parsing
information such as character positions or type of tags used.

%prep
%setup

perl Makefile.PL INSTALLDIRS=perl

%build

make

%install

make PREFIX="${RPM_ROOT_DIR}/usr" pure_install

DOCDIR="${RPM_ROOT_DIR}/usr/doc/XML-Grove-0.04-1"
mkdir -p "$DOCDIR/examples"
for ii in README COPYING Changes test.pl examples/*; do
  cp $ii "$DOCDIR/$ii"
  chmod 644 "$DOCDIR/$ii"
done

%files

/usr/doc/XML-Grove-0.04-1

/usr/lib/perl5/XML/Grove/AsString.pm
/usr/lib/perl5/XML/Grove/AsCanonXML.pm
/usr/lib/perl5/XML/Grove/Iter.pm
/usr/lib/perl5/XML/Grove/Visitor.pm
/usr/lib/perl5/XML/Grove.pm
/usr/lib/perl5/XML/Parser/Grove.pm
/usr/lib/perl5/man/man3/XML::Grove.3
