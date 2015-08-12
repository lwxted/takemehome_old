#!/usr/bin/env bash
RED_BG='\e[97;101m'
GREEN_BG='\e[30;102m'
YELLOW_BG='\e[97;43m'
YELLOW='\e[0;33m'
NC='\e[0m' # No Color

format_ok() {
  printf "${GREEN_BG} OK ${NC} %s\n" "$1"
}

format_warning() {
  printf "${YELLOW_BG} WARNING ${NC} %s\n" "$1"
}

format_fail() {
  printf "${RED_BG} FAIL ${NC} %s\n" "$1"
}

format_prompt() {
  printf "${YELLOW}%s${NC}\n" "$1"
}