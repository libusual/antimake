
PACKAGE_NAME = antimake
PACKAGE_VERSION = 1.0

dist_doc_DATA = antimake.txt
dist_pkgdata_SCRIPTS = antimake.mk antigen.sh install-sh
dist_pkgdata_DATA = amext-libusual.mk amext-modes.mk amext-cxx.mk
dist_aclocal_DATA = m4/antimake.m4

EXTRA_DIST = Makefile

include antimake.mk

