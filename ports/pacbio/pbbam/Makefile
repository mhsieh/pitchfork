include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME             = pbbam
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
CPPFLAGS+= -D_GNU_SOURCE
export CPPFLAGS
do-config: $(_WRKSRC)/build/Makefile
$(_WRKSRC)/build/Makefile: | do-fetch
	mkdir -p $(_WRKSRC)/build
	cd $(_WRKSRC)/build \
     && $(CMAKE) \
            -DPacBioBAM_build_shared=ON \
            -DPacBioBAM_build_docs=OFF \
            -DPacBioBAM_build_tests=OFF \
            -DHTSLIB_INCLUDE_DIRS=$(PREFIX)/src/htslib/include \
            -DHTSLIB_LIBRARIES=$(PREFIX)/src/htslib/lib/libhts.a \
            -DZLIB_INCLUDE_DIRS=$(ZLIB_ROOT)/include \
            -DZLIB_LIBRARIES=$(ZLIB_ROOT)/lib/libz.$(DYLIB) \
            -DBoost_INCLUDE_DIRS=$(BOOST_ROOT)/include \
            -DCMAKE_BUILD_TYPE=RelWithDebInfo \
            -DCMAKE_SKIP_BUILD_RPATH=FALSE \
            ..
do-build:
	$(MAKE) -C $(_WRKSRC)/build
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	mkdir -p $(STAGING)/$(_NAME)
	cd $(_WRKSRC)/build && tar cf - bin lib | tar xf - -C $(STAGING)/$(_NAME)
	cd $(_WRKSRC) && tar cf - include | tar xf - -C $(STAGING)/$(_NAME)
	cd $(STAGING)/$(_NAME) && tar cf - bin lib include | tar xf - -C $(PREFIX)
	cd $(STAGING)/$(_NAME) && find bin lib include ! -type d > $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	$(MAKE) -C $(_WRKSRC)/build clean
do-distclean:
	test -d $(_WRKSRC) && cd $(_WRKSRC) && $(GIT) clean -xdf || true
	rm -rf $(STAGING)/$(_NAME)
do-flush:
	rm -rf $(_WRKSRC)
	rm -rf $(STAGING)/$(_NAME)
