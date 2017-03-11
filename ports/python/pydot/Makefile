include ../../../mk/pitchfork.mk

# Local variables
_VER    = 1.0.28
_NAME   = pydot-$(_VER)
_WRKSRC = $(WORKDIR)/$(_NAME)

# Local sanity check
ifeq ($(OPSYS),Darwin)
_tmpvar:=$(if $(shell which dot),exists,$(error "unable to run dot, consider doing port install graphviz"))
else
_tmpvar:=$(if $(shell which dot),exists,$(error "unable to run dot, consider doing yum install graphviz"))
endif

# Local works
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	$(PIP_INSTALL) --root $(STAGING)/$(_NAME) pydot==$(_VER)
	rsync -aKx $(STAGING)/$(_NAME)/$(PREFIX)/ $(PREFIX)/
	cd $(STAGING)/$(_NAME)$(PREFIX) && find * |grep -v '^$$'|sort -r > $@
do-clean:
	rm -rf $(STAGING)/$(_NAME)
