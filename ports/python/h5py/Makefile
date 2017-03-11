include ../../../mk/pitchfork.mk

# Local variables
_VER    = 2.4.0
_NAME   = h5py-$(_VER)
_WRKSRC = $(WORKDIR)/$(_NAME)

# Local works
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" HDF5_DIR="$(HDF5_ROOT)" \
            $(PIP_INSTALL) --root $(STAGING)/$(_NAME) h5py==$(_VER)
	rsync -aKx $(STAGING)/$(_NAME)/$(PREFIX)/ $(PREFIX)/
	cd $(STAGING)/$(_NAME)$(PREFIX) && find * |grep -v '^$$'|sort -r > $@
do-clean:
	rm -rf $(STAGING)/$(_NAME)
