include ../../../mk/pitchfork.mk

# Local variables
_NAME   = bamtools-2.4.1
_URL    = https://github.com/pezmaster31/bamtools/archive
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = v2.4.1.tar.gz

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-build: $(_WRKSRC)/bin/bamtools
$(_WRKSRC)/bin/bamtools: | do-extract
	mkdir -p $(_WRKSRC)/build
	(cd $(_WRKSRC)/build && \
        $(CMAKE) \
            -DCMAKE_C_FLAGS_RELEASE="$(CFLAGS)" \
            -DCMAKE_CXX_FLAGS_RELEASE="$(CXXFLAGS)" \
            -DCMAKE_SHARED_LINKER_FLAGS="$(LDFLAGS)" \
            -DCMAKE_EXE_LINKER_FLAGS="$(LDFLAGS)" \
        .. )
	$(MAKE) -C $(_WRKSRC)/build >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME) && mkdir -p $(STAGING)/$(_NAME)
	rsync -ax $(_WRKSRC)/bin/ $(STAGING)/$(_NAME)/bin/
	rsync -ax $(_WRKSRC)/lib/ $(STAGING)/$(_NAME)/lib/
	rsync -ax $(_WRKSRC)/include/ $(STAGING)/$(_NAME)/include/
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
