include ../../../mk/pitchfork.mk

# Local variables
_NAME   = virtualenv-13.1.2
_URL    = https://pypi.python.org/packages/source/v/virtualenv
_FILE   = $(_NAME).tar.gz
_WRKSRC = $(WORKDIR)/$(_NAME)
PYTHON  = /usr/bin/python
ifneq ($(origin HAVE_PYTHON),undefined)
    PYTHON := $(shell ../../../bin/chkSysPython $(HAVE_PYTHON))
    $(info $(PYTHON))
endif

# Local works
do-extract: $(_WRKSRC)/virtualenv.py
$(_WRKSRC)/virtualenv.py: | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-extract
	$(PYTHON) --version 2>&1 | grep Anaconda \
        && rsync -aKx $(shell dirname $(PYTHON))/../lib*/libpython* $(PREFIX)/lib/ \
        || true
	$(PYTHON) $(_WRKSRC)/virtualenv.py $(PREFIX)
	rsync -aKx $(shell dirname $(PYTHON))/../lib*/python2.7/pydoc* $(PREFIX)/lib/python2.7/
	rsync -aKx $(shell dirname $(PYTHON))/../bin/pydoc* $(PREFIX)/bin/
	cd $(PREFIX) && \
        find lib/python*   include/python*   bin/python* \
             bin/activate* bin/easy_install* bin/wheel bin/pydoc* \
	| grep -v /pip \
        | sort -r > $@
