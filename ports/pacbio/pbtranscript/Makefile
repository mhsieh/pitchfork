include ../../../mk/pitchfork.mk

# Local variables
_NAME             = pbtranscript
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)

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
	@echo "# $(_REVISION)" >> $@ 
do-clean:
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
do-test:
	nosetests --verbose --with-xunit --xunit-file=pbtranscript_nose.xml $(_WRKSRC)/tests/unit/*.py
	run_cram_unit.py -x pbtranscript_cram.xml $(_WRKSRC)/tests/cram
