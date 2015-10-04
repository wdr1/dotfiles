#!/usr/local/bin/perl -w

use strict;
use IO::All;

my $SLOTS = 3;
my $BACKUP_ROOT = "H:/backups";
my $MASTER_LIST = "C:/backup_list.txt";

my $RSYNC = 'C:/cygwin/bin/rsync';
my $RSYNC_FLAGS = '-Crltv --delete';

&main();

sub main {
  ## Figure out which slot to use
  my $sfile = "$BACKUP_ROOT/current_slot.txt";
  my $slot < io($sfile);
  $slot = ($slot + 1) % $SLOTS;
  $slot > io($sfile);
  my $sdir = "$BACKUP_ROOT/slot$slot";
  print "Backing up to slot $slot in '$sdir'\n";

  ## Clear out/initalize various files from last run
  my $bfile = "$sdir/\@backedupat.txt";
  my $logfile = "$sdir/\@backedupat.log";
  scalar localtime > io($bfile);
  scalar localtime > io($logfile);
  "" > io('c:\backup.log');

  ## Running the full master list can take *way* too long, so we
  ## do it piece by piece
  open(ML, $MASTER_LIST) || die($!);
  my @dirs = <ML>;
  foreach my $i (@dirs) {
    my $TMP_LIST = 'C:/tmp/backup.lst';
    $i > io($TMP_LIST);
    chomp($i);
    my $str = "== Backing up '$i' ==\n";
    my $output = $str;
    print "\n\n";
    print $str;
    
    ## Run the rsync cmd
    my $cmd = "$RSYNC $RSYNC_FLAGS --files-from=$TMP_LIST /cygdrive $sdir";
    $cmd =~ s|(\w):|/cygdrive/$1/|g;
    my $cfile = 'C:\tmp\backup.sh';
    print "$cmd\n";
    $cmd > io($cfile);

    $cmd = "bash $cfile";
    print "$cmd\n";
    my $time = time;
    $output = "Backup starting at " . scalar localtime() . "\n";
    $output .= `$cmd`;
    $output .= "Backup took " . (time - $time) . " seconds\n";
    print $output;

    ## Record the output to debug problems latter on
    $output >> io('c:\backup.log');
    $output >> io($logfile);
  }

  ## Stop time
  scalar localtime >> io($bfile);
}

