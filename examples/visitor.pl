#
# Copyright (C) 1998 Ken MacLeod
# See the file COPYING for distribution terms.
#
# $Id: visitor.pl,v 1.2 1998/09/20 18:48:01 kmacleod Exp $
#

use XML::Parser;
use XML::Parser::Grove;
use XML::Grove;
use XML::Grove::Visitor;

my $doc;
my $parser = XML::Parser->new(Style => 'grove');

my $visitor = new MyVisitor;

foreach $doc (@ARGV) {
    my $grove = $parser->parsefile ($doc);

    my @context;
    $grove->accept ($visitor, \@context);
}

package MyVisitor;

sub new {
    my $class = shift;

    return bless {}, $class;
}

sub visit_grove {
    my $self = shift; my $grove = shift;

    $grove->children_accept ($self, @_);
}

sub visit_element {
    my $self = shift; my $element = shift; my $context = shift;

    push @$context, $element->name;
    my @attributes = %{$element->attributes};
    print STDERR "@$context \\\\ (@attributes)\n";
    $element->children_accept ($self, $context, @_);
    print STDERR "@$context //\n";
    pop @$context;
}

sub visit_pi {
    my $self = shift; my $pi = shift; my $context = shift;

    my $target = $pi->target;
    my $data = $pi->data;
    print STDERR "@$context ?? $target($data)\n";
}

sub visit_scalar {
    my $self = shift; my $scalar = shift; my $context = shift;

    $scalar =~ s/([\x80-\xff])/sprintf "#x%X;", ord $1/eg;
    $scalar =~ s/([\t\n])/sprintf "#%d;", ord $1/eg;
    print STDERR "@$context || $scalar\n";
}
