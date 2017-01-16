include ../../../mk/pitchfork.mk

# Local variables
_NAME   = libpng-1.6.21
_URL    = https://prdownloads.sourceforge.net/libpng
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = $(_NAME).tar.gz
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'$$\$$\$$$$ORIGIN/../lib'
endif
_CFLAGS = $(CFLAGS)

# Local works
ifeq ($(origin HAVE_LIBPNG),undefined)
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
else
ifeq ($(wildcard $(HAVE_LIBPNG)/lib/libpng*),)
    $(error $(HAVE_LIBPNG)/lib/libpng* not found)
endif
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/bin \
                 $(STAGING)/$(_NAME)/share/man/man3 \
                 $(STAGING)/$(_NAME)/share/man/man5 \
                 $(STAGING)/$(_NAME)/include \
                 $(STAGING)/$(_NAME)/lib/pkgconfig
	cp -aL $(HAVE_LIBPNG)/bin/libpng* $(STAGING)/$(_NAME)/bin/
	cp -aL $(HAVE_LIBPNG)/bin/png* $(STAGING)/$(_NAME)/bin/
	cp -aL $(HAVE_LIBPNG)/include/libpng* $(STAGING)/$(_NAME)/include/
	cp -aL $(HAVE_LIBPNG)/include/png* $(STAGING)/$(_NAME)/include/
	cp -aL $(HAVE_LIBPNG)/lib/libpng* $(STAGING)/$(_NAME)/lib/
	cp -aL $(HAVE_LIBPNG)/lib/pkgconfig/libpng* $(STAGING)/$(_NAME)/lib/pkgconfig
	cp -aL $(HAVE_LIBPNG)/share/man/man3/libpng* $(STAGING)/$(_NAME)/share/man/man3/
	cp -aL $(HAVE_LIBPNG)/share/man/man5/png* $(STAGING)/$(_NAME)/share/man/man5/
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
endif
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	$(MAKE) -C $(_WRKSRC) distclean
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
