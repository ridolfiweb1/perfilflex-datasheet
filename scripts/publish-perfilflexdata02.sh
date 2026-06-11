#!/usr/bin/env bash
set -euo pipefail

src="/root/projects/baruckdata/perfilflexdata02.html"
dest="/srv/base-c.ridolfiweb.com.br/perfilflexdata02.html"
log_file="/root/projects/baruckdata/.autopublish-perfilflexdata02.log"

install -D -m 0644 "$src" "$dest"
printf '%s Published %s -> %s\n' "$(date -Is)" "$src" "$dest" >> "$log_file"
