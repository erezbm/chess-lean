#!/usr/bin/env bash
set -e

lake build &>/dev/null
script -c "lake env chess-lean" --quiet --flush log.txt
