include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME            = blasr
$(_NAME)_REPO   ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC          = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION?= HEAD
ifeq ($(OPSYS),FreeBSD)
MAKE            := $(MAKE) DL_LIBFLAGS=''
endif
ifneq ($(wildcard $(PREFIX)/lib/libsz.so),)
HDF5_LIBFLAGS = -lhdf5_cpp -lhdf5 -lsz
HAVE_SZ       = -lsz
else
HDF5_LIBFLAGS = -lhdf5_cpp -lhdf5
HAVE_SZ       =
endif

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
do-config: $(_WRKSRC)/defines.mk $(_WRKSRC)/utils/bax2bam/build/Makefile $(_WRKSRC)/utils/bam2bax/build/Makefile
$(_WRKSRC)/defines.mk: | do-fetch
	cd $(_WRKSRC) && \
        $(SYSPYTHON) configure.py --shared \
               PREFIX=$(PREFIX) \
             HDF5_INC=$(HDF5_ROOT)/include \
             HDF5_LIB=$(HDF5_ROOT)/lib \
             ZLIB_LIB=$(ZLIB_ROOT) \
            BOOST_INC=$(BOOST_ROOT)/include \
        LIBPBDATA_INC=$(PREFIX)/include/pbdata \
        LIBPBIHDF_INC=$(PREFIX)/include/hdf \
         LIBBLASR_INC=$(PREFIX)/include/alignment \
        LIBPBDATA_LIB=$(PREFIX)/lib \
        LIBPBIHDF_LIB=$(PREFIX)/lib \
         LIBBLASR_LIB=$(PREFIX)/lib \
            PBBAM_INC=$(PREFIX)/include \
            PBBAM_LIB=$(PREFIX)/lib \
           HTSLIB_INC=$(PREFIX)/src/htslib/include \
           HTSLIB_LIB=$(PREFIX)/src/htslib/lib
$(_WRKSRC)/utils/bax2bam/build/Makefile: | do-fetch
	mkdir -p $(_WRKSRC)/utils/bax2bam/build
	cd $(_WRKSRC)/utils/bax2bam/build && \
        $(CMAKE) \
              -DBoost_INCLUDE_DIRS=$(BOOST_ROOT)/include \
              -DHDF5_RootDir=$(HDF5_ROOT) \
              -DPacBioBAM_INCLUDE_DIRS=$(PREFIX)/include \
              -DPacBioBAM_LIBRARIES=$(PREFIX)/lib/libpbbam.$(DYLIB) \
              -DHTSLIB_INCLUDE_DIRS=$(PREFIX)/src/htslib/include \
              -DHTSLIB_LIBRARIES=$(PREFIX)/src/htslib/lib/libhts.a \
              -DGTEST_SRC_DIR=$(PREFIX)/src/gtest \
              -DZLIB_LIBRARIES=$(ZLIB_ROOT)/lib/libz.$(DYLIB) \
              -DZLIB_INCLUDE_DIRS=$(ZLIB_ROOT)/include \
              -DBax2Bam_EXE_LINKER_FLAGS="$(HAVE_SZ) " \
        ..
$(_WRKSRC)/utils/bam2bax/build/Makefile: | do-fetch
	mkdir -p $(_WRKSRC)/utils/bam2bax/build
	cd $(_WRKSRC)/utils/bam2bax/build && \
        $(CMAKE) \
              -DBoost_INCLUDE_DIRS=$(BOOST_ROOT)/include \
              -DHDF5_RootDir=$(HDF5_ROOT) \
              -DPacBioBAM_INCLUDE_DIRS=$(PREFIX)/include \
              -DPacBioBAM_LIBRARIES=$(PREFIX)/lib/libpbbam.$(DYLIB) \
              -DHTSLIB_INCLUDE_DIRS=$(PREFIX)/src/htslib/include \
              -DHTSLIB_LIBRARIES=$(PREFIX)/src/htslib/lib/libhts.a \
              -DGTEST_SRC_DIR=$(PREFIX)/src/gtest \
              -DZLIB_LIBRARIES=$(ZLIB_ROOT)/lib/libz.$(DYLIB) \
              -DZLIB_INCLUDE_DIRS=$(ZLIB_ROOT)/include \
              -DBam2Bax_EXE_LINKER_FLAGS="$(HAVE_SZ) " \
        ..
do-build:
ifneq ($(wildcard $(PREFIX)/lib/libsz.so),)
	$(MAKE) -C $(_WRKSRC) blasr HDF5_LIBFLAGS="$(HDF5_LIBFLAGS)"
	$(MAKE) -C $(_WRKSRC)/utils HDF5_LIBFLAGS="$(HDF5_LIBFLAGS)"
else
	$(MAKE) -C $(_WRKSRC) blasr
	$(MAKE) -C $(_WRKSRC)/utils
endif
	$(MAKE) -C $(_WRKSRC)/utils/bax2bam/build
	$(MAKE) -C $(_WRKSRC)/utils/bam2bax/build
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	cd $(_WRKSRC) && tar cf - blasr | tar xf - -C $(PREFIX)/bin/
	cd $(_WRKSRC)/utils && tar cf - loadPulses pls2fasta sawriter | tar xf - -C $(PREFIX)/bin/
	cd $(_WRKSRC)/utils && tar cf - samFilter samtoh5 samtom4 sdpMatcher toAfg | tar xf - -C $(PREFIX)/bin/
	cd $(_WRKSRC)/utils/bax2bam && tar cf - bin | tar xf - -C $(PREFIX)/
	cd $(_WRKSRC)/utils/bam2bax && tar cf - bin | tar xf - -C $(PREFIX)/
	cd $(PREFIX) && \
        find bin/blasr      \
             bin/loadPulses \
             bin/pls2fasta  \
             bin/sawriter   \
             bin/bax2bam    \
             bin/bam2bax    \
             bin/bam2plx    \
             bin/samFilter  \
             bin/samtoh5    \
             bin/samtom4    \
             bin/sdpMatcher \
             bin/toAfg      \
        > $@
do-clean:
	rm -rf $(_WRKSRC)/utils/bax2bam/build
	rm -rf $(_WRKSRC)/utils/bam2bax/build clean
	$(MAKE) -C $(_WRKSRC) clean
do-distclean:
	test -d $(_WRKSRC) && cd $(_WRKSRC) && $(GIT) clean -xdf || true
do-flush:
	rm -rf $(_WRKSRC)
