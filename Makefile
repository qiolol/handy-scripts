# Why even install this? Well, if you link a script to `/usr/local/bin`, where
# it's potentially run by root, the script should be owned by root too
# (otherwise, non-root users can write to it, injecting instructions that are
# later run as root, which could be pretty bad). But, if the script's repo is
# owned by root, you've got Git/editor headaches since you need root permissions
# to do anything in it. The proper, secure way is to copy it to `/usr/local/bin`
# and make the copy owned by root. However, some scripts have "library" scripts!
# So we need to copy those too, albeit not on `PATH` or directly executable.
# "Copying lots of stuff with proper ownership and permissions" is known as
# "installing", so we might as well have an installer! This is that installer.

# Set a prefix (unless one's already set):
PREFIX     ?= /usr/local
# Directories
BINDIR      = $(PREFIX)/bin
LIBDIR      = $(PREFIX)/lib/handy-scripts
SRCDIR     = src
# Comporting to the sacred FHS (and assuming `PREFIX` is `/usr/local`), this
# will install the scripts thusly:  
#     - `/usr/local/bin/script`: script on `PATH`
#     - `/usr/local/lib/handy-scripts/lib_script`: lib script (NOT run directly)

.PHONY: install uninstall

BIN_SCRIPTS = \
	echo_block \
	echo_rainbow \
	echo_rainbow_edge_fade \
	echo_randbow \
	abdul \
	alnum \
	bge \
	flatten \
	num_convert \
	printn \
	printnxn \
	randnum \
	randstr \
	roll \
	run_exe_until_fail \
	strcmp \
	strlen \
	unique_chars

# Copies all files with correct permissions to their installed destinations
install:
	# Lib script (0644 = readable, NOT executable)
	install -d "$(DESTDIR)$(LIBDIR)"
	install -m 0644 "$(SRCDIR)/color_defs.sh" "$(DESTDIR)$(LIBDIR)/"

	# Scripts (0755 = executable, on `PATH`)
	# 
	# They're installed WITHOUT the `.sh` and with instances of "@LIBDIR@"
	# replaced with what `$(LIBDIR)` resolves to at installtime.
	install -d "$(DESTDIR)$(BINDIR)"
	
	@for SCRIPT in $(BIN_SCRIPTS); do \
		sed 's|@LIBDIR@|$(LIBDIR)|g' "$(SRCDIR)/$$SCRIPT.sh" > "$$SCRIPT.tmp"; \
		install -m 0755 "$$SCRIPT.tmp" "$(DESTDIR)$(BINDIR)/$$SCRIPT"; \
		rm -f "$$SCRIPT.tmp"; \
	done

# Symmetrically removes all files copied during installation
uninstall:
	rm -rf "$(DESTDIR)$(LIBDIR)"
	
	@for SCRIPT in $(BIN_SCRIPTS); do \
		rm -f "$(DESTDIR)$(BINDIR)/$$SCRIPT"; \
	done
	
# To test this:
# ```
# make DESTDIR=/tmp/stage install
# find /tmp/stage                                 # Verify the tree
# cat /tmp/stage/usr/local/bin/handy-scripts      # Verify baked-in paths
# ```
