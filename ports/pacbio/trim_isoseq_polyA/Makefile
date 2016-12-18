include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME             = trim_isoseq_polyA
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
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-config: $(_WRKSRC)/_build/Makefile
$(_WRKSRC)/_build/Makefile: | do-fetch
	mkdir -p $(_WRKSRC)/_build
	cd $(_WRKSRC)/_build  && \
        $(CMAKE) \
              -DBOOST_ROOT=$(BOOST_ROOT) \
              -DCMAKE_BUILD_TYPE=Release \
              -DCMAKE_SKIP_BUILD_RPATH=FALSE \
              -DSUPPORT_COMPRESSED_INPUT=ON \
              -DZLIB_ROOT=$(PREFIX) \
              -DBZIP2_LIBRARIES=$(PREFIX)/lib/libbz2.so \
              -DBZIP2_INCLUDE_DIR=$(PREFIX)/include \
            ..
do-build:
	$(MAKE) -C $(_WRKSRC)/_build
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rsync -ax $(_WRKSRC)/bin/ $(PREFIX)/bin/
	rsync -ax $(_WRKSRC)/lib/ $(PREFIX)/lib/
	cd $(_WRKSRC) && find bin lib > $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	$(MAKE) -C $(_WRKSRC)/_build clean
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
