#!/usr/bin/env bash

# gnubs.sh - Automated scaffolding for new GNU Build System projects.
# Copyright (C) 2026  Thiago C. Silva
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

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

export PKG_NAME='Template Project'
export PKG_VERSION='0.0.1-alpha'
export PKG_DESCRIPTION='A template project using GNU Build System.'
export AUTHOR_NAME='Thiago C Silva'
export AUTHOR_EMAIL='librefos@hotmail.com'

PKG_TARNAME=$(printf '%s' "$PKG_NAME" | \
  sed 's/.*/\L&/;s/[[:space:]]//g')
export PKG_TARNAME

export PKG_URL="https://git.sr.ht/~librefos/$PKG_TARNAME"
export TEXINFO_EMAIL="${AUTHOR_EMAIL//@/@@}"

COPYRIGHT_YEAR=$(date +%Y)
export COPYRIGHT_YEAR

# WARNING: Only add variables to this list that are strictly for
# templating.
VARIABLES_LIST=$(cat <<'EOF'
$PKG_NAME $PKG_VERSION $PKG_DESCRIPTION $AUTHOR_NAME $AUTHOR_EMAIL
$PKG_TARNAME $PKG_URL $TEXINFO_EMAIL $COPYRIGHT_YEAR
EOF
)
export VARIABLES_LIST

PROJECT_DIR="$SCRIPT_DIR/../$PKG_TARNAME"

source "$SCRIPT_DIR/../lib/utils.sh"

init_repo()
{
  if [[ -d "$PROJECT_DIR" ]]; then
    inform 'warning' 'Project already exists'
    exit 0
  fi

  inform 'warning' "Creating the project's Git repository"

  mkdir "$PROJECT_DIR" && cd "$_"
  mkdir src doc testsuite m4 build-aux

  git init .

  inform 'success' "Created repository '$PKG_TARNAME'"
}

apply_template()
{
  inform 'warning' 'Applying template files'
  local templates=(
    '.gitignore'
    'NEWS' 'README' 'AUTHORS' 'ChangeLog'
    'configure.ac' 'Makefile.am' 'bootstrap.conf'
    'src/Makefile.am' 'src/main.c'
    'doc/Makefile.am' 'doc/template.texi'
    'testsuite/Makefile.am' 'testsuite/dummy.c' 'testsuite/dummy.sh'
  )

  for template in "${templates[@]}"; do
    render_template "$template"
  done

  inform 'success' 'Applied template files'
}

add_submodules()
{
  local gnulib_url='https://git.savannah.gnu.org/git/gnulib.git'

  inform 'warning' "Adding 'gnulib' submodule"
  git submodule add --depth 1 "$gnulib_url" gnulib
  git submodule update --init

  inform 'warning' "Installing 'bootstrap' helper"
  cp gnulib/build-aux/bootstrap .
  chmod 755 "$PROJECT_DIR/bootstrap"

  inform 'success' 'Applied submodules'
}

build_project()
{
  local cores_count
  cores_count=$(nproc 2>/dev/null || printf 1)

  local load_limit
  load_limit=$((cores_count * 2))

  inform 'warning' 'Building the project'
  mkdir build && cd "$_"
  ../configure --enable-silent-rules
  make -j"$cores_count" -l"$load_limit"
  MAKE="make -j$cores_count -l$load_limit" make distcheck
}

release_workflow()
{
  local tarball="${PKG_TARNAME}-${PKG_VERSION}.tar.gz"

  inform 'warning' 'Commiting changes'
  git add .
  git commit -m 'Initial commit'

  inform 'warning' "Creating release tag v$PKG_VERSION"
  git tag -a "v$PKG_VERSION" -m 'Initial release'

  inform 'warning' "Running './bootstrap' helper"
  ./bootstrap --gnulib-srcdir=gnulib --skip-po # skip translation files

  build_project

  inform 'warning' 'Locating generated tarball'
  if [[ ! -f "$tarball" ]]; then
    inform 'error' 'Could not find your tarball.'
  fi

  if ! gpg --list-secret-keys >/dev/null 2>&1; then
    inform 'warning' 'GPG signing skipped (no private keys found)'
    return 0
  fi

  inform 'warning' 'Signing tarball with GPG'
  gpg --detach-sign --armor "$tarball"

  inform 'success' "Release v$PKG_VERSION completed"
}

main()
{
  inform 'copyright'

  init_repo
  apply_template
  add_submodules
  release_workflow

  inform 'success' 'Scaffolding complete'
  exit 0
}
main
