include ../../../mk/pitchfork.mk

# Local variables
_NAME   = Mash-1.0.2
_URL    = https://github.com/marbl/Mash/releases/download/v1.0.2
_WRKSRC = $(WORKDIR)/$(_NAME)
ifneq ($(ARCH),x86_64)
$(error $(ARCH) not supported)
endif
ifeq ($(OPSYS),Darwin)
_FILE   = mash-OSX64-v1.0.2.tar.gz
else ifeq ($(OPSYS),Linux)
_FILE   = mash-Linux64-v1.0.2.tar.gz
else
$(error $(OPSYS) not supported)
endif

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-extract
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/bin
	tar zxf $(_FILE) -C $(STAGING)/$(_NAME)/bin/
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
