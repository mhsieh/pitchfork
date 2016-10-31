include ../../../mk/pitchfork.mk

# Local variables
_NAME            = tcl8.6.4
_URL             = https://prdownloads.sourceforge.net/tcl
_FILE            = tcl-core8.6.4-src.tar.gz
_WRKSRC          = $(WORKDIR)/$(_NAME)

# Local works
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-config: $(_WRKSRC)/unix/config.log
$(_WRKSRC)/unix/config.log: | do-extract
	(cd $(_WRKSRC)/unix && \
        ./configure --prefix=$(STAGING)/$(_NAME)) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/unix/libtcl8.6.$(DYLIB)
$(_WRKSRC)/unix/libtcl8.6.$(DYLIB): | do-config
	$(MAKE) -C $(_WRKSRC)/unix >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC)/unix >& install.log || $(PFHOME)/bin/diewith install.log
	$(PERL) -pi -e 's[$(STAGING)/$(_NAME)][$(PREFIX)]g;s[$(_WRKSRC)/unix][$(PREFIX)/lib];s[$(_WRKSRC)][$(PREFIX)/lib]' \
            $(STAGING)/$(_NAME)/lib/pkgconfig/*.pc \
            $(STAGING)/$(_NAME)/lib/tclConfig.sh
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME)|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}'|sort -r > $@
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	$(MAKE) -C $(_WRKSRC) distclean
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
