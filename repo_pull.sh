#!/usr/bin/env bash

# Pull all backed up repos in Dropbox to a user-specified location.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. ${DIR}/coloring.sh

START_DIR=$(pwd)

bail() {
  format_fail "$1"
}

DB_REPO="${HOME}/Dropbox/Code/repo"

# Make sure we have a connection to Dropbox
cd ~
if ! [ -s $DB_REPO ] ; then
  format_fail "Dropbox has not yet been set up."
  exit 0
fi

CODE_DIR=$1
if ! [ -d $CODE_DIR ] ; then
  format_fail "$CODE_DIR not found."
  exit 0
fi

# Enumerate through all repos
cd $DB_REPO
for d in *\.git/ ; do
  if ! [ -d $DB_REPO/$d ] ; then
    continue
  fi
  if [ -d $CODE_DIR/$d ] ; then
    bail "$d is already pulled down." && continue
  fi
  d_x_git=${d%%\.git\/}
  mkdir $CODE_DIR/$d_x_git
  cd $CODE_DIR/$d_x_git
  (
    git init -q &&
    cp $DB_REPO/$d/local_config $CODE_DIR/$d_x_git/.git/config &&
    git pull dropbox_origin master
  ) || (bail $d && continue)
  format_ok $d
done

cd $START_DIR
