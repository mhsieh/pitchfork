include ../../../mk/pitchfork.mk

# Local variables
_NAME            = modules-3.2.10
_URL             = https://prdownloads.sourceforge.net/modules
_FILE            = modules-3.2.10.tar.gz
_WRKSRC          = $(WORKDIR)/$(_NAME)

# Local works
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && \
        CPPFLAGS="-DUSE_INTERP_ERRORLINE" \
        ./configure --prefix=$(PREFIX) --with-tcl=$(PREFIX)/lib) >& \
        config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/modulecmd
$(_WRKSRC)/modulecmd: | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	$(MAKE) -C $(_WRKSRC) install >& install.log || $(PFHOME)/bin/diewith install.log
	find $(PREFIX)/Modules|awk -F '$(PREFIX)/' '{print $$2}'|sort -r > $@
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	$(MAKE) -C $(_WRKSRC) distclean
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
