#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::Subst is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Subst.pm,v 1.1 1999/05/26 15:42:16 kmacleod Exp $
#

use strict;

package XML::Grove::Subst;

sub new {
    my $class = shift;

    return bless {}, $class;
}

sub subst {
    my $self = shift;
    my $grove_fragment = shift;
    my $args = [ @_ ];

    my $contents = $grove_fragment->accept($self, $args);
}

sub subst_hash {
    my $self = shift;
    my $grove_fragment = shift;
    my $args = shift;

    my $contents = $grove_fragment->accept($self, $args);
}

sub visit_document {
    my $self = shift; my $document = shift;

    my $contents = [ $document->children_accept ($self, @_) ];

    return
      XML::Grove::Document->new( Contents => $contents );
}

sub visit_element {
    my $self = shift; my $element = shift;

    my $name = $element->{Name};
    if ($name eq 'SUB:key') {
	my $subst = $_[0]{$element->{Attributes}{'key'}};
	if (ref($subst) eq 'ARRAY') {
	    return @$subst;
	} else {
	    if (ref($subst)) {
		return $subst;
	    } else {
		return XML::Grove::Characters->new( Data => $subst );
	    }
	}
    } elsif ($name =~ /^SUB:(.*)$/) {
	my $subst = $_[0][$1 - 1];
	if (ref($subst) eq 'ARRAY') {
	    return @$subst;
	} else {
	    if (ref($subst)) {
		return $subst;
	    } else {
		return XML::Grove::Characters->new( Data => $subst );
	    }
	}
    }

    my $contents = [ $element->children_accept ($self, @_) ];

    return
      XML::Grove::Element->new( Name => $name,
				Nttributes => $element->{Attributes},
				Contents => $contents );
}

sub visit_pi {
    my $self = shift; my $pi = shift;

    return $pi;
}

sub visit_characters {
    my $self = shift; my $characters = shift;

    return $characters;
}

1;
