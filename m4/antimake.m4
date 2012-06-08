
dnl
dnl  AMK_INIT: Generate initial makefile
dnl

AC_DEFUN([AC_ANTIMAKE_INIT], [

dnl If building separately from srcdir, write top-level makefile
if test "$srcdir" != "."; then
  echo "include $srcdir/Makefile" > Makefile
fi

dnl Package-specific data
AC_SUBST([pkgdatadir], ['${datarootdir}'/${PACKAGE_TARNAME}])

dnl Additional directories
AC_SUBST([pkgconfigdir], ['${libdir}/pkgconfig'])
AC_SUBST([aclocaldir], ['${datarootdir}/aclocal'])

dnl Generic system type
AC_MSG_CHECKING([target host type])
xhost="$host_alias"
if test "x$xhost" = "x"; then
  xhost=`uname -s`
fi
case "$xhost" in
*mingw* | *pw32* | *MINGW*)
   PORTNAME=win32;;
*) PORTNAME=unix ;;
esac
AC_SUBST(PORTNAME)
AC_MSG_RESULT([$PORTNAME])

])

AC_DEFUN([AC_ANTIMAKE_PROGS], [

AC_PROG_CC_STDC
AC_PROG_CPP
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_EGREP
AC_PROG_AWK

dnl AC_PROG_MKDIR_P and AC_PROG_SED are from newer autotools
m4_ifdef([AC_PROG_MKDIR_P], [
  AC_PROG_MKDIR_P
], [
  MKDIR_P="mkdir -p"
  AC_SUBST(MKDIR_P)
])
m4_ifdef([AC_PROG_SED], [
  AC_PROG_SED
], [
  SED="sed"
  AC_SUBST(SED)
])

AC_CHECK_TOOL([STRIP], [strip])
AC_CHECK_TOOL([RANLIB], [ranlib], [true])

AC_CHECK_TOOL([AR], [ar])
ARFLAGS=rcu
AC_SUBST(ARFLAGS)

BININSTALL="$INSTALL"

dnl Check if linker supports -Wl,--as-needed
if test "$GCC" = "yes"; then
  old_LDFLAGS="$LDFLAGS"
  LDFLAGS="$LDFLAGS -Wl,--as-needed"
  AC_MSG_CHECKING([whether linker supports --as-needed])
  AC_LINK_IFELSE([AC_LANG_SOURCE([int main(void) { return 0; }])],
    [AC_MSG_RESULT([yes])],
    [AC_MSG_RESULT([no])
     LDFLAGS="$old_LDFLAGS"])
fi

dnl Check if compiler supports gcc-style dependencies
AC_MSG_CHECKING([whether compiler supports dependency generation])
old_CFLAGS="$CFLAGS"
HAVE_CC_DEPFLAG=no
DEPFLAG=""
for flg in '-Wp,-MMD,' '-Wp,-MD,'; do
  CFLAGS="$flg,conftest.d"
  AC_COMPILE_IFELSE([AC_LANG_SOURCE([void foo(void){}])],
     [WFLAGS="$WFLAGS $f"])
  if test "$HAVE_CC_DEPFLAG" = "yes"; then
    DEPFLAG="$flg"
    break
  fi
done
rm -f conftest.d
CFLAGS="$old_CFLAGS"
AC_MSG_RESULT([$HAVE_CC_DEPFLAG])
AC_SUBST(HAVE_CC_DEPFLAG)
AC_SUBST(DEPFLAG)

WFLAGS="-Wall"
AC_SUBST(WFLAGS)

])

