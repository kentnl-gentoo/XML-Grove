#
# Copyright (C) 1998 Ken MacLeod
# See the file COPYING for distribution terms.
#
# $Id: grove.pl,v 1.2 1998/09/20 18:48:01 kmacleod Exp $
#

use XML::Parser;
use XML::Parser::Grove;
use XML::Grove;

my $doc;
my $parser = XML::Parser->new(Style => 'grove');
foreach $doc (@ARGV) {
    my $grove = $parser->parsefile ($doc);

    dump_grove ($grove);
}


sub dump_grove {
    my $grove = shift;
    my @context = ();

    _dump_contents ($grove->contents, \@context);
}

sub _dump_contents {
    my $contents = shift;
    my $context = shift;

    foreach $item (@$contents) {
	if (ref ($item) =~ /::Element/) {
	    push @$context, $item->name;
	    my @attributes = %{$item->attributes};
	    print STDERR "@$context \\\\ (@attributes)\n";
	    _dump_contents ($item->contents, $context);
	    print STDERR "@$context //\n";
	    pop @$context;
	} elsif (ref ($item) =~ /::PI/) {
	    my $target = $item->target;
	    my $data = $item->data;
	    print STDERR "@$context ?? $target($data)\n";
	} elsif (!ref ($item)) {
	    my $text = $item;
	    $text =~ s/([\x80-\xff])/sprintf "#x%X;", ord $1/eg;
	    $text =~ s/([\t\n])/sprintf "#%d;", ord $1/eg;
	    print STDERR "@$context || $text\n";
	} else {
	    print STDERR "@$context !! OTHER: $item\n";
	}
    }
}
