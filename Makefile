
PACKAGE_NAME = antimake
PACKAGE_VERSION = 1.0

dist_doc_DATA = antimake.txt
dist_pkgdata_SCRIPTS = antimake.mk
dist_pkgdata_DATA =

EXTRA_DIST = Makefile

include antimake.mk

