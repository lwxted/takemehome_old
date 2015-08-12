#!/usr/bin/env bash

abs_path() {
  cd "$1" 2>/dev/null || return $?
  echo "`pwd -P`"
}