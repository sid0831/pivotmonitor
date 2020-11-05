#!/usr/bin/env bash

VERSINFO=$(cat $PWD/pivotmonitor.sh | grep -iE 'Monitor pivot script v' | sed -E 's/([ \t].*)(echo -e "Monitor pivot script v)(.*)(\\nW.*)/\3/g')
VERSARRAY=( $(echo $VERSINFO | cut -d "-" -f 1 | cut -d "." -f 1) $(echo $VERSINFO | cut -d "-" -f 1 | cut -d "." -f 2) $(echo $VERSINFO | cut -d "-" -f 1 | cut -d "." -f 3) $(echo $VERSINFO | cut -d "-" -f 2 | cut -d "." -f 1) $(echo $VERSINFO | cut -d "-" -f 2 | cut -d "." f 2)  )
commitcode () {
  local QMARK=1
  git commit -m "$2" $1; QMARK=$?
  return $QMARK
}

verschange () {
  local QMARK=1
  local COMMITCOUNT=$(git rev-list --count master)
  VERSARRAY[4]=$(( $COMMITCOUNT + 1 ))
  echo -e "Marking new version...\nOLD: v$VERSINFO\nNEW: v${VERSARRAY[0]}.${VERSARRAY[1]}.${VERSARRAY[2]}-${VERSARRAY[3]}.${VERSARRAY[4]}"
  sed -E -i "s/(Monitor pivot script v)(.*)(\\nW.*)/Monitor pivot script v${VERSARRAY[0]}.${VERSARRAY[1]}.${VERSARRAY[2]}\-${VERSARRAY[3]}.${VERSARRAY[4]}\\nWritten by Sidney Jeong, GNU GPL 3.0/g" $PWD/pivotmonitor.sh; QMARK=$?
  return $QMARK
}

while [ $# -gt 0 ]; do
  case "$1" in
    -m|--message)
      verschange && commitcode "-a" "$2" && git push && exit 0
      shift; shift
      ;;
    *)
      echo "only -m flag allowed for now"
      exit 1
      ;;
  esac
done
