include ../../../mk/pitchfork.mk

# Local variables
_NAME             = daligner
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/DALIGNER
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)

# Local works
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
INSTALL_RULE:=install
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
INSTALL_RULE:=symlink
endif
do-config:
	mkdir -p $(_WRKSRC)/build
	echo PREFIX:=$(PREFIX) > $(_WRKSRC)/build/Makefile
	echo CC:=$(CC) >> $(_WRKSRC)/build/Makefile
	echo LIBDIRS:=$(PREFIX)/lib >> $(_WRKSRC)/build/Makefile
	echo include ../GNUmakefile >> $(_WRKSRC)/build/Makefile
do-build:
	$(MAKE) -C $(_WRKSRC)/build
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	$(MAKE) -C $(_WRKSRC)/build ${INSTALL_RULE}
	touch $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	$(MAKE) -C $(_WRKSRC)/build clean
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
