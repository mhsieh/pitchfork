include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME             = bam2fastx
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
# CPPFLAGS is only used in gtest
CPPFLAGS+= -D_GNU_SOURCE
export CPPFLAGS
# HTSLIB problem with this CMAKEFILE
CXXFLAGS += -I$(PREFIX)/src/htslib/include
export CXXFLAGS
do-config: $(_WRKSRC)/build/Makefile
$(_WRKSRC)/build/Makefile: | do-fetch
	mkdir -p $(_WRKSRC)/build
	cd $(_WRKSRC)/build \
     && $(CMAKE) \
              -DCMAKE_C_COMPILER_LAUNCHER=ccache \
              -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
              -DPacBioBAM_LIBRARIES=$(PREFIX)/lib/libpbbam.$(DYLIB) \
              -DHTSLIB_INCLUDE_DIRS=$(PREFIX)/src/htslib/include \
              -DHTSLIB_LIBRARIES=$(PREFIX)/src/htslib/lib/libhts.a \
              -DBoost_INCLUDE_DIRS=$(BOOST_ROOT)/include \
              -DZLIB_INCLUDE_DIRS=$(ZLIB_ROOT)/include \
              -DZLIB_LIBRARIES=$(ZLIB_ROOT)/lib/libz.$(DYLIB) \
            ..
do-build:
	$(MAKE) VERBOSE=1 -C $(_WRKSRC)/build
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	cd $(_WRKSRC)/build && tar cf - bam2fasta bam2fastq | tar xf - -C $(PREFIX)/bin
	cd $(PREFIX) && \
        find bin/bam2fasta \
             bin/bam2fastq \
        > $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	$(MAKE) -C $(_WRKSRC)/build clean
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
