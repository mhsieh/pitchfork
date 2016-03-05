default:

override PFHOME:=${CURDIR}
-include settings.mk
include ./mk/config.mk
include ./mk/init.mk

UNAME   = uname
ARCH   := $(shell $(UNAME) -m)
OPSYS  := $(shell $(UNAME) -s)
SHELL   = /bin/bash -e
PREFIX ?= deployment

default:
	@echo no default rule
	@echo Please run 'make init' before any other rule.
	@echo "CCACHE_DIR=${CCACHE_DIR}"
	@echo "PREFIX=${PREFIX}"

# Please add dependencies after this line
openssl:          ccache
zlib:             ccache
boost:            ccache
ifeq ($(origin HAVE_PYTHON),undefined)
python:           ccache zlib openssl ncurses readline
else
python:           ccache zlib ncurses readline
endif
readline:         ccache ncurses
samtools:         ccache zlib
cmake:            ccache zlib
ncurses:          ccache
openblas:         ccache
hdf5:             ccache zlib
swig:             ccache python
libpng:           ccache zlib
hmmer:            ccache
gmap:             ccache

pip:              python
cython:           pip
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
gnureadline:      pip
html5lib:         pip
ipython_genutils: pip
iso8601:          pip
isodate:          pip
jinja2:           pip MarkupSafe
networkx:         pip decorator
paramiko:         pip
path.py:          pip
pexpect:          pip
pickleshare:      pip
ptyprocess:       pip
pycrypto:         pip
pyparsing:        pip
pysam:            pip
python-dateutil:  pip
pytz:             pip
pyxb:             pip
requests:         pip
simplegeneric:    pip
six:              pip
traitlets:        pip
xmlbuilder:       pip
nose:             pip
cram:             pip
cycler:           pip
MarkupSafe:       pip

#
ipython:      pip traitlets pickleshare appnope decorator gnureadline pexpect ipython_genutils path.py ptyprocess simplegeneric
cogent:       pip numpy
biopython:    pip
nim:          ccache zlib
tcl:          ccache zlib
modules:      ccache tcl

#
htslib:       ccache zlib
blasr_libcpp: ccache boost hdf5 pbbam
blasr:        ccache blasr_libcpp hdf5 cmake
pbbam:        ccache samtools cmake boost htslib gtest
pbccs:        ccache pbbam htslib cmake boost gtest seqan ConsensusCore2
dazzdb:       ccache
daligner:     ccache dazzdb
pbdagcon:     ccache dazzdb daligner pbbam blasr_libcpp
#
pbcore:           pysam h5py pyxb
pbcoretools:      pbcore pbcommand
pbcommand:        xmlbuilder jsonschema avro requests iso8601 numpy
pbsmrtpipe:       pbcommand jinja2 networkx pbcore pbcommand pyparsing pydot jsonschema xmlbuilder requests fabric
falcon_kit:       networkx
pbfalcon:         falcon_kit pbsmrtpipe pypeFLOW
pbreports:        matplotlib cython numpy h5py pysam jsonschema pbcore pbcommand
kineticsTools:    pbcore pbcommand scipy numpy h5py
pypeFLOW:         rdflib rdfextras
pbalign:          pbcore samtools blasr
pbdoctorb:        docopt pbcore
ConsensusCore:    numpy boost swig cmake
ConsensusCore2:   numpy boost swig cmake
GenomicConsensus: pbcore pbcommand numpy h5py ConsensusCore
#
pblaa:         htslib pbbam seqan pbsparse pbccs ConsensusCore2 pbchimera
pbchimera:     seqan cmake
ppa:           boost cmake pbbam htslib

#
reseq-core: \
       pbsmrtpipe pbalign blasr pbreports GenomicConsensus pbbam pbcoretools pbccs
world: \
       pbccs     blasr            kineticsTools  \
       pbreports GenomicConsensus ConsensusCore2 pbfalcon \
       pbdoctorb ipython          biopython      cogent   \
                 modules          cram           nose     \
       hmmer     gmap

# end of dependencies

# rules
ifeq ($(origin HAVE_CCACHE),undefined)
ccache:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
else
ccache:
	$(MAKE) -j1 -C ports/thirdparty/$@ provided
endif
ifeq ($(OPSYS),Darwin)
HAVE_ZLIB ?=
readline: ;
ncurses: ;
tcl: ;
libpng: ;
else
readline:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
ncurses:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
tcl:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
libpng:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
endif
ifeq ($(origin HAVE_OPENBLAS),undefined)
openblas:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
else
openblas:
	$(MAKE) -j1 -C ports/thirdparty/$@ provided
endif
ifeq ($(origin HAVE_ZLIB),undefined)
zlib:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
else
zlib:
	$(MAKE) -j1 -C ports/thirdparty/$@ provided
endif
ifeq ($(origin HAVE_HDF5),undefined)
hdf5:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
else
hdf5:
	$(MAKE) -j1 -C ports/thirdparty/$@ provided
endif
gtest:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
gmock:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
ifeq ($(origin HAVE_BOOST),undefined)
boost:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
else
boost:
	$(MAKE) -j1 -C ports/thirdparty/$@ provided
endif
samtools:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
ifeq ($(origin HAVE_CMAKE),undefined)
cmake:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
else
cmake: ;
endif
swig:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
hmmer:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
gmap:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install

openssl:
	$(MAKE) -j1 -C ports/thirdparty/libressl do-install
ifeq ($(origin HAVE_PYTHON),undefined)
python:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
pip:
	$(MAKE) -j1 -C ports/python/$@ do-install
else
python:
	$(MAKE) -j1 -C ports/python/virtualenv do-install
pip: ;
endif

numpy:
	$(MAKE) -j1 -C ports/python/$@ do-install
cython:
	$(MAKE) -j1 -C ports/python/$@ do-install
xmlbuilder:
	$(MAKE) -j1 -C ports/python/$@ do-install
jsonschema:
	$(MAKE) -j1 -C ports/python/$@ do-install
avro:
	$(MAKE) -j1 -C ports/python/$@ do-install
requests:
	$(MAKE) -j1 -C ports/python/$@ do-install
iso8601:
	$(MAKE) -j1 -C ports/python/$@ do-install
jinja2:
	$(MAKE) -j1 -C ports/python/$@ do-install
networkx:
	$(MAKE) -j1 -C ports/python/$@ do-install
pyparsing:
	$(MAKE) -j1 -C ports/python/$@ do-install
pydot:
	$(MAKE) -j1 -C ports/python/$@ do-install
fabric:
	$(MAKE) -j1 -C ports/python/$@ do-install
h5py:
	$(MAKE) -j1 -C ports/python/$@ do-install
docopt:
	$(MAKE) -j1 -C ports/python/$@ do-install
pysam:
	$(MAKE) -j1 -C ports/python/$@ do-install
six:
	$(MAKE) -j1 -C ports/python/$@ do-install
rdflib:
	$(MAKE) -j1 -C ports/python/$@ do-install
rdfextras:
	$(MAKE) -j1 -C ports/python/$@ do-install
matplotlib:
	$(MAKE) -j1 -C ports/python/$@ do-install
cogent:
	$(MAKE) -j1 -C ports/python/$@ do-install
scipy:
	$(MAKE) -j1 -C ports/python/$@ do-install
traitlets:
	$(MAKE) -j1 -C ports/python/$@ do-install
pickleshare:
	$(MAKE) -j1 -C ports/python/$@ do-install
appnope:
	$(MAKE) -j1 -C ports/python/$@ do-install
decorator:
	$(MAKE) -j1 -C ports/python/$@ do-install
gnureadline:
	$(MAKE) -j1 -C ports/python/$@ do-install
pexpect:
	$(MAKE) -j1 -C ports/python/$@ do-install
ipython_genutils:
	$(MAKE) -j1 -C ports/python/$@ do-install
path.py:
	$(MAKE) -j1 -C ports/python/$@ do-install
ptyprocess:
	$(MAKE) -j1 -C ports/python/$@ do-install
simplegeneric:
	$(MAKE) -j1 -C ports/python/$@ do-install
paramiko:
	$(MAKE) -j1 -C ports/python/$@ do-install
ecdsa:
	$(MAKE) -j1 -C ports/python/$@ do-install
pycrypto:
	$(MAKE) -j1 -C ports/python/$@ do-install
isodate:
	$(MAKE) -j1 -C ports/python/$@ do-install
html5lib:
	$(MAKE) -j1 -C ports/python/$@ do-install
functools32:
	$(MAKE) -j1 -C ports/python/$@ do-install
pytz:
	$(MAKE) -j1 -C ports/python/$@ do-install
python-dateutil:
	$(MAKE) -j1 -C ports/python/$@ do-install
nose:
	$(MAKE) -j1 -C ports/python/$@ do-install
cram:
	$(MAKE) -j1 -C ports/python/$@ do-install
cycler:
	$(MAKE) -j1 -C ports/python/$@ do-install
MarkupSafe:
	$(MAKE) -j1 -C ports/python/$@ do-install

# Not part of pacbio developers' software collection
ipython:
	$(MAKE) -j1 -C ports/python/$@ do-install
biopython:
	$(MAKE) -j1 -C ports/python/$@ do-install
pyxb:
	$(MAKE) -j1 -C ports/python/$@ do-install
nim:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
modules:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install

#
blasr_libcpp:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
blasr:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
htslib:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
seqan:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbbam:
	$(MAKE) -C ports/pacbio/$@ do-install
pbccs:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
dazzdb:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
daligner:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbdagcon:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
#
pbcore:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbcommand:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbsmrtpipe:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
falcon_kit:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbfalcon:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pypeFLOW:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbdoctorb:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
ConsensusCore:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
ConsensusCore2:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
GenomicConsensus:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbreports:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
kineticsTools:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbalign:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbcoretools:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
#
pbchimera:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pbsparse:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
pblaa:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
#
ppa:
	$(MAKE) -j1 -C ports/pacbio/$@ do-install
