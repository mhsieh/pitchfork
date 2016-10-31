include ../../../mk/pitchfork.mk

# Local variables
_NAME            = Python-2.7.10
_URL             = https://www.python.org/ftp/python/2.7.10
_FILE            = Python-2.7.10.tgz
_WRKSRC          = $(WORKDIR)/$(_NAME)
_CONFIGURE_ARGS  = --prefix=$(PREFIX)
_CONFIGURE_ARGS += --enable-unicode=ucs4
_CONFIGURE_ARGS += --enable-shared
_CFLAGS          = $(CFLAGS)
_CFLAGS         += -I$(PREFIX)/include/ncurses
_LDFLAGS         = -L$(PREFIX)/lib

# Local works
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
	$(SED) -i -e "s|@@PREFIX@@|$(PREFIX)|g" $(_WRKSRC)/Lib/cgi.py $(_WRKSRC)/Lib/ctypes/macholib/dyld.py
	$(SED)    -e "s|@@PREFIX@@|$(PREFIX)|g" patch-01 | (cd $(_WRKSRC) && patch -p0)
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && \
          CFLAGS="$(_CFLAGS)" LDFLAGS="$(_LDFLAGS)" \
              ./configure $(_CONFIGURE_ARGS)) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/python.exe
$(_WRKSRC)/python.exe: | do-config
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
