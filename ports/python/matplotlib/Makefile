include ../../../mk/pitchfork.mk

# Local variables
_VER    = 1.4.3
_NAME   = matplotlib-$(_VER)
_WRKSRC = $(WORKDIR)/$(_NAME)

_tmpvar:=$(if $(shell which pkg-config),exists,$(error "unable to run pkg-config, consider doing yum install pkgconfig"))
#export PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig
_tmpvar:=$(if $(shell which freetype-config),exists,$(error "unable to run freetype-config, consider doing yum install freetype-devel"))
LDFLAGS := $(LDFLAGS) $(shell freetype-config --libs)
export LDFLAGS

# Local works
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	$(PIP_INSTALL) --root $(STAGING)/$(_NAME) matplotlib==$(_VER)
	rsync -aKx $(STAGING)/$(_NAME)/$(PREFIX)/ $(PREFIX)/
	cd $(STAGING)/$(_NAME)$(PREFIX) && find * |grep -v '^$$'|sort -r > $@
do-clean:
	rm -rf $(STAGING)/$(_NAME)
