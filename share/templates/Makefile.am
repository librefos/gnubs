# Specifies the order in which directories are entered.
SUBDIRS = lib src doc testsuite

# Standard documentation files to be included in the distribution.
dist_doc_DATA = README NEWS AUTHORS ChangeLog COPYING

# We use this to generate files that shouldn't be in the git repo
dist-hook: gen-ChangeLog dist-tarball-version

.PHONY: gen-ChangeLog dist-tarball-version

# Automatically generates the ChangeLog file from Git history.
gen-ChangeLog:
	$(AM_V_GEN)if test -d $(srcdir)/.git; then \
		LC_ALL=en_US.UTF-8 TZ=UTC0 \
		$(top_srcdir)/build-aux/gitlog-to-changelog \
		--srcdir=$(srcdir) > $(distdir)/ChangeLog \
		|| exit 1; \
	fi

# When a user unpacks the tarball, they don't have the .git directory.
# 'git-version-gen' looks for this file (.tarball-version) as a fallback
# to know what version the package is.
dist-tarball-version:
	echo '$(VERSION)' > $(distdir)/.tarball-version
