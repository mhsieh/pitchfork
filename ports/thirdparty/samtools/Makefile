include ../../../mk/pitchfork.mk

# Local variables
_NAME   = samtools-1.3.1
_URL    = https://github.com/samtools/samtools/releases/download/1.3.1
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = $(_NAME).tar.bz2

# Local works
ifeq ($(origin HAVE_SAMTOOLS),undefined)
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar jxf $(_FILE) -C $(WORKDIR)
ifeq ($(OPSYS),Darwin)
	cat patch-01 | (cd $(_WRKSRC) && patch -p0)
	$(SED) -i -e 's/-rdynamic//g' $(_WRKSRC)/Makefile $(_WRKSRC)/htslib-*/configure*
endif
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && \
         CFLAGS="-I$(_WRKSRC)/htslib-1.3 $(CFLAGS)" ./configure --prefix=$(PREFIX) \
                     --with-htslib=$(_WRKSRC)/htslib-1.3.1) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/samtools
$(_WRKSRC)/samtools: | do-config
	$(MAKE) CC=$(CC) CFLAGS="-g -Wall -O2 $(CFLAGS)" -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) prefix=$(STAGING)/$(_NAME) install >& install.log || $(PFHOME)/bin/diewith install.log
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
else
ifeq ($(wildcard $(HAVE_SAMTOOLS)),)
    $(error HAVE_SAMTOOLS not found)
endif
_NAME     = samtools
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/bin
	mkdir -p $(STAGING)/$(_NAME)/share/man/man1
	cp -aL $(HAVE_SAMTOOLS)/bin/samtools $(STAGING)/$(_NAME)/bin/
	cp -aL $(HAVE_SAMTOOLS)/share/man/man1/samtools.1 $(STAGING)/$(_NAME)/share/man/man1/
endif
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	$(MAKE) -C $(_WRKSRC) distclean
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
