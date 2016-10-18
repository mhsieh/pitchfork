include ../../../mk/pitchfork.mk

# Local variables
_NAME             = FALCON_unzip
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/FALCON_unzip
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD

# Local works
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
DEVOPT =
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
DEVOPT = -e
endif
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-fetch
	$(PIP) install --no-deps $(DEVOPT) $(_WRKSRC)/
	@echo pip uninstall $(_NAME) > $@
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-clean:
