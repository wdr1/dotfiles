#!/usr/local/bin/bash

## $Id: directory_bookmark.sh,v 1.1.1.1 2010/08/14 04:57:50 wdr1 Exp $

## Use Cases:
## 
## bm .   
## 
## bm <label>
## 
## bm <label> <directory>
## 
## jump <label>
## 

_BOOKMARK_DIR=$BOOKMARK_DIR
if [ -z "$_BOOKMARK_DIR" ]; then
    _BOOKMARK_DIR="$HOME/.bm"
fi
if [ ! -d "$_BOOKMARK_DIR" ]; then
    mkdir $_BOOKMARK_DIR
fi


function bm {
    local label=$1
    local dir=$2
    
    local pwd=`pwd`

    ## If no label or '.', default to what directory we're in
    if [ -z "$label" -o "$label" = "." ]; then
        label=`basename $pwd`
    fi

    ## If no label or '.', default to what path we're in
    if [ -z "$dir" -o "$dir" = "." ]; then
        dir=$pwd
    fi

    local file="$_BOOKMARK_DIR/$label"
    echo $dir > $file
}


function bm-list {
    for i in $_BOOKMARK_DIR/*
    do
      local f=`basename $i`
      echo $f "=>" `cat $i`
    done
}


function jump {
    local label=$1

    if [ -z "$label" ]; then
        bm-list 
        return;
    fi
    
    local file="$_BOOKMARK_DIR/$label"
    if [ -f "$file" ]; then
        cd `cat $file`
    else
        echo "bm: Nothing known about '$label'..."
    fi
}


_jump()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=`ls $_BOOKMARK_DIR | perl -pe 's/\n/ /'`

#    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
#    fi
}
complete -F _jump jump
