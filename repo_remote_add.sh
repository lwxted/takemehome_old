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

REMOTE_NAME="$1"
REMOTE_URL="$2"

(git remote add $REMOTE_NAME $REMOTE_URL) || (format_fail "")
(git remote set-url --add --push all $REMOTE_URL) || (format_fail "")
format_ok ""
