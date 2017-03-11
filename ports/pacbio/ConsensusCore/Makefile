include ../../../mk/pitchfork.mk

# Local variables
_NAME             = ConsensusCore
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
do-config: $(_WRKSRC)/make/Config.mk
$(_WRKSRC)/make/Config.mk: | do-fetch
	cd $(_WRKSRC) && ./configure \
            --swig=$(PREFIX)/bin/swig \
            --swig-lib=$(PREFIX)/share/swig/3.0.8 \
            --boost=$(BOOST_ROOT)/include \
            --python-include=$(shell python -c 'import sysconfig; print sysconfig.get_path("include")') \
            --numpy-include=$(shell python -c 'import numpy; print numpy.get_include()') \
do-build: $(_WRKSRC)/build/C++/libConsensusCore.a $(_WRKSRC)/build/Python/_ConsensusCore.so
$(_WRKSRC)/build/C++/libConsensusCore.a: | do-config
	$(MAKE) -C $(_WRKSRC) GXX="$(CXX) $(CXXFLAGS) $(LDFLAGS)" lib
$(_WRKSRC)/build/Python/_ConsensusCore.so: | do-config
	$(MAKE) -C $(_WRKSRC) GXX="$(CXX) $(CXXFLAGS) $(LDFLAGS)" python
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	$(PIP_INSTALL) --install-option="--swig=$(PREFIX)/bin/swig" --install-option="--swig-lib=$(PREFIX)/share/swig/3.0.8" --install-option="--boost=$(BOOST_ROOT)/include" $(DEVOPT) $(_WRKSRC)/
	@echo pip uninstall $(_NAME) > $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
