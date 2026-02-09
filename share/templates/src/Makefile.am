# Defines executables to be installed in $(bindir).
bin_PROGRAMS = $PKG_TARNAME
${PKG_TARNAME}_SOURCES = main.c

# Adds the Gnulib directory to the include path so we can find headers.
AM_CPPFLAGS = -I$(top_srcdir)/lib -I$(top_builddir)/lib

# Links the static convenience library containing the compiled Gnulib
# modules.
${PKG_TARNAME}_LDADD = $(top_builddir)/lib/libgnu.la
