include ../../../mk/pitchfork.mk

# Local variables
_NAME             = pbbamr
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/pbbamr
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD
R                := $(shell ../../../bin/checkR $(HAVE_R))
_tmpvar          := $(if $(shell which $(R)),exists,$(error "unable to run $(R)"))
ifneq ($(origin HAVE_R),undefined)
  R_LIBS         := $(PREFIX)/lib/R/library:$(shell $(HAVE_R) --slave --vanilla -e 'cat(.Library)')
else
  R_LIBS         := $(PREFIX)/lib/R/library:$(shell $(R)      --slave --vanilla -e 'cat(.Library)')
endif
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)

# Local works
do-extract:
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-fetch
	mkdir -p $(PREFIX)/lib/R/library
	R_LIBS=$(R_LIBS) ZLIB_ROOT=$(PREFIX) \
            $(R) CMD INSTALL $(_WRKSRC)
	cd $(PREFIX) && find lib/R/library/$(_NAME) > $@
	@echo "# $(_REVISION)" >> $@ 
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
