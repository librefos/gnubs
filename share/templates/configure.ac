AC_PREREQ([2.72])

# The version argument uses 'm4_esyscmd' to run a shell command at
# autoconf-time. It runs 'git-version-gen' to determine the version from
# git tags.
AC_INIT([$PKG_NAME],
        m4_esyscmd([build-aux/git-version-gen \
                    .tarball-version | tr -d '\n']),
        [$AUTHOR_EMAIL],
        [$PKG_TARNAME],
        [$PKG_URL])

AC_CONFIG_SRCDIR([src/main.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIRS([m4])

AC_USE_SYSTEM_EXTENSIONS

AM_INIT_AUTOMAKE([gnu 1.14 -Wall -Werror subdir-objects])
AM_SILENT_RULES([yes])

AC_PROG_CC

# These macros are defined by Gnulib. They perform checks for the
# modules listed in bootstrap.conf.
gl_EARLY
gl_INIT

# Looks for the archiver (ar). Required when building libraries.
AM_PROG_AR

# Initializes Libtool for shared library support.
LT_INIT

# Checks for 'help2man'. If missing, it uses the 'missing' script to
# warn the user, rather than failing immediately.
AM_MISSING_PROG([HELP2MAN], [help2man])

# AC_CONFIG_FILES: Lists the Makefiles to be generated from Makefile.in.
AC_CONFIG_FILES([Makefile lib/Makefile src/Makefile doc/Makefile
                 testsuite/Makefile])
AC_OUTPUT
