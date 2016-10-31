include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME   = cmake-3.4.1
_URL    = https://cmake.org/files/v3.4
_FILE   = $(_NAME).tar.gz
_WRKSRC = $(WORKDIR)/$(_NAME)
ifneq ($(OPSYS),Darwin)
LDFLAGS += -static-libgcc -static-libstdc++
export LDFLAGS
endif

# Local works
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-config: $(_WRKSRC)/Makefile
$(_WRKSRC)/Makefile: | do-extract
	(cd $(_WRKSRC) && ./bootstrap --prefix=$(STAGING)/$(_NAME)) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/bin/cmake
$(_WRKSRC)/bin/cmake: | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) install >& install.log || $(PFHOME)/bin/diewith install.log
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	rm -f config.log
do-flush:
	rm -rf $(_WRKSRC) || true
