include ../../../mk/pitchfork.mk

# Local variables
_NAME   = sbt-0.13.11
_URL    = https://dl.bintray.com/sbt/native-packages/sbt/0.13.11
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = sbt-0.13.11.tgz

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	tar zxf $(_FILE) -C $(STAGING)/$(_NAME)/
	cd $(STAGING)/$(_NAME)/sbt && tar cf - bin/sbt bin/sbt-launch-lib.bash bin/sbt-launch.jar | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|grep -v sbt.bat|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean:
	rm -rf $(STAGING)/$(_NAME)
do-flush:
	rm -rf $(_WRKSRC) || true
