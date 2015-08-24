#!/usr/bin/env bash

# Not enough parameters, show help.
if [ $# -lt 2 ] ; then

cat<<HELP
  Not enough arguments
HELP
    exit 0
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. ${DIR}/coloring.sh
. ${DIR}/abs_path.sh

if [ "$1" = "add" ] ; then
  REMOTE_NAME="$1"
  REMOTE_URL="$2"

  if [ ! -s "${DIR}/.git" ]
    format_fail "Must be invoked in root git repo directory."
    exit 1
  fi

  (git remote add $REMOTE_NAME $REMOTE_URL) || (format_fail "")
  (git remote set-url --add --push all $REMOTE_URL) || (format_fail "")
  repo push .
  format_ok ""
fi
