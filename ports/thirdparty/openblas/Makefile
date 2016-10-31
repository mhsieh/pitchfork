include ../../../mk/pitchfork.mk

# FC check
include ../../../mk/chkfc.mk

# Local variables
_NAME   = OpenBLAS-0.2.18
_URL    = https://github.com/xianyi/OpenBLAS/archive
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = v0.2.18.tar.gz

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-build: $(_WRKSRC)/libopenblas.$(DYLIB)
$(_WRKSRC)/libopenblas.$(DYLIB): | do-extract
	$(MAKE) -C $(_WRKSRC) MAKE_NB_JOBS=2 2>&1 | tee build.log | $(PFHOME)/bin/activity || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -j1 -C $(_WRKSRC) PREFIX=$(STAGING)/$(_NAME) install >& install.log || $(PFHOME)/bin/diewith install.log
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-flush:
	rm -rf $(_WRKSRC) || true
do-distclean: do-flush

ifneq ($(origin HAVE_OPENBLAS),undefined)
_OPENBLAS=$(HAVE_OPENBLAS)
provided:
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/lib
	rsync -avx $(_OPENBLAS)/lib/libopenblas*      $(STAGING)/$(_NAME)/lib/
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $(PREFIX)/var/pkg/$(_NAME)
endif
