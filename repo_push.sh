#!/usr/bin/env bash

# Push specified repos to Dropbox for backup.

if [ $# -lt 1 ] ; then

cat<<HELP
  Not enough arguments.
HELP
  exit 0
fi

START_DIR=$(pwd)

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. ${DIR}/coloring.sh
. ${DIR}/abs_path.sh

bail() {
  format_fail "$1"
}

DB_REPO="${HOME}/Dropbox/Code/repo"

# Make sure we have a connection to Dropbox
cd ~
if [ -s 'Dropbox' ] ; then
	cd Dropbox
	if ! [ -s 'Code' ] ; then
		mkdir Code
	fi
  cd Code
  if ! [ -s 'repo' ] ; then
    mkdir repo
  fi
else
	format_fail "Dropbox has not yet been set up."
	exit 0
fi

cd $START_DIR
for PROJ in $*
do
  PROJ=$(abs_path $PROJ)
  PROJ_NAME="$(basename $PROJ).git"
  if [ -d $PROJ ] ; then
    cd $PROJ
    if [ -s '.git' ] ; then
      msg="$PROJ_NAME is already a Git repo. We'll only setup upstreams."
      format_warning "$msg"
    else
      # Init repo
      (
        git init -q && git add . &&
        git commit -m "Initial commit for Dropbox setup" -q
      ) ||
      (bail $PROJ && continue)
    fi

    cd ${DB_REPO}
    if [ -s $PROJ_NAME ]; then
      msg="$PROJ_NAME already exists in Dropbox. We'll only update the config."
      format_warning "$msg"
    else
      mkdir $PROJ_NAME
      cd $PROJ_NAME
      (git init --bare -q) || (bail $PROJ && continue)
    fi

    # Setup upstreams
    cd $PROJ
    (
      (
        # Try to add a new remote dropbox_origin first
        git remote add dropbox_origin "$DB_REPO/$PROJ_NAME" 2>/dev/null ||
        # If that fails, dropbox_origin already exists -- we override it
        git remote set-url dropbox_origin "$DB_REPO/$PROJ_NAME"
      ) &&
      git push -q dropbox_origin master &&
      (
        # Try to add a new remote master first
        git remote add all "$DB_REPO/$PROJ_NAME" 2>/dev/null ||
        (
          # If that fails, master already exists -- we re-add the master
          git remote set-url all --delete --push "$DB_REPO/$PROJ_NAME" &&
          git remote set-url all --add --push "$DB_REPO/$PROJ_NAME"
        )
      )
    ) ||
    (bail $PROJ && continue)

    # Copy over config
    cp -f $PROJ/.git/config $DB_REPO/$PROJ_NAME/local_config

    format_ok $PROJ
  else
    bail $PROJ
  fi
done

cd $START_DIR
