include ../../../mk/pitchfork.mk

# Local variables
_NAME             = pbdagcon
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)

export CC
export CXX

# Local works
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-config: $(_WRKSRC)/build/defines.mk
$(_WRKSRC)/build/defines.mk: | do-fetch
	mkdir -p $(_WRKSRC)/build
	cd $(_WRKSRC) \
     &&     BOOST_INCLUDE=$(BOOST_ROOT)/include \
        LIBPBDATA_INCLUDE=$(PREFIX)/include/pbdata \
            LIBPBDATA_LIB=$(PREFIX)/lib \
         LIBBLASR_INCLUDE=$(PREFIX)/include/alignment \
             LIBBLASR_LIB=$(PREFIX)/lib \
        LIBPBIHDF_INCLUDE=$(PREFIX)/include \
            LIBPBIHDF_LIB=$(PREFIX)/lib \
            PBBAM_INCLUDE=$(PREFIX)/include \
                PBBAM_LIB=$(PREFIX)/lib \
           HTSLIB_INCLUDE=$(PREFIX)/src/htslib/include \
               HTSLIB_LIB=$(PREFIX)/src/htslib/lib \
             HDF5_INCLUDE=$(HDF5_ROOT)/include \
                 HDF5_LIB=$(HDF5_ROOT)/lib \
             DALIGNER_SRC=$(WORKDIR)/daligner \
              DAZZ_DB_SRC=$(WORKDIR)/dazzdb \
                GTEST_SRC=$(PREFIX)/src/gtest/src \
            GTEST_INCLUDE=$(PREFIX)/src/gtest/include \
        ./configure.py --build-dir=$(_WRKSRC)/build
do-build:
	$(MAKE) -C $(_WRKSRC)/build
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	cd $(_WRKSRC)/build/src/cpp \
      && tar cf - pbdagcon dazcon \
                  | tar xf - -C $(PREFIX)/bin/
	cd $(PREFIX) && \
        find bin/pbdagcon \
             bin/dazcon   \
        > $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	$(MAKE) -C $(_WRKSRC)/build clean
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
