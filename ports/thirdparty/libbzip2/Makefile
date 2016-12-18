include ../../../mk/pitchfork.mk

# Local variables
_VERSION = 1.0.6
_NAME    = libbzip2-$(_VERSION)
_URL     = http://www.bzip.org/$(_VERSION)
_WRKSRC  = $(WORKDIR)/bzip2-$(_VERSION)
_FILE    = bzip2-$(_VERSION).tar.gz

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-build: $(_WRKSRC)/libbz2.so
$(_WRKSRC)/libbz2.so: | do-extract
	$(MAKE) -C $(_WRKSRC) -f Makefile-libbz2_so >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/lib $(STAGING)/$(_NAME)/include
	cp -a $(_WRKSRC)/bzlib.h $(STAGING)/$(_NAME)/include
	cp -a $(_WRKSRC)/libbz2.so* $(STAGING)/$(_NAME)/lib
	ln -sfn libbz2.so.1.0 $(STAGING)/$(_NAME)/lib/libbz2.so.1
	ln -sfn libbz2.so.1   $(STAGING)/$(_NAME)/lib/libbz2.so
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
