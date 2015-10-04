## CVS Settings
CVSROOT="/home/cvs"
export CVS_RSH CVSROOT
alias tae="tail -f /home/sites/wdr1.com/logs/error"

## Bookshelf stuff
alias cdb="cd ~/Bookshelf"
alias cdpm="cd ~/Bookshelf/perl/Modules"
alias cdps="cd ~/Bookshelf/perl/Scripts"
alias cdc="cd ~/Sandboxes/wdr1/Casino/templates"