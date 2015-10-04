#!/usr/local/bin/perl -w

use strict;
use Date::Calc qw|Today Add_Delta_Days Day_of_Week|;
use Data::Dumper;

our $MAX_DAYS = 16;
our $TEMPLATE_FILE = "tickler.tmpl";
our $TICKLER_DIR = "$ENV{HOME}/Desktop/txt/daily";


## Load the defaults for each day
open(F, "$TICKLER_DIR/$TEMPLATE_FILE") ||
  die ("Couldn't read '$TICKLER_DIR/$TEMPLATE_FILE': $!");
my @days = split /=.*?\n/, join("", <F>);
shift @days;

## Write out the tickler files for each day
my $c = 0;
my ($y, $m, $d) = Today();
while ($c++ <= $MAX_DAYS) {
  my $f = sprintf("$TICKLER_DIR/daily_%04d-%02d-%02d.txt", $y, $m, $d);
  
  if (!-f $f && Day_of_Week( $y, $m, $d ) < 6) {
    print "Generating '$f'...\n";
    open(F, '>', $f) || die("Couldn't write to '$f': $!");
    print F $days[ 0 ];
    print F $days[ Day_of_Week( $y, $m, $d ) ]; 
  }
  
  ($y, $m, $d) = Add_Delta_Days($y, $m, $d, 1);
}
