#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::XPointer is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: XPointer.pm,v 1.1 1999/05/26 15:42:16 kmacleod Exp $
#

use strict;

package XML::Grove::XPointer;

package XML::Grove::Document;

sub xp_child {
    goto &XML::Grove::Element::xp_child;
}

package XML::Grove::Element;

sub xp_child {
    my $self = shift;
    my $instance = shift;
    my $node_type = shift;

    my $look_for;
    if (defined($node_type) && substr($node_type, 0, 1) eq '#') {
	$node_type eq '#element' and do { $look_for = 'XML::Grove::Element' };
        $node_type eq '#pi'      and do { $look_for = 'XML::Grove::PI' };
        $node_type eq '#comment' and do { $look_for = 'XML::Grove::Comment' };
	$node_type eq '#text'    and do { $look_for = 'XML::Grove::Characters' };
	$node_type eq '#cdata'   and do { $look_for = 'XML::Grove::CData' };
	$node_type eq '#any'     and do { $node_type = undef };
    } elsif (defined($node_type)) {
	$look_for = 'element-name';
    }

    my $contents = $self->{Contents};
    my $object = undef;

    $instance--;		# 0 based

    if (!defined $node_type) {
	$object = $contents->[$instance];
    } elsif ($look_for eq 'element-name') {
	my $i_object;
	foreach $i_object (@$contents) {
	    if (ref($i_object) eq 'XML::Grove::Element'
		&& $i_object->{Name} eq $node_type
		&& $instance-- == 0) {
		$object = $i_object;
		last;
	    }
	}
    } else {
	my $i_object;
	foreach $i_object (@$contents) {
	    if (ref($i_object) eq $look_for
		&& $instance-- == 0) {
		$object = $i_object;
		last;
	    }
	}
    }

    return $object;
}

1;
