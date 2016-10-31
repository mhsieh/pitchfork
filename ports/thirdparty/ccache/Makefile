include ../../../mk/pitchfork.mk

# Local variables
_NAME   = ccache-3.2.4
_URL    = https://www.samba.org/ftp/ccache
_FILE	= $(_NAME).tar.gz
_WRKSRC = $(WORKDIR)/$(_NAME)
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'$$\$$\$$$$ORIGIN/../lib'
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
	(cd $(_WRKSRC) && ./configure --prefix=$(PREFIX) --with-bundled-zlib) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/ccache
$(_WRKSRC)/ccache: | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) prefix=$(STAGING)/$(_NAME) install >& install.log || $(PFHOME)/bin/diewith install.log
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache `basename $(CC)`
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache `basename $(CXX)`
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache `basename $(FC)`
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache cpp
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache CC
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
ifneq ($(origin HAVE_CCACHE),undefined)
_CCACHE = $(shell ../../../bin/checkCCACHE $(HAVE_CCACHE))
provided:
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/bin
	cd $(STAGING)/$(_NAME)/bin && ln -sfn $(_CCACHE) ccache
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache `basename $(CC)`
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache `basename $(CXX)`
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache `basename $(FC)`
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache cpp
	cd $(STAGING)/$(_NAME)/bin && ln -sfn ccache CC
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $(PREFIX)/var/pkg/$(_NAME)
endif
