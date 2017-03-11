include ../../../mk/pitchfork.mk

# Local variables
_NAME            = pip-7.1.2
_URL             = https://raw.githubusercontent.com/pypa/pip
_REV             = 3dfa1f9a55d25587e9e97a27d8c87943e4b6aa54
_WRKSRC          = $(WORKDIR)/$(_NAME)
_FILE            = get-pip.py

# Local works
do-fetch: | $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$(_REV)/contrib/$@
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	python $(_FILE) --user --no-setuptools
	$(PIP_INSTALL) setuptools==33.1.1
	cd $(PREFIX) && \
        find bin/easy_install* \
             bin/pip* \
             bin/wheel \
             lib/python2.7/site-packages/_markerlib    \
             lib/python2.7/site-packages/easy_install* \
             lib/python2.7/site-packages/pip*          \
             lib/python2.7/site-packages/pkg_resources \
             lib/python2.7/site-packages/setuptools*   \
             lib/python2.7/site-packages/wheel* | sort -r > $@
