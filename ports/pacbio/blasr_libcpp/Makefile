include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME            = blasr_libcpp
$(_NAME)_REPO   ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC          = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION?= HEAD

# Local works
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-config: $(_WRKSRC)/defines.mk
$(_WRKSRC)/defines.mk: | do-extract
	cd $(_WRKSRC) && \
        $(SYSPYTHON) configure.py \
            PREFIX=$(PREFIX) \
          HDF5_INC=$(HDF5_ROOT)/include \
          HDF5_LIB=$(HDF5_ROOT)/lib \
          ZLIB_LIB=$(ZLIB_ROOT) \
         PBBAM_INC=$(PREFIX)/include PBBAM_LIB=$(PREFIX)/lib \
         BOOST_INC=$(BOOST_ROOT)/include \
        HTSLIB_INC=$(PREFIX)/src/htslib/include \
        HTSLIB_LIB=$(PREFIX)/src/htslib/lib
do-build:
	$(MAKE) -C $(_WRKSRC) libpbdata LDLIBS=-lpbbam
	$(MAKE) -C $(_WRKSRC) libpbihdf
	$(MAKE) -C $(_WRKSRC) libblasr
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	cp -a $(_WRKSRC)/alignment/libblasr.$(DYLIB) $(PREFIX)/lib/
	cp -a $(_WRKSRC)/hdf/libpbihdf.$(DYLIB) $(PREFIX)/lib/
	cp -a $(_WRKSRC)/pbdata/libpbdata.$(DYLIB) $(PREFIX)/lib/
	cd $(_WRKSRC) && tar cf - `find alignment hdf pbdata \( -name '*.hpp' -or -name '*.h' \)` | tar xf - -C $(PREFIX)/include
	echo $(PREFIX)/lib/alignment/libblasr.$(DYLIB) > $@
	echo $(PREFIX)/lib/hdf/libpbihdf.$(DYLIB) >> $@
	echo $(PREFIX)/pbdata/libpbdata.$(DYLIB) >> $@
	cd $(_WRKSRC) && find alignment hdf pbdata \( -name '*.hpp' -or -name '*.h' \) | awk '{print "include/"$$1}' >> $@
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
do-distclean:
	test -d $(_WRKSRC) && cd $(_WRKSRC) && $(GIT) clean -xdf || true
do-flush:
	rm -rf $(_WRKSRC)
