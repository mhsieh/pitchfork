include ../../../mk/config.mk

# Local variables
_NAME            = Python-2.7.10
_URL             = https://www.python.org/ftp/python/2.7.10
_FILE            = Python-2.7.10.tgz
_WRKSRC          = $(WORKSPACE)/$(_NAME)
_CONFIGURE_ARGS  = --prefix=$(PREFIX)
                 # avoid STAGING for now
_CONFIGURE_ARGS += --enable-unicode=ucs4
_CFLAGS          = $(CFLAGS) -I$(PREFIX)/include/ncurses

# Local works
do-extract: wscheck
	@test -e $(_FILE) || $(CURL) -O $(_URL)/$(_FILE)
	@which md5sum >& /dev/null && md5sum -c MD5SUM
	@test -d $(_WRKSRC) || tar zxf $(_FILE) -C $(WORKSPACE)
do-clean:
	@test -d $(_WRKSRC) && rm -rf $(_WRKSRC) || true
do-config: do-extract
	@echo CFLAGS="$(_CFLAGS)" LD_LIBRARY_PATH=$(PREFIX)/lib:$$LD_LIBRARY_PATH
	@cd $(_WRKSRC) && (test -e config.log \
     || CFLAGS="$(_CFLAGS)" ./configure $(_CONFIGURE_ARGS))
do-build: do-config
	@test -e $(PREFIX)/var/pkg/$(_NAME) || make -C $(_WRKSRC) >& build.log
do-install: do-build pfcheck $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	@find $(PREFIX) ! -type d > $(_WRKSRC).before.list
	@make -C $(_WRKSRC) install >& install.log
	@find $(PREFIX) ! -type d > $(_WRKSRC).after.list
	@diff -u $(_WRKSRC).before.list $(_WRKSRC).after.list | \
	grep -v '^++'|awk -F $(PREFIX)/ '/^+/{print $$2}' > $(PREFIX)/var/pkg/$(_NAME)
do-uninstall:
	@cd $(PREFIX) && cat var/pkg/$(_NAME) | xargs rm -f
	@rm -f $(PREFIX)/var/pkg/$(_NAME)
