#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::Path is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Path.pm,v 1.1 1999/05/26 15:42:16 kmacleod Exp $
#

#
# Paths are like URLs
#
#     /html/body/ul/li[4]
#     /html/body/#pi[2]
#
# The path segments can be element names or object types, the objects
# types are named, as in XPointers, using:
#
#     #element
#     #pi
#     #comment
#     #text
#     #cdata
#     #any
#
#


package XML::Grove::Path;

use XML::Grove;
use XML::Grove::XPointer;
use UNIVERSAL;

sub at_path {
    my $element = shift;	# or Grove
    my $path = shift;

    $path =~ s|^/*||;

    my @path = split('/', $path);

    return (_at_path ($element, [@path]));
}

sub _at_path {
    my $element = shift;	# or Grove
    my $path = shift;
    my $segment = shift @$path;

    # segment := [ type ] [ '[' index ']' ]
    #
    # strip off the first segment, finding the type and index
    $segment =~ m|^
                ([^\[]+)?     # - look for an optional type
                              #   by matching anything but '['
                (?:           # - don't backreference the literals
                  \[          # - literal '['
                    ([^\]]+)  # - index, any non-']' chars
                  \]          # - literal ']'
                )?            # - the whole index is optional
               |x;
    my ($node_type, $instance, $match) = ($1, $2, $&);
    # issues:
    #   - should assert that no chars come after index and before next
    #     segment or the end of the query string

    $instance = 1 if !defined $instance;

    my $object = $element->xp_child ($instance, $node_type);

    if ($#$path eq -1) {
        return $object;
    } elsif (!$object->isa('XML::Grove::Element')) {
        # FIXME a location would be nice.
        die "\`$match' doesn't exist or is not an element\n";
    } else {
        return (_at_path($object, $path));
    }
}

package XML::Grove::Document;

sub at_path {
    goto &XML::Grove::Path::at_path;
}

package XML::Grove::Element;

sub at_path {
    goto &XML::Grove::Path::at_path;
}

1;
