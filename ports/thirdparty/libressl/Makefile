include ../../../mk/pitchfork.mk

# Local variables
_NAME   = libressl-2.2.5
_URL    = http://ftp.openbsd.org/pub/OpenBSD/LibreSSL
_WRKSRC = $(WORKDIR)/$(_NAME)
_CFLAGS = $(CFLAGS)
_FILE   = $(_NAME).tar.gz
ifneq ($(OPSYS),Darwin)
LDFLAGS += -static-libgcc
export LDFLAGS
endif

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && CFLAGS="$(_CFLAGS)" ./configure --prefix=$(STAGING)/$(_NAME)) >& \
        config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/ssl/.libs/libssl.$(DYLIB)
$(_WRKSRC)/ssl/.libs/libssl.$(DYLIB): | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) install >& install.log || $(PFHOME)/bin/diewith install.log
	$(PERL) -pi -e 's[$(STAGING)/$(_NAME)][$(PREFIX)]g' $(STAGING)/$(_NAME)/lib/pkgconfig/*.pc
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	$(MAKE) -C $(_WRKSRC) distclean
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
