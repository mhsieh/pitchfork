include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME             = pbbam
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC           = $(WORKSPACE)/$(_NAME)
$(_NAME)_VERSION ?= HEAD

# Local works
do-fetch: | $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	rsync -avx $($(_NAME)_REPO)/ $(_WRKSRC)/
endif
do-config: | $(_WRKSRC)/build/Makefile
$(_WRKSRC)/build/Makefile:
	cd $(_WRKSRC) && mkdir -p build
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
            -DCMAKE_SKIP_BUILD_RPATH=TRUE \
            ..
do-build:
	$(MAKE) -C $(_WRKSRC)/build
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | $(_WRKSRC)/build/Makefile
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	cd $(_WRKSRC) && tar cf - bin lib include | tar xf - -C $(STAGING)/$(_NAME)
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	$(MAKE) -C $(_WRKSRC)/build clean
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
