#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::Sub is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Sub.pm,v 1.1 1999/05/26 15:42:16 kmacleod Exp $
#

use strict;

package XML::Grove::Sub;

use Data::Grove::Visitor;

sub new {
    my $type = shift;
    return (bless {}, $type);
}

sub visit_document {
    my $self = shift; my $document = shift; my $sub = shift;
    return (&$sub($document, @_),
	    $grove->children_accept ($self, $sub, @_));
}

sub visit_element {
    my $self = shift; my $element = shift; my $sub = shift;
    return (&$sub($element, @_),
	    $element->children_accept ($self, $sub, @_));
}

sub visit_entity {
    my $self = shift; my $entity = shift; my $sub = shift;
    return (&$sub($entity, @_));
}

sub visit_pi {
    my $self = shift; my $pi = shift; my $sub = shift;
    return (&$sub($pi, @_));
}

sub visit_comment {
    my $self = shift; my $comment = shift; my $sub = shift;
    return (&$sub($comment, @_));
}

sub visit_characters {
    my $self = shift; my $characters = shift; my $sub = shift;
    return (&$sub($characters, @_));
}

###
### Extend the XML::Grove::Document and XML::Grove::Element packages with our
### new function.
###

package XML::Grove::Document;

sub filter {
    my $self = shift; my $sub = shift;

    return ($self->accept(XML::Grove::Sub->new, $sub, @_));
}

package XML::Grove::Element;

sub filter {
    my $self = shift; my $sub = shift;

    return ($self->accept(XML::Grove::Sub->new, $sub, @_));
}

1;
