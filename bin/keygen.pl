#!/usr/local/bin/perl -w

use strict;

my @chars = ( 0 .. 9, 'a' .. 'z', 'A' .. 'Z');

my $num = shift;
$num ||= 128;

for (1 .. $num) {
  print $chars[ int(rand( scalar @chars )) ];
}
print "\n";
