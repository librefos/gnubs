# 'info_TEXINFOS' defines the source file for the Info documentation.
info_TEXINFOS = $PKG_TARNAME.texi

# 'dist_man_MANS' defines man pages that should be distributed in the
# tarball.
dist_man_MANS = $PKG_TARNAME.1

# This rule generates the man page dynamically using the 'help2man'
# utility. It runs the executable with '--help' and formats the output
# as a man page.
$PKG_TARNAME.1: $(top_builddir)/src/$PKG_TARNAME$(EXEEXT)
	$(AM_V_GEN)if test "$(cross_compiling)" != "yes" && \
		test -x $(top_builddir)/src/$PKG_TARNAME$(EXEEXT); then \
		$(HELP2MAN) --no-info --name="$PKG_DESCRIPTION" \
			--output=$@ $(top_builddir)/src/$PKG_TARNAME$(EXEEXT); \
	else \
		echo 'WARNING: Cannot run binary to generate man page' >&2; \
	fi

MAINTAINERCLEANFILES = $PKG_TARNAME.1
