#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. ${DIR}/coloring.sh

echo_status() {
  status=$?
  if [ $status -eq 0 ]; then
    format_ok
  else
    format_fail
    exit
  fi
}

format_prompt "Setting up code environment..."

# Setup Sublime Text 3 configs
# format_prompt "Cloning Sublime Text 3 config from git repo..."
# format_prompt "Killing all current Sublime Text instances..."
# killall Sublime\ Text
# echo_status
# rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3
# git clone --recursive git@github.com:lwxted/subl_config.git ~/Library/Application\ Support/Sublime\ Text\ 3
# echo_status

# Sync repos
format_prompt "Granting permissions to repo scripts and pushing to bin..."
chmod +x ${DIR}/repo
chmod +x ${DIR}/repo_pull.sh
chmod +x ${DIR}/repo_push.sh

(
  rm -f /usr/local/bin/repo &&
  rm -f /usr/local/bin/repo_pull.sh &&
  rm -f /usr/local/bin/repo_push.sh &&
  rm -f /usr/local/bin/coloring.sh
) || echo_status

(
  ln -s ${DIR}/repo /usr/local/bin/repo &&
  ln -s ${DIR}/repo_pull.sh /usr/local/bin/repo_pull.sh &&
  ln -s ${DIR}/repo_push.sh /usr/local/bin/repo_push.sh &&
  ln -s ${DIR}/coloring.sh /usr/local/bin/coloring.sh
) || echo_status

echo_status

DEST="${HOME}/Documents/synced_repo"
format_prompt "Syncing all code from Dropbox repos to $DEST..."
repo pull ${DEST}
echo_status
