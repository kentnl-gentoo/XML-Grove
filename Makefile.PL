#
# Copyright (C) 1998 Ken MacLeod
# See the file COPYING for distribution terms.
#
# $Id: Makefile.PL,v 1.1.1.1 1998/04/02 19:30:20 ken Exp $
#

use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'XML::Grove',
    'VERSION_FROM' => 'lib/XML/Grove.pm',
    dist        => {'COMPRESS'  => 'gzip', 'SUFFIX'    => '.gz'},
);
