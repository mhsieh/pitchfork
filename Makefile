RULE?=do-install
default:

override PFHOME:=${CURDIR}
-include settings.mk
include ./mk/config.mk
include ./mk/bootstrap.mk
include ./mk/init.mk # in case we want to re-run init/sanity

UNAME   = uname
ARCH   := $(shell $(UNAME) -m)
OPSYS  := $(shell $(UNAME) -s)
SHELL   = /bin/bash -e
PREFIX ?= deployment

default:
	@echo "'make init' must occur before any other rule."
	@echo "You can do that manually, or let it happen automatically as 'initialized.mk' is generated."
	@echo "CCACHE_DIR=${CCACHE_DIR}"
	@echo "PREFIX=${PREFIX}"

# Please add dependencies after this line
ccache:           initialized.o
openssl:          ccache
zlib:             ccache
boost:            ccache
ifeq ($(origin HAVE_PYTHON),undefined)
python:           ccache zlib openssl ncurses readline
endif
readline:         ccache ncurses
samtools:         ccache zlib ncurses
cmake:            ccache zlib
ncurses:          ccache
openblas:         ccache
hdf5:             ccache zlib
swig:             ccache python
libpng:           ccache zlib
hmmer:            ccache
gmap:             ccache zlib
sbt:              jre

pip:              python
cython:           pip ccache
ifeq ($(OPSYS),Darwin)
numpy:            pip cython
else
numpy:            pip cython openblas
endif
h5py:             pip hdf5 numpy six
jsonschema:       pip functools32
pydot:            pip pyparsing
fabric:           pip paramiko ecdsa pycrypto
rdflib:           pip six isodate html5lib
matplotlib:       pip numpy libpng pytz six pyparsing python-dateutil cycler
rdfextras:        pip rdflib
scipy:            pip numpy
appnope:          pip
avro:             pip
decorator:        pip
docopt:           pip
ecdsa:            pip
functools32:      pip
gnureadline:      pip readline
html5lib:         pip
ipython_genutils: pip
iso8601:          pip
isodate:          pip
jinja2:           pip MarkupSafe
networkx:         pip decorator matplotlib
paramiko:         pip
path.py:          pip
pexpect:          pip
pickleshare:      pip
ptyprocess:       pip
pycrypto:         pip
pyparsing:        pip
pysam:            pip zlib
python-dateutil:  pip
pytz:             pip
requests:         pip
simplegeneric:    pip
six:              pip
traitlets:        pip
xmlbuilder:       pip
nose:             pip
cram:             pip
cycler:           pip
MarkupSafe:       pip
tabulate:         pip
CramUnit:         cram nose xmlbuilder

# Not part of pacbio developers' software collection
nim:          ccache zlib
tcl:          ccache zlib
modules:      ccache tcl
ssw_lib:      ccache pip
fasta2bam:    ccache pbbam htslib zlib boost cmake
scikit-image: pip numpy decorator six networkx matplotlib pillow
pillow:       pip
dask.array:   pip toolz numpy
toolz:        pip
ipython:      pip traitlets pickleshare appnope decorator gnureadline pexpect ipython_genutils path.py ptyprocess simplegeneric
Cogent:       pip numpy scipy networkx scikit-image biopython bx-python PuLP ssw_lib mash matplotlib
biopython:    pip numpy
bx-python:    pip zlib
PuLP:         pip

# software from pacbio
htslib:       ccache zlib
blasr_libcpp: ccache boost hdf5 pbbam
blasr:        ccache blasr_libcpp hdf5 cmake
pbbam:        ccache samtools cmake boost htslib gtest
dazzdb:       ccache
daligner:     ccache dazzdb
damasker:     ccache
dextractor:   ccache
pbdagcon:     ccache dazzdb daligner pbbam blasr_libcpp
bam2fastx:    ccache pbbam htslib zlib boost cmake
#
pbcore:           pysam h5py
pbh5tools:        h5py pbcore
pbbarcode:        pbh5tools pbcore numpy h5py
pbcoretools:      pbcore pbcommand
pbcommand:        xmlbuilder jsonschema avro requests iso8601 numpy tabulate
pbsmrtpipe:       pbcommand jinja2 networkx pbcore pbcommand pyparsing pydot jsonschema xmlbuilder requests fabric nose
falcon_kit:       networkx daligner dazzdb damasker pbdagcon pypeFLOW
FALCON_unzip:     falcon_kit
falcon_polish:    falcon_kit blasr GenomicConsensus pbcoretools dextractor
falcon:           falcon_polish # an alias
pbfalcon:         falcon_polish pbsmrtpipe #pbreports
pbreports:        matplotlib cython numpy h5py pysam jsonschema pbcore pbcommand
kineticsTools:    scipy pbcore pbcommand h5py
pypeFLOW:         rdflib rdfextras
pbalign:          pbcore samtools blasr pbcommand
ConsensusCore:    numpy boost swig cmake
GenomicConsensus: pbcore pbcommand numpy h5py ConsensusCore unanimity
smrtflow:         sbt
pbtranscript:     scipy networkx pysam pbcore pbcommand pbcoretools pbdagcon hmmer blasr GenomicConsensus gmap
pbccs:            unanimity
unanimity:        h5py boost swig cmake htslib pbbam seqan pbcopper
pbcopper:         cmake boost zlib
#
pblaa:             htslib pbbam seqan unanimity
ppa:               boost cmake pbbam htslib
trim_isoseq_polyA: boost cmake
pysiv2:            fabric requests nose xmlbuilder pbsmrtpipe pbcoretools
PacBioTestData:    pip

# end of dependencies

# meta rules
bam2bax: blasr
bax2bam: blasr
reseq-core: \
       pbsmrtpipe pbalign blasr pbreports GenomicConsensus pbbam pbcoretools unanimity
isoseq-core: \
       reseq-core pbtranscript trim_isoseq_polyA hmmer gmap biopython cram nose
world: \
       reseq-core  pbfalcon  kineticsTools \
       isoseq-core ssw_lib   mash          \
       ipython     cram      nose
legacy_pbalign: legacy_blasr pbcore samtools pbcommand
	$(MAKE) -C ports/pacbio/pbalign do-uninstall do-distclean
	$(MAKE) -C ports/pacbio/pbalign pbalign_VERSION=56782fe18849ba9014508fcaca6bfdfd29e8bd1b ${RULE}
legacy_blasr: ccache samtools cmake boost htslib gtest hdf5
	$(MAKE) -C ports/pacbio/pbbam do-uninstall do-distclean
	$(MAKE) -C ports/pacbio/blasr do-uninstall do-distclean
	$(MAKE) -C ports/pacbio/blasr_libcpp do-uninstall do-distclean
	$(MAKE) -C ports/pacbio/pbbam pbbam_VERSION=a1dc0665f6e28dc4babecf8981ae966ac1528a4a ${RULE}
	$(MAKE) -C ports/pacbio/blasr_libcpp blasr_libcpp_VERSION=3fae61d1834426359e7ffe0786bfcd4da054793a ${RULE}
	$(MAKE) -C ports/pacbio/blasr blasr_VERSION=994e5fc10c2aee600ff83991d59a30213f89a3d2 ${RULE}

# rules
ifeq ($(origin HAVE_CCACHE),undefined)
ccache:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
ccache:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
ifeq ($(OPSYS),Darwin)
HAVE_ZLIB ?=
readline: ;
ncurses: ;
tcl: ;
libpng: ;
else
readline:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
ncurses:
ifeq ($(origin HAVE_NCURSES),undefined)
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
	$(MAKE) -C ports/thirdparty/$@ provided
endif
tcl:
	$(MAKE) -j1 -C ports/thirdparty/$@ ${RULE}
libpng:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
endif
ifeq ($(origin HAVE_OPENBLAS),undefined)
openblas:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
openblas:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
ifeq ($(origin HAVE_ZLIB),undefined)
zlib:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
zlib:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
ifeq ($(origin HAVE_HDF5),undefined)
hdf5:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
hdf5:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
gtest:
	# No do-clean rule here.
	$(MAKE) -C ports/thirdparty/$@ do-install
gmock:
	# No do-clean rule here.
	$(MAKE) -C ports/thirdparty/$@ do-install
ifeq ($(origin HAVE_BOOST),undefined)
boost:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
boost:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
samtools:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
ifeq ($(origin HAVE_CMAKE),undefined)
cmake:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
else
cmake: ;
endif
swig:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
hmmer:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
gmap:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
jre:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
sbt:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}

openssl:
	$(MAKE) -C ports/thirdparty/libressl ${RULE}
ifeq ($(origin HAVE_PYTHON),undefined)
python:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
pip:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
else
python:
	# No do-clean rule here.
	$(MAKE) -j1 -C ports/python/virtualenv do-install
pip: ;
endif

numpy:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
cython:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
xmlbuilder:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
jsonschema:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
avro:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
requests:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
iso8601:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
jinja2:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
networkx:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pyparsing:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pydot:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
fabric:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
h5py:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
docopt:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pysam:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
six:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
rdflib:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
rdfextras:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
matplotlib:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
scipy:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
traitlets:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pickleshare:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
appnope:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
decorator:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
gnureadline:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pexpect:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
ipython_genutils:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
path.py:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
ptyprocess:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
simplegeneric:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
paramiko:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
ecdsa:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pycrypto:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
isodate:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
html5lib:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
functools32:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pytz:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
python-dateutil:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
nose:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
cram:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
cycler:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
MarkupSafe:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
tabulate:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
CramUnit:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}

#
blasr_libcpp:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
blasr:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
htslib:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
seqan:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbbam:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
dazzdb:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
daligner:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
damasker:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
dextractor:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbdagcon:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
bam2fastx:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
#
pbcore:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbcommand:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbsmrtpipe:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
falcon_kit:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
FALCON_unzip:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
falcon_polish:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbfalcon:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pypeFLOW:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
ConsensusCore:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
GenomicConsensus:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbreports:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
kineticsTools:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbalign:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbcoretools:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbtranscript:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
unanimity:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbcopper:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
#
pblaa:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
#
pbh5tools:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbbarcode:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
ppa:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
Cogent:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
#
smrtflow:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
trim_isoseq_polyA:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
#
pysiv2:
	$(MAKE) -C ports/pacbio/$@ ${RULE}

# Not part of pacbio developers' software collection
nim:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
modules:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
mash:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
ssw_lib:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
scikit-image:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
pillow:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
dask.array:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
toolz:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
ipython:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
biopython:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
bx-python:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
PuLP:
	$(MAKE) -j1 -C ports/python/$@ ${RULE}
fasta2bam:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
PacBioTestData:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
clean-%:
	$(MAKE) -C ports/pacbio/$* do-clean
distclean-%:
	test -e ports/pacbio/$*     && $(MAKE) -C ports/pacbio/$*     do-distclean || true
	test -e ports/thirdparty/$* && $(MAKE) -C ports/thirdparty/$* do-distclean || true
	test -e ports/python/$*     && $(MAKE) -C ports/python/$*     do-distclean || true
reinstall-%:
	$(MAKE) -C ports/pacbio/$* do-uninstall
	$(MAKE) -C ports/pacbio/$* do-distclean
	$(MAKE) -C ports/pacbio/$* do-install
clean: clean-blasr_libcpp clean-blasr clean-htslib clean-seqan clean-pbbam clean-unanimity clean-dazzdb clean-daligner clean-damasker clean-dextractor clean-pbdagcon clean-bam2fastx clean-pbcore clean-pbcommand clean-pbsmrtpipe clean-falcon_kit clean-pbfalcon clean-pypeFLOW clean-ConsensusCore clean-GenomicConsensus clean-pbreports clean-kineticsTools clean-pbalign clean-pbcoretools clean-pblaa clean-pbh5tools clean-pbbarcode clean-ppa clean-Cogent
distclean: distclean-blasr_libcpp distclean-blasr distclean-htslib distclean-seqan distclean-pbbam distclean-unanimity distclean-dazzdb distclean-daligner distclean-damasker distclean-dextractor distclean-pbdagcon distclean-bam2fastx distclean-pbcore distclean-pbcommand distclean-pbsmrtpipe distclean-falcon_kit distclean-pbfalcon distclean-pypeFLOW distclean-ConsensusCore distclean-GenomicConsensus distclean-pbreports distclean-kineticsTools distclean-pbalign distclean-pbcoretools distclean-pblaa distclean-pbh5tools distclean-pbbarcode distclean-ppa distclean-Cogent
test: PacBioTestData test-pbtranscript
test-pbtranscript: pbtranscript CramUnit
	$(MAKE) -C ports/pacbio/pbtranscript do-test

# extra testing section conflicts with other installation
samtools-1.3.1:         ccache zlib ncurses
samtools-1.3.1:
	$(MAKE) -C ports/thirdparty/$@ ${RULE}
# R (experimental)
Rcpp:   ccache
pbbamr: Rcpp zlib
Rcpp:
	$(MAKE) -C ports/R/$@ ${RULE}
pbbamr:
	$(MAKE) -C ports/pacbio/$@ ${RULE}
pbcommandr:
	$(MAKE) -C ports/pacbio/$@ ${RULE}

.PHONY: ConsensusCore GenomicConsensus MarkupSafe appnope avro biopython blasr boost ccache cmake Cogent cram cycler cython dazzdb daligner damasker dextractor decorator default docopt ecdsa fabric gmap gmock gnureadline gtest hmmer htslib ipython isodate jsonschema kineticsTools libpng matplotlib modules ncurses networkx nim nose numpy openblas openssl paramiko pbalign pbbam unanimity pbchimera pbcommand pbcore pbcoretools pbdagcon pbfalcon pblaa pbreports pexpect pickleshare pip ppa ptyprocess pycrypto pydot pyparsing pypeFLOW pysam python pytz pyxb rdfextras rdflib readline requests samtools scipy seqan simplegeneric six swig tcl traitlets world xmlbuilder zlib pbh5tools tabulate pbbarcode
