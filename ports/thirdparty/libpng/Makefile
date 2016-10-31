include ../../../mk/pitchfork.mk

# Local variables
_NAME   = libpng-1.6.21
_URL    = https://prdownloads.sourceforge.net/libpng
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = $(_NAME).tar.gz
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'$$\$$\$$$$ORIGIN/../lib'
CFLAGS += -static-libgcc
endif
_CFLAGS = $(CFLAGS)

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && CFLAGS="$(_CFLAGS)" ./configure --prefix=$(PREFIX)) >& config.log || $(PFHOME)/bin/diewith config.log
	cp $(ZLIB_ROOT)/include/zlib.h $(ZLIB_ROOT)/include/zconf.h $(_WRKSRC)/
do-build: $(_WRKSRC)/.libs/libpng16.$(DYLIB)
$(_WRKSRC)/.libs/libpng16.$(DYLIB): | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) prefix=$(STAGING)/$(_NAME) install >& install.log || $(PFHOME)/bin/diewith install.log
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
