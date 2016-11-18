include ../../../mk/pitchfork.mk

# Local variables
_NAME             = pbcommandR
$(_NAME)_REPO    ?= git://github.com/PacificBiosciences/pbcommandR
_WRKSRC           = $(WORKDIR)/$(_NAME)
$(_NAME)_VERSION ?= HEAD
R                := $(shell ../../../bin/checkR $(HAVE_R))
_tmpvar          := $(if $(shell which $(R)),exists,$(error "unable to run $(R)"))
ifneq ($(origin HAVE_R),undefined)
  R_LIBS         := $(PREFIX)/lib/R/library:$(shell $(HAVE_R) --slave --vanilla -e 'cat(.Library)')
else
  R_LIBS         := $(PREFIX)/lib/R/library:$(shell $(R)      --slave --vanilla -e 'cat(.Library)')
endif
_REVISION         = $(shell cd $(_WRKSRC) && $(GIT) rev-parse --short $($(_NAME)_VERSION) || true)

# Local works
do-extract:
do-fetch: $(_WRKSRC)
$(_WRKSRC):
ifeq ($(wildcard $($(_NAME)_REPO)),)
	$(GIT) clone $($(_NAME)_REPO) $@
	cd $(_WRKSRC) && $(GIT) checkout $($(_NAME)_VERSION)
else
	ln -sfn $($(_NAME)_REPO) $(_WRKSRC)
endif
do-config: $(_WRKSRC)/install-pbbamr.R
$(_WRKSRC)/install-pbbamr.R:
	mkdir -p $(_WRKSRC)
	echo 'install.packages("data.table", repos="http://cran.r-project.org")' >  $(_WRKSRC)/install-pbbamr.R
	echo 'install.packages("argparser",  repos="http://cran.r-project.org")' >> $(_WRKSRC)/install-pbbamr.R
	echo 'install.packages("logging",    repos="http://cran.r-project.org")' >> $(_WRKSRC)/install-pbbamr.R
	echo 'install.packages("pryr",       repos="http://cran.r-project.org")' >> $(_WRKSRC)/install-pbbamr.R
	echo 'install.packages("uuid",       repos="http://cran.r-project.org")' >> $(_WRKSRC)/install-pbbamr.R
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-fetch do-config
	mkdir -p $(PREFIX)/lib/R/library
	R_LIBS="$(R_LIBS)" $(R) -f $(_WRKSRC)/install-pbbamr.R
	R_LIBS=$(R_LIBS) \
            $(R) CMD INSTALL $(_WRKSRC)
	install -c -m 755 $(_WRKSRC)/bin/exampleHelloWorld.R      $(PREFIX)/bin/exampleHelloWorld.R
	install -c -m 755 $(_WRKSRC)/bin/exampleReseqConditions.R $(PREFIX)/bin/exampleReseqConditions.R 
	cd $(PREFIX) && \
        find \
             lib/R/library/chron \
             lib/R/library/data.table \
             lib/R/library/argparser \
             lib/R/library/logging \
             lib/R/library/pryr \
             lib/R/library/uuid \
             lib/R/library/$(_NAME) > $@
	@echo "# $(_REVISION)" >> $@ 
do-distclean:
	cd $(_WRKSRC) && $(GIT) clean -xdf
do-flush:
	rm -rf $(_WRKSRC)
