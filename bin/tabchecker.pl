#!/usr/local/bin/perl -w

use strict;

my $file = shift;
die("No file given!") unless ($file);

my $c = 0;
my $line = 0;
my @out;
open(F, $file) || die("Couldn't open '$file': $!");
while (<F>) {
  $line++;
  my $f = 0;
  $f = $_ =~ s/\t/________/g;
  if ($f) {
    push @out, "$line: $_";
  }
}

print "$c tabs found\n";
print @out;
