#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::IDs is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: IDs.pm,v 1.1 1999/05/26 15:42:16 kmacleod Exp $
#

use strict;

package XML::Grove::IDs;

use Data::Grove::Visitor;

sub new {
    my ($type, $name, $elements) = @_;
    $name = 'id' if(!defined $name);
    return (bless {Name => $name, Elements => $elements}, $type);
}

sub visit_document {
    my $self = shift; my $grove = shift; my $hash = shift;
    $grove->children_accept ($self, $hash);
}

sub visit_element {
    my $self = shift; my $element = shift; my $hash = shift;

    if(!$self->{Elements} or $self->{Elements}{$element->{Name}}) {
           my $id = $element->{Attributes}{$self->{Name}};
           $hash->{$id} = $element
               if (defined $id);
    }

    $element->children_accept ($self, $hash);
}

###
### Extend the XML::Grove::Document and XML::Grove::Element packages with our
### new function.
###

package XML::Grove::Document;

sub get_ids {
    my $self = shift;

    my $hash = {};
    $self->accept(XML::Grove::IDs->new(@_), $hash);
    return $hash;
}

package XML::Grove::Element;

sub get_ids {
    my $self = shift;

    my $hash = {};
    $self->accept(XML::Grove::IDs->new(@_), $hash);
    return $hash;
}

1;
