Summary: Perl module for simple XML objects
Name: XML-Grove
Version: 0.44alpha
Release: 1
Source: ftp://ftp.uu.net/vendor/bitsko/gdo/XML-Grove-0.44alpha.tar.gz
Copyright: distributable
Group: Applications/Publishing/XML
URL: http://www.bitsko.slc.ut.us/
Packager: ken@bitsko.slc.ut.us (Ken MacLeod)
BuildRoot: /tmp/XML-Grove

#
# $Id: XML-Grove.spec,v 1.15 1999/08/11 16:00:11 kmacleod Exp $
#

%description
XML::Grove is a Perl module that provides simple objects for parsed
XML, SGML, and HTML documents.

%prep
%setup

perl Makefile.PL INSTALLDIRS=perl

%build

make

%install

make PREFIX="${RPM_ROOT_DIR}/usr" pure_install

DOCDIR="${RPM_ROOT_DIR}/usr/doc/XML-Grove-0.44alpha-1"
mkdir -p "$DOCDIR/examples" "$DOCDIR/t"
for ii in README COPYING Changes DOM DOM-ecmascript.pod t/* \
    `find examples -type f -print`; do
  cp $ii "$DOCDIR/$ii"
  chmod 644 "$DOCDIR/$ii"
done

%files

/usr/doc/XML-Grove-0.44alpha-1

/usr/lib/perl5/XML/Grove/AsCanonXML.pm
/usr/lib/perl5/XML/Grove/AsString.pm
/usr/lib/perl5/XML/Grove/Builder.pm
/usr/lib/perl5/XML/Grove/IDs.pm
/usr/lib/perl5/XML/Grove/Path.pm
/usr/lib/perl5/XML/Grove/PerlSAX.pm
/usr/lib/perl5/XML/Grove/Sub.pm
/usr/lib/perl5/XML/Grove/Subst.pm
/usr/lib/perl5/XML/Grove/XPointer.pm
/usr/lib/perl5/XML/Grove.pm
/usr/lib/perl5/man/man3/XML::Grove.3
/usr/lib/perl5/man/man3/XML::Grove::AsCanonXML.3
/usr/lib/perl5/man/man3/XML::Grove::AsString.3
/usr/lib/perl5/man/man3/XML::Grove::Builder.3
/usr/lib/perl5/man/man3/XML::Grove::IDs.3
/usr/lib/perl5/man/man3/XML::Grove::Path.3
/usr/lib/perl5/man/man3/XML::Grove::PerlSAX.3
/usr/lib/perl5/man/man3/XML::Grove::Sub.3
/usr/lib/perl5/man/man3/XML::Grove::Subst.3
/usr/lib/perl5/man/man3/XML::Grove::XPointer.3
