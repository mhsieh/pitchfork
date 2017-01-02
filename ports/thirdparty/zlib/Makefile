include ../../../mk/pitchfork.mk

# Local variables
_NAME   = zlib-1.2.8
_URL    = http://zlib.net
_URL    = https://sourceforge.net/projects/libpng/files/zlib/1.2.8
_WRKSRC = $(WORKDIR)/$(_NAME)
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
do-config: $(_WRKSRC)/configure.log
$(_WRKSRC)/configure.log: | do-extract
	(cd $(_WRKSRC) && ./configure --prefix=$(PREFIX)) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/libz.a
$(_WRKSRC)/libz.a: | do-config
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
	rm -f $(_WRKSRC)/configure.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
ifneq ($(origin HAVE_ZLIB),undefined)
_ZLIB = $(shell ../../../bin/checkZLIB $(HAVE_ZLIB))
_NAME = zlib
provided:
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/include
	mkdir -p $(STAGING)/$(_NAME)/lib
	cp -a $(_ZLIB)/include/zlib.h $(_ZLIB)/include/zconf.h $(STAGING)/$(_NAME)/include/
	cp -a $(_ZLIB)/lib/libz.*                              $(STAGING)/$(_NAME)/lib/
	mkdir -p $(STAGING)/$(_NAME)/lib/pkgconfig
	find $(_ZLIB)/lib -name 'zlib.pc' -exec cp -a {} $(STAGING)/$(_NAME)/lib/pkgconfig/ \;
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $(PREFIX)/var/pkg/$(_NAME)
endif
