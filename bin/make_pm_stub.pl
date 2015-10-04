#!/usr/local/bin/perl -w

use strict;

my $name = shift;

my $stub =<<'__STUB__'; 
package __NAME__;

## __NAME__.pm
##
## $Id: make_pm_stub.pl,v 1.1.1.1 2010/08/14 04:57:50 wdr1 Exp $
##
## Created __DATE__ -- William Reardon
## 
## 
## 
## 
## 


use strict;
use vars qw|$VERSION @EXPORT @EXPORT_OK $AUTOLOAD @accessors @ISA %EXPORT_TAGS|;

require Exporter;

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Foo ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
%EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

@EXPORT = qw(
	
);

## Maintain version automatically w/ CVS's help
$VERSION = substr(q$Revision: 1.1.1.1 $, 10);

## List of all simple, valid accessors.  used by autoload
@accessors = qw||; 

sub new {
  my ($proto) = @_;
  my ($class, $self);

  $self = {};

  $class = ref($proto) || $proto;
  bless ($self, $class);
  
  return $self;
}

sub AUTOLOAD {
  my $self = shift;
  my ($method);

  ($method = $AUTOLOAD) =~ s/^__NAME__:://;
  foreach my $i (@accessors) {
    if ($i eq $method) {
      if (@_) {
        $self->{$i} = shift;
        return $self->{$i};
      } else {
        return $self->{$i};
      }
    }
  }

  die("Package '__NAME__' doesn't know anything about '$method'.");  
}

sub DESTROY {
}

# Preloaded methods go here.

1;
__END__


=head1 NAME

__NAME__ - Perl extension for blah blah blah

=head1 SYNOPSIS

  use __NAME__;
  <sample>

=head1 DESCRIPTION

<description>

Blah blah blah.

=head2 Methods

None by default.


=head1 AUTHOR

William Reardon, wdr1@yahoo-inc.com

=head1 SEE ALSO

L<perl>.

=cut

__STUB__

## Make the need directories
my $dir = $name;
$dir =~ s|::|/|g;
my $file = $dir;
$dir =~ s|[^/]*$||;
if ($dir =~ m|/|) {
  my $error = `mkdir -p $dir`;
  die($error) if ($error);
}

## Prevent accidental clobers
$file = "$file.pm";
die("Remove '$file' first!\n") if (-e $file);

## Now write out everything to the file
$stub =~ s/__NAME__/$name/g;
my ($day, $month, $year) = (localtime)[3 .. 5];
$month++; $year += 1900;
my $date = sprintf("%02d-%02d-%d", $month, $day, $year);
$stub =~ s/__DATE__/$date/g;
open(F, ">$file") || die("Couldn't open '$file': $!");
print F $stub;
close(F);
