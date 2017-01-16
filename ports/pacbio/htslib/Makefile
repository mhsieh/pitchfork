include ../../../mk/pitchfork.mk

# Local variables
_NAME             = htslib
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= ea846607f3ca7f49b3fb43df76f572d3f47cc6bb
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'\$$\$$ORIGIN/../lib'
export LDFLAGS
endif

# Local works
ifeq ($(origin HAVE_HTSLIB),undefined)
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-build:
	$(MAKE) -C $(_WRKSRC) \
                   CC=$(CC) \
            ZLIB_ROOT=$(ZLIB_ROOT) \
               CFLAGS="$(CFLAGS) -Wall -O2 -Wno-unused-function" \
              LDFLAGS="$(LDFLAGS)" \
        >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	mkdir -p $(PREFIX)/src/htslib/lib
	mkdir -p $(PREFIX)/src/htslib/include
	cd $(_WRKSRC) && tar cf - */*.h | tar xf - -C $(PREFIX)/src/htslib/include/
	cd $(_WRKSRC) && tar cf - *.a   | tar xf - -C $(PREFIX)/src/htslib/lib/
	cd $(PREFIX)  && find src/htslib ! -type d > $@
	@echo "# $(_REVISION)" >> $@ 
#this thing cannot be installed to prefix/lib or it will kill pysam/samtools
else
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/src/htslib
	cd $(HAVE_HTSLIB) && tar cf - lib/libhts.* include/htslib include/cram | tar xf - -C $(STAGING)/$(_NAME)/src/htslib
	cd $(STAGING)/$(_NAME) && tar cf - src/htslib | tar xf - -C $(PREFIX)
	cd $(STAGING)/$(_NAME) && find src/htslib ! -type d > $@
	@echo "# $(HAVE_HTSLIB)" >> $@
endif
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flash:
	rm -rf $(_WRKSRC)
