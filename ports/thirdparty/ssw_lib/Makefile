include ../../../mk/pitchfork.mk

# Local variables
_NAME             = ssw_lib
$(_NAME)_REPO     = git://github.com/mengyao/Complete-Striped-Smith-Waterman-Library
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION  = a9beb7e4c67824538e15fd781002983d2b333261

# Local works
do-fetch: $(_WRKSRC)
$(_WRKSRC):
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
do-build:
	$(MAKE) -C $(_WRKSRC)/src CC="$(CC) $(CFLAGS) $(LDFLAGS)" CXX="$(CXX) $(CXXFLAGS) $(LDFLAGS)"
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/bin 
	mkdir -p $(STAGING)/$(_NAME)/lib/python2.7/site-packages
	mkdir -p $(STAGING)/$(_NAME)/include
	cd $(_WRKSRC)/src && tar cf - ssw_test pyssw.py | tar xf - -C $(STAGING)/$(_NAME)/bin/
	cd $(_WRKSRC)/src && tar cf - libssw.so | tar xf - -C $(STAGING)/$(_NAME)/lib/
	cd $(_WRKSRC)/src && tar cf - ssw_wrap.py | tar xf - -C $(STAGING)/$(_NAME)/lib/python2.7/site-packages/
	cd $(_WRKSRC)/src && tar cf - *.h | tar xf - -C $(STAGING)/$(_NAME)/include/
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)/
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	$(MAKE) -C $(_WRKSRC)/src clean
	rm -rf $(STAGING)/$(_NAME)
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flash:
	rm -rf $(_WRKSRC)
