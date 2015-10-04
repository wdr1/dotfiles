#!/usr/local/bin/perl -w

use strict;
use URI::Escape;
use Data::Dumper;

my $url = shift;
die("No url!") unless ($url);

print Dumper( &decompose( $url ) );

sub decompose {
  my ($val) = @_;

  print "Decomposing: '$val' \n";
  if ($val =~ m|http://|) {
    my %h;
    my ($url, $qs) = split /\?/, $val;

    foreach my $p (split /&/, $qs) {
      my ($key, $val) = split /=/, $p;
      if ($val) {
        $h{ $url }->{ $key } = decompose( $val );
      } else {
        $h{ $url }->{ $key } = undef;
      }
    }    
    return \%h;
  } else {
    return uri_unescape( $val );
  }
}
