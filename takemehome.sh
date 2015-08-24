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
format_prompt "Cloning Sublime Text 3 config from git repo..."
SUBLIME_REPO="~/Library/Application\ Support/Sublime\ Text\ 3"
if [ -s $SUBLIME_REPO ] ; then
  cd $SUBLIME_REPO
  if [ -s '.git' ] ; then
    if [ ! -z "$(git status --porcelain)" ] ; then
      echo "Your Sublime Text config repo has uncommitted changes."
      read -p "Are you sure to discard your current repo? [y/n] " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]
      then
        exit 1
      fi
    fi
  fi
fi

format_prompt "Killing all current Sublime Text instances..."
killall Sublime\ Text
rm -rf $SUBLIME_REPO
git clone --recursive git@github.com:lwxted/subl_config.git ~/Library/Application\ Support/Sublime\ Text\ 3
echo_status

# Sync repos
format_prompt "Granting permissions to repo scripts and pushing to bin..."

sudo chmod +x ${DIR}/repo
sudo chmod +x ${DIR}/repo_pull.sh
sudo chmod +x ${DIR}/repo_push.sh
sudo chmod +x ${DIR}/repo_remote_add.sh
sudo chmod +x ${DIR}/coloring.sh
sudo chmod +x ${DIR}/abs_path.sh

(
  sudo rm -f /usr/local/bin/repo &&
  sudo rm -f /usr/local/bin/repo_pull.sh &&
  sudo rm -f /usr/local/bin/repo_push.sh &&
  sudo rm -f /usr/local/bin/repo_remote_add.sh &&
  sudo rm -f /usr/local/bin/coloring.sh &&
  sudo rm -f /usr/local/bin/abs_path.sh
) || echo_status

(
  sudo ln -s ${DIR}/repo /usr/local/bin/repo &&
  sudo ln -s ${DIR}/repo_pull.sh /usr/local/bin/repo_pull.sh &&
  sudo ln -s ${DIR}/repo_push.sh /usr/local/bin/repo_push.sh &&
  sudo ln -s ${DIR}/repo_remote_add.sh /usr/local/bin/repo_remote_add.sh &&
  sudo ln -s ${DIR}/coloring.sh /usr/local/bin/coloring.sh &&
  sudo ln -s ${DIR}/abs_path.sh /usr/local/bin/abs_path.sh
) || echo_status
echo_status

DEST="${HOME}/Documents/repo"
format_prompt "Syncing all code from Dropbox repos to $DEST..."
repo pull ${DEST}
chown -R $USER:staff $DEST
echo_status
