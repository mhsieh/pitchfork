include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME    = boost-1.60.0
_URL     = https://prdownloads.sourceforge.net/boost
_FILE    = boost_1_60_0.tar.gz
_WRKSRC  = $(WORKDIR)/$(_NAME)

# Local works
ifeq ($(origin HAVE_BOOST),undefined)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	mkdir -p $(_WRKSRC)
	tar zxf $(_FILE) --strip=1 -C $(_WRKSRC)
do-config: $(_WRKSRC)/project-config.jam
$(_WRKSRC)/project-config.jam: | do-extract
	(cd $(_WRKSRC) \
         && ./bootstrap.sh --prefix=$(PREFIX) \
                           --with-libraries=system,program_options,iostreams \
        ) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(STAGING)/$(_NAME)/lib/libboost_system.a
$(STAGING)/$(_NAME)/lib/libboost_system.a: | do-config
	(cd $(_WRKSRC) && \
         $(SED) -i -e "s|using gcc ;|using gcc : $(shell $(CXX) -dumpversion) : $(CXX) ;|" project-config.jam && \
         ./bjam -s NO_BZIP2=1 \
                --stagedir=$(STAGING)/$(_NAME) \
                stage) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	mkdir -p $(STAGING)/$(_NAME)/include
	cd $(_WRKSRC) && tar cf - boost | tar xf - -C $(STAGING)/$(_NAME)/include
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
else
_BOOST = $(shell ../../../bin/checkBOOST $(HAVE_BOOST))
_NAME  = boost
do-install:
	ln -fs $(_BOOST)/include/boost $(PREFIX)/include/
	ln -fs $(_BOOST)/lib/libboost* $(PREFIX)/lib/
	echo include/boost > $(PREFIX)/var/pkg/$(_NAME)
	cd $(PREFIX) && find lib -name 'libbost*' >> $(PREFIX)/var/pkg/$(_NAME)
endif
do-clean:
	rm -f build.log
	cd $(_WRKSRC) && ./bjam --clean
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	rm -f config.log $(_WRKSRC)/bootstrap.log
	cd $(_WRKSRC) && rm -rf bin.v2 project-config.jam b2 bjam
do-flush:
	rm -rf $(_WRKSRC) || true
