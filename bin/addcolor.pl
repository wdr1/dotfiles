#! /usr/local/bin/perl

my $TRACK_ERRORS = 0;
my $SHORT_DISPLAY = 1;


print "\033[01;31m";

if ($ARGV[0] =~ /^\+/) {
    my $opts = shift @ARGV;
    if ( $opts =~ /s/ ) {
	$SHORT_DISPLAY = 1;
    }
    if ( $opts =~ /l/ ) {
	$SHORT_DISPLAY = 0;
    }
    if ( $opts =~ /e/ ) {
	$TRACK_ERRORS = 1;
    }
    if ( $opts =~ /q/ ) {
	$TRACK_ERRORS = 0;
    }
}

open STATUS, "gmake @ARGV 2>&1 |";
#open STATUS, "gmake @ARGV |";

#my $filename = $ARGV[0];

#if ($filename ne "") {
#    open PROJ_ERR, ">$filename"; 
#    select PROJ_ERR;
#    $|=1;
#    select STDOUT;
#}

$error = 0;
$errors = "";
unshift( @cur_dir, "current level");
#while (<STDIN>) {
while (<STATUS>) {
#    print PROJ_ERR $_ unless $filename;
#    next if ( m/should be global$/ );
    unless ( s/^(.*[^W][eE]rror[^\.\n]*)$/\033[01;41;37m$1\033[49;37;00m/g   # errors
	     || s/^(.+)(:[0-9]+:)/\033[32m$1\033[01;41;37m$2\033[49;37;00m/g
	     || s/(In .*:)$/\033[01;41;37m$1\033[49;37;00m/g   
	     || s/^(C .+)$/\033[01;41;37m$1\033[0m/g ) {       # conflicts from cvs   
	if ( $SHORT_DISPLAY ) {
	    next if ( m/^\? / );   # remove cvs comments for extra files
#unless ( s/^(\/[^ ]+\/g[+c][+c]) .* ([^ \]\[.\/\\]+\.(h|H|CC|cc|C|c)).*$/...compiling (w\/ $1) \033[32m$2\033[0m/g ) {
	    unless ( s/^(\/[^ ]+\/g?[+c][+c]) .* ([^ \]\[.\/\\]+\.(h|H|CC|cc|C|c|o)).*$/...compiling \033[32m$2\033[0m/g ) {
		s/([^ \]\[.\/\\]+\.(bt|ht|pl|pm|dict|h|H|CC|cc|C|c|o|d|html|data)((:)|(\s)+))/\033[32m$1\033[0m$4/g; # file names
	    }
	} else {
	    s/([^ \]\[.\/\\]+\.(bt|ht|pl|pm|dict|h|H|CC|cc|C|c|o|d|html|data)((:)|(\s)+))/\033[32m$1\033[0m$4/g; # file names
	}
	s/^(\(?)([^ ]+|.*PATH) /$1\033[33m$2\033[0m /g;   # command for line 
    } else {
    	if ( not m/Make\.defs.+Building with.+ROOT/ ) {
	    if ($cur_dir[0]) {
		$errors .= "\033[36m" . $cur_dir[0] . "\033[0m\n";
		$cur_dir[0] = "";   #  doesnt work in some cases
	    }
	    $error = 1;
	}
    }
    if ( m/ ((Entering|Leaving) directory) (\`.*\')/ ) {  # current directory
        $which_dir = $2; $dir_path = $3;
	s/$dir_path/\033[36m$dir_path\033[0m/g;
	if ($which_dir eq "Entering") {
	    unshift( @cur_dir, $dir_path);
	    s/$which_dir/\033[32;01m$which_dir\033[0m/g;   # current directory
	    s/^/\n/g;
	} else {
	    shift @cur_dir;
	    s/$which_dir/\033[31;01m$which_dir\033[0m/g;   # current directory
	    s/$dir_path/$dir_path\n/g;
	}
    }
    s/(\"\/text relocation\/d\")/\033[01;31m$1\033[0m/g;   # relocation at end
    s/(warning.*)/\033[33m$1\033[0m/g;   # warnings
#    s/^(.*[^W][eE]rror.*)$/\033[01;41;37m$1\033[0m/g;  # errors
    if ($TRACK_ERRORS and $error == 1) {
	$errors .= $_;
	$error = 0;
    }
    print STDERR;
}   
#close PROJ_ERR unless $filename;


if ( $TRACK_ERRORS and $errors ) {
	print STDERR "\033[01;44m\t          ----DONE----          \033[0m\n\007";

	print STDERR "\n\033[01;41m   MESA ERROR REPORT:          \033[0m\n\007\n";
	print STDERR $errors;
	print STDERR "\n";
}

close STATUS;
# format =  [ colorscheme m
# colorscheme = color characteristics separated by ;
# first character 0 = weight (ie 01 = bold 00 = normal 04 = underline 07 = reverse...)
#                 3 = color of font
#				  4 = color of background 
# colors: 
# 0 = grey
# 1 = red
# 2  = green
# 3 = yellow
# 4 = blue
# 5  = purplish
# 6 = light blue
# 7 = white
# not sure what 8 and 9 are .. i think they are your default window settings
