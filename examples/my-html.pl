#
# Copyright (C) 1997, 1998 Ken MacLeod
# See the file COPYING for distribution terms.
#
# $Id: my-html.pl,v 1.2 1998/09/20 18:48:01 kmacleod Exp $
#

# `my-html.pl' uses `accept_name' methods to generate calls back using
# an element's name instead of the generic `visit_element'.  Because
# we don't want to handle every single possible element name, Perl's
# AUTOLOAD feature is used to pass through any elements we don't
# handle.

use XML::Parser;
use XML::Parser::Grove;
use XML::Grove;
use XML::Grove::Visitor;
use XML::Grove::AsString;

($prog = $0) =~ s|.*/||g;

die "usage: $prog HTML-DOC\n"
    if ($#ARGV != 0);

my $parser = XML::Parser->new(Style => 'grove');
my $grove = $parser->parsefile (@ARGV[0]);

$grove->accept_name (MyHTML->new);

exit (0);

######################################################################
#
# A Visitor package.
#

package MyHTML;

use strict;
use vars qw{$AUTOLOAD};

sub new {
    my $class = shift;

    return bless {}, $class;
}

sub visit_grove {
    my $self = shift;
    my $grove = shift;

    $grove->children_accept_name ($self, @_);
}

sub visit_element {
    die "$::prog: visit_element called while using accept_name??\n";
}

sub visit_entity {
    my $self = shift;
    my $entity = shift;

    warn "is entity?\n";
    print "&" . $entity->name . ";";
}

sub visit_scalar {
    my $self = shift;
    my $scalar = shift;

    # FIXME do we need to translate special chars here?
    $scalar =~ tr/\r/\n/;
    print $scalar;
}

######################################################################
#
# My special HTML tags
#

sub visit_name_DATE {
    my $time = localtime;

    # use only non-breaking spaces
    $time =~ s/ /\&nbsp;/g;

    print $time;
}

sub visit_name_PERL {
    my $self = shift;
    my $element = shift;

    # doesn't grok entities, be sure to use CDATA marked sections
    my $perl = $element->as_string;
    $perl =~ tr/\r//d;
    no strict;
    eval $perl;
    use strict;
    warn $@ if $@;
}

######################################################################
#
# Everything else
#
# See ``perltoot - Tom's object-oriented tutorial for perl''
# for a discussion of AUTOLOAD
#   <http://www.perl.com/CPAN/doc/FMTEYEWTK/perltoot.html>
#
sub AUTOLOAD {
    my $self = shift;

    my $type = ref($self)
	or die "$self is not an object, calling $AUTOLOAD";

    my $name = $AUTOLOAD;
    # strip fully-qualified portion, returning operator and name
    my $op;
    ($op, $name) = ($name =~ /.*::(visit_name_)?(.*)/);
    
    die "$::prog: called AUTOLOAD without \`visit_name_': $AUTOLOAD\n"
	if ($op ne 'visit_name_');

    # FIXME needs to output attributes
    my $element = shift;
    print "<$name>";
    $element->children_accept_name ($self, @_);
    print "</$name>";
}

1;
