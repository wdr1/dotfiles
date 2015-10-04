#!/usr/local/bin/perl -w

use Date::Calc qw| Monday_of_Week Week_of_Year Today |; 

our $default_dir = $ENV{HOME} . "/Docs/Weekly";

## Figure out the week
my ( $year, $month, $day ) = Today();
$line = sprintf("%02d/%02d/%04d", $month, $day, $year);
print $line, "\n";
my ($week) = Week_of_Year( $year, $month, $day );

## Then the Monday
($year, $month, $day) = Monday_of_Week( $week, $year );


$file = sprintf("log-%04d-%02d-%02d.txt", $year, $month, $day);
$file = "$default_dir/$file";
print $file, "\n";



my $data = "";
if (-e $file ) {
  open(F, $file) || die("Couldn't read from '$file': $!");
  {
    local $/ = undef;
    $data = <F>;
  }
}

if ($data) {
  $data =~ s/\s+$//s;
  $data .= "\n";
}
if ( $data !~ /^$line$/m ) {
  $data .= "\n\n\n" if ($data);
  $data .= "$line\n" . "-" x 78 . "\n";
}
  

system("cp $file .work_log.bak");
open(F, ">$file") || die("Couldn't append to '$file': $!");
print F $data;
close (F);

exec ("emacs -nw $file -f end-of-buffer && clear");
