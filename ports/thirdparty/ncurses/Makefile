include ../../../mk/pitchfork.mk

# Local variables
_NAME   = ncurses-6.0
_URL    = ftp://ftp.gnu.org/gnu/ncurses
_FILE   = $(_NAME).tar.gz
_WRKSRC = $(WORKDIR)/$(_NAME)
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'\$$\$$ORIGIN/../lib'
LDFLAGS += -static-libgcc
export LDFLAGS
endif

# Local works
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-clean-distfile:
	rm -f $(_FILE)
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" CPP="gcc -E -P" ./configure --prefix=$(PREFIX) --with-shared 2>&1) \
        >& config.log || $(PFHOME)/bin/diewith config.log
	sleep 1
do-build: $(_WRKSRC)/lib/libncurses.$(DYLIB)
$(_WRKSRC)/lib/libncurses.$(DYLIB): | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
do-clean:
	$(MAKE) -C $(_WRKSRC) clean
	rm -f build.log install.log
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	$(MAKE) -C $(_WRKSRC) distclean
	rm -f $(_WRKSRC)/config.log config.log
do-flush:
	rm -rf $(_WRKSRC) || true
ifeq ($(origin HAVE_NCURSES),undefined)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) prefix=$(STAGING)/$(_NAME) install >& install.log || $(PFHOME)/bin/diewith install.log
	if [ -d $(STAGING)/$(_NAME)/lib64 ]; then \
           ln -s libncurses.$(DYLIB) $(STAGING)/$(_NAME)/lib64/libcurses.$(DYLIB); \
        elif [ -d $(STAGING)/$(_NAME)/lib ]; then \
           ln -s libncurses.$(DYLIB) $(STAGING)/$(_NAME)/lib/libcurses.$(DYLIB); \
        else \
           exit 1; \
        fi
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
else
_NCURSES:=$(shell ../../../bin/checkNCURSES $(HAVE_NCURSES))
provided: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/include
	mkdir -p $(STAGING)/$(_NAME)/lib
	mkdir -p $(STAGING)/$(_NAME)/share
	cp -a $(_NCURSES)/include/ncurses $(STAGING)/$(_NAME)/include/
	find $(_NCURSES)/lib -maxdepth 1 \
             \( -name 'libcurse*$(DYLIB)*'  \
             -o -name 'libform*$(DYLIB)*'   \
             -o -name 'libmenu*$(DYLIB)*'   \
             -o -name 'libncurse*$(DYLIB)*' \
             -o -name 'libpanel*$(DYLIB)*'  \
             -o -name 'terminfo'            \
             \) -exec cp -a {} $(STAGING)/$(_NAME)/lib/ \;
	cp -a $(_NCURSES)/share/terminfo $(STAGING)/$(_NAME)/share/
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
endif
