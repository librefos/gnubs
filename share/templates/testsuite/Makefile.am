# Defines which file extensions should be treated as tests.
TEST_EXTENSIONS = .sh

# Defines the interpreter used to run .sh files.
SH_LOG_COMPILER = $(SHELL)

# The list of test scripts or executables to run when 'make check' is
# called.
TESTS = dummy.sh dummy

check_PROGRAMS = dummy
dummy_SOURCES = dummy.c
dummy_LDADD = $(top_builddir)/lib/libgnu.la

# -I$(top_srcdir)/lib: Include headers from the source lib directory.
# -I$(top_builddir)/lib: Include generated headers.
AM_CPPFLAGS = -I$(top_srcdir)/lib -I$(top_builddir)/lib

# Files to include in the tarball that aren't picked up automatically.
EXTRA_DIST = dummy.sh
