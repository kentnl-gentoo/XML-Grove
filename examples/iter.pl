#
# Copyright (C) 1998 Ken MacLeod
# See the file COPYING for distribution terms.
#
# $Id: iter.pl,v 1.2 1998/09/20 18:48:01 kmacleod Exp $
#

use XML::Parser;
use XML::Parser::Grove;
use XML::Grove;
use XML::Grove::Iter;

my $doc;
my $parser = XML::Parser->new(Style => 'grove');
foreach $doc (@ARGV) {
    my $grove = $parser->parsefile ($doc);

    dump_grove ($grove->iter);
}


sub dump_grove {
    my $element = shift;
    my $item;

    # get the names of each element in our path to the root
    my @context = $element->rootpath;
    # remove Grove object, which has no name
    shift @context;
    foreach $item (@context) {
	$item = $item->name;
    }

    # note an idea in Iter.pm to use a tied-array for the return value
    # of `$item->contents' so one could use this here:
    #
    #     foreach $item ($element->contents) {
    #     }

    $item = $element->first_child;
    while ($item) {
	if (ref ($item) =~ /::Element/) {
	    my @attributes = %{$item->attributes};
	    print STDERR "@context \\\\ (@attributes)\n";
	    dump_grove ($item);
	    print STDERR "@context //\n";
	} elsif (ref ($item) =~ /::PI/) {
	    my $target = $item->target;
	    my $data = $item->data;
	    print STDERR "@context ?? $target($data)\n";
	} elsif (ref ($item) =~ /::Scalar/) {
	    my $text = $item->delegate;
	    $text =~ s/([\x80-\xff])/sprintf "#x%X;", ord $1/eg;
	    $text =~ s/([\t\n])/sprintf "#%d;", ord $1/eg;
	    print STDERR "@context || $text\n";
	} else {
	    print STDERR "@context !! OTHER: $item\n";
	}

	$item = $item->next;
    }
}
