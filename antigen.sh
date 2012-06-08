#! /bin/sh

# usage: antigen.sh [aclocal flags]

#
# autogen for non-automake trees
#
# autotools generation (autoreconf) # is generally broken if automake
# is not used.  This script tries to fix problems:
#
# - it installs files: config.sub, config.guess, install-sh
# - it installs ltmain.sh, if LT_INIT or *LIBTOOL macro is used
# - any arguments are given to aclocal
#

set -e

# default programs
ACLOCAL=${ACLOCAL:-aclocal}
AUTOCONF=${AUTOCONF:-autoconf}
AUTOHEADER=${AUTOHEADER:-autoheader}

# detect first glibtoolize then libtoolize
if test "x$LIBTOOLIZE" = "x"; then
  LIBTOOLIZE=glibtoolize
  which $LIBTOOLIZE >/dev/null 2>&1 \
    || LIBTOOLIZE=libtoolize
fi

# 
# Workarounds for libtoolize randomness - it does not update
# the files if they exist, except it requires install-sh.
#
rm -f config.guess config.sub install-sh ltmain.sh libtool

# find install-sh
for d in \
  "`dirname $0`" \
  "`dirname $0`"/../share/antimake \
  /usr/share/antimake \
  /usr/share/libusual \
  /usr/share/libtool/config \
  /usr/share/automake-*
do
  if test -f "$d/install-sh"; then
    cp -p "$d/install-sh" .
    break
  fi
done
test -f install-sh || { echo "$0: Cannot find install-sh"; exit 1; }

# run libtoolize to get autoconf files
if ${LIBTOOLIZE} --help | grep "[-][-]install" > /dev/null; then
  ${LIBTOOLIZE} -i -f -q -c
else
  ${LIBTOOLIZE} -c
fi

# drop ltmain.sh if libtool is not used
grep -E 'LT_INIT|LIBTOOL' configure.ac > /dev/null \
  || rm -f ltmain.sh

# Now generate configure & config.h
${ACLOCAL} "$@"

# do we need to run autoheader?
grep AC_CONFIG_HEADER configure.ac > /dev/null \
  && ${AUTOHEADER}

# finally run autoconf
${AUTOCONF}

# clean junk
rm -rf autom4te.* aclocal*

