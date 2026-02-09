#!/usr/bin/env bash

# utils.sh - Collection of utility functions.
# Copyright (C) $COPYRIGHT_YEAR  $AUTHOR_NAME
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -euo pipefail

# usage: inform <type> <message>
# This function prints colored messages to standard output based on the
# message type. It handles ANSI escape codes for terminal colors and
# conditional script terminantion on errors.
inform() {
  local type="$1"
  local message="${2:-}" # If $2 is unset or null, then message=''

  local color
  case "$type" in
    warning) color=3 ;; # Yellow
    success) color=2 ;; # Green
      error) color=1 ;; # Red
          *) color=7 ;; # White
  esac

  mapfile -t COPYRIGHT <<EOF
Copyright (C) 2026 $AUTHOR_NAME
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Report bugs to: $AUTHOR_EMAIL
EOF

  if [[ "$type" = 'copyright' ]]; then
    # Iterate to apply the color argument to every line.
    for line in "${COPYRIGHT[@]}"; do
      # '\033[1;3%sm' bold color, and '\033[0m' reset.
      printf "\033[1;3%sm===> %s\033[0m\n" "$color" "$line"
    done
  else
    printf "\033[1;3%sm===>\033[0m %s\n" "$color" "$message"
  fi

  if [[ "$type" == 'error' ]]; then
    rm -rf "$PROJECT_DIR"
    exit 1
  fi
}
trap 'inform "error" "Process interrupted or killed."' SIGINT SIGTERM

# usage: render_template <file>
# This function processes a template file by substituting environment
# variables and saving the result to the project directory.
render_template()
{
  local file="$1"
  local template_file="$SCRIPT_DIR/../share/templates/$file"
  local project_file="$PROJECT_DIR/$file"

  local project_path
  project_path=$(dirname "$project_file")

  if [[ ! -f "$template_file" ]]; then
    inform 'error' "Template not found: $file"
  fi

  envsubst "$VARIABLES_LIST" < "$template_file" > "$project_file"

  # '##*.' Match and remove the longest prefix ending in a dot. This
  # effectively extracts the file extension.
  case  ${file##*.} in
      sh) chmod 755 "$project_file" ;;
    texi) mv "$project_file" "$project_path/${PKG_TARNAME}.texi" ;;
  esac

  inform 'success' "Created file '${project_file##*/}'"
}
