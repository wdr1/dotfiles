## $Id: .bash_profile,v 1.1.1.1 2010/08/14 04:57:50 wdr1 Exp $

##############################################################################
## Stolen from fink.  Use these to set/tweak/paths.  They need to be
## defined before other user functions, for reasons that shoul be obvious.
append_path() {
    if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\"" ; then
        eval "$1=\$$1:$2"
    fi
}
prepend_path() {
    if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\"" ; then
        eval "$1=$2:\$$1"
    fi
}                  


##############################################################################
## External files:  loaded in the following order:
## env, aliases, functions, projects, os, domain, host 

## Figure out our host & os
MY_OS=`uname -s`
MY_HOST_LIST=`hostname | sort | tail -1 | perl -ne 'chomp; print join(" ", reverse( split /\./, $_ ))'`          

## Check for each file & load it if it's there
if [ -f ~/.bash/env ]; then
	. ~/.bash/env
fi

if [ -f ~/.bash/aliases ]; then
	. ~/.bash/aliases
fi

if [ -f ~/.bash/functions ]; then
	. ~/.bash/functions
fi

if [ -f ~/.bash/completion ]; then
	. ~/.bash/completion
fi

if [ -f ~/.bash/bash_completion ]; then
	. ~/.bash/bash_completion
fi

for i in $HOME/.bash/projects/*.sh
do
  . $i
done

if [ -f "${HOME}/.bash/os/${MY_OS}" ]; then
    . "${HOME}/.bash/os/${MY_OS}"
fi

## Check for 'com', 'wdr1.com', 'www.wdr1.com', general to more specific
HOST_FILE=""
for i in $MY_HOST_LIST
do
  HOST_FILE="${i}.${HOST_FILE}"
  if [ -f "${HOME}/.bash/hosts/${HOST_FILE}" ]; then
      . "${HOME}/.bash/hosts/${HOST_FILE}"
  fi
done

## If we're interactive and have a default directory, jump to it
if [[ -n `echo $- | grep 'i'` && -n "$__BASH_LOGIN_DIR" ]]; then
    cd $__BASH_LOGIN_DIR;
fi

 