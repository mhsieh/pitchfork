include ../../../mk/pitchfork.mk

# Local variables
_NAME             = smrtflow
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/$(_NAME)
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)

# Local works
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-build: $(_WRKSRC)/smrt-analysis/target/pack/Makefile $(_WRKSRC)/smrt-server-base/target/pack/Makefile $(_WRKSRC)/smrt-server-analysis/target/pack/Makefile
$(_WRKSRC)/smrt-analysis/target/pack/Makefile: | do-fetch
	cd $(_WRKSRC) && sbt smrt-analysis/clean smrt-analysis/compile smrt-analysis/pack
$(_WRKSRC)/smrt-server-base/target/pack/Makefile: | do-fetch
	cd $(_WRKSRC) && sbt smrt-server-base/clean smrt-server-base/compile smrt-server-base/pack
$(_WRKSRC)/smrt-server-analysis/target/pack/Makefile: | do-fetch
	cd $(_WRKSRC) && sbt smrt-server-analysis/clean smrt-server-analysis/compile smrt-server-analysis/pack
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	$(MAKE) PREFIX=$(PREFIX) -C $(_WRKSRC)/smrt-analysis/target/pack install
	$(MAKE) PREFIX=$(PREFIX) -C $(_WRKSRC)/smrt-server-base/target/pack install
	$(MAKE) PREFIX=$(PREFIX) -C $(_WRKSRC)/smrt-server-analysis/target/pack install
	cd $(PREFIX) && find smrt-analysis* ! -type d > $@
	cd $(PREFIX) && find smrt-server-base* ! -type d >> $@
	cd $(PREFIX) && find smrt-server-analysis* ! -type d >> $@
	cd $(PREFIX) && \
        find bin/ds-tools \
             bin/fasta-to-reference \
             bin/merge-datasets \
             bin/movie-metadata-to-dataset \
             bin/movie-metadata-to-dataset-rtc \
             bin/reference-to-dataset \
             bin/validate-dataset \
             bin/get-smrt-server-status \
             bin/pbservice \
             bin/smrtflow-example-tool \
             bin/fasta-to-gmap-reference \
             bin/pbtestkit-service-runner \
             bin/smrt-db-tool \
        >> $@
	@echo "# $(_REVISION)" >> $@ 
do-clean:
	rm -rf $(_WRKSRC)/smrt-analysis/target
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
