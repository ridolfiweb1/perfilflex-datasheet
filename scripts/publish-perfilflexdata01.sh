#!/usr/bin/env bash
set -euo pipefail

src="/root/projects/baruckdata/perfilflexdata01.html"
dest="/srv/base-c.ridolfiweb.com.br/perfilflexdata01.html"
log_file="/root/projects/baruckdata/.autopublish-perfilflexdata01.log"

install -D -m 0644 "$src" "$dest"
printf '%s Published %s -> %s\n' "$(date -Is)" "$src" "$dest" >> "$log_file"
