include ../../../mk/pitchfork.mk

# Local variables
_VER    = 0.9.1.4
_NAME   = pysam-$(_VER)
_WRKSRC = $(WORKDIR)/$(_NAME)

# Local works
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" HTSLIB_CONFIGURE_OPTIONS="--disable-libcurl" $(PIP_INSTALL) --root $(STAGING)/$(_NAME) pysam==$(_VER)
	rsync -aKx $(STAGING)/$(_NAME)/$(PREFIX)/ $(PREFIX)/
	cd $(STAGING)/$(_NAME)$(PREFIX) && find * |grep -v '^$$'|sort -r > $@
do-clean:
	rm -rf $(STAGING)/$(_NAME)
