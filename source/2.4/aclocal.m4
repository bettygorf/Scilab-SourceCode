dnl Because this macro is used by AC_PROG_GCC_TRADITIONAL, which must
dnl come early, it is not included in AC_BEFORE checks.
dnl AC_GREP_CPP(PATTERN, PROGRAM, [ACTION-IF-FOUND [,
dnl              ACTION-IF-NOT-FOUND]])
AC_DEFUN(AC_GREP_CPP,
[AC_REQUIRE_CPP()dnl
cat > conftest.$ac_ext <<EOF
[#]line __oline__ "configure"
#include "confdefs.h"
[$2]
EOF
dnl eval is necessary to expand ac_cpp.
dnl Ultrix and Pyramid sh refuse to redirect output of eval, so use subshell.
if (eval "$ac_cpp conftest.$ac_ext") 2>&AC_FD_CC |
dnl Prevent m4 from eating character classes:
changequote(, )dnl
  grep "$1" >/dev/null 2>&1; then
changequote([, ])dnl
  ifelse([$3], , :, [rm -rf conftest*
  $3])
ifelse([$4], , , [else
  rm -rf conftest*
  $4
])dnl
fi
rm -f conftest*
])





AC_DEFUN( AC_CHECK_TCL_VERSION, [
dnl INPUTS :
dnl  $1 : Path where to find the include file (/include f. ex.)
dnl  $2 : Major version number ( 8 f. ex)
dnl  $3 : Minor version number (0 f. ex.)
dnl  $4 : include file name (tcl.h f. ex.)
dnl
dnl OUTPUTS
dnl  TCL_VERSION_OK : 1 if OK, 0 otherwise
dnl  TCL_INC_PATH : include path flag for tcl.h (-I/usr/include f. ex.)
dnl  TCL_LIB : tcl lib name ( tcl8.1 f. ex.)
dnl  TCL_VERSION : ( 8.1 f. ex.)

CHK_TCL_INCLUDE_PATH=$1
CHK_TCL_MAJOR=$2
CHK_TCL_MINOR=$3
CHK_TCL_INC_NAME=$4

echo $ac_n "  Testing version (need $CHK_TCL_MAJOR.$CHK_TCL_MINOR or later)... " $ac_c
AC_GREP_CPP(TCL_VERSION_OK,
[
#include "$CHK_TCL_INCLUDE_PATH/$CHK_TCL_INC_NAME"
#if (TCL_MAJOR_VERSION > $CHK_TCL_MAJOR)
TCL_VERSION_OK
#else
#if ((TCL_MAJOR_VERSION == $CHK_TCL_MAJOR) && (TCL_MINOR_VERSION >= $CHK_TCL_MINOR))
TCL_VERSION_OK
#endif
#endif
],\
TCL_VERSION_OK=1,\
TCL_VERSION_OK=0 )

cat > conftest.$ac_ext <<EOF
#include "confdefs.h"
#include <stdio.h>
#include "$CHK_TCL_INCLUDE_PATH/$CHK_TCL_INC_NAME"
main() {
        FILE *maj = fopen("tclmajor","w");
        FILE *min = fopen("tclminor","w");
        fprintf(maj,"%d",TCL_MAJOR_VERSION);
        fprintf(min,"%d",TCL_MINOR_VERSION);
        fclose(maj);
        fclose(min);
        return 0;
}
EOF
eval $ac_link
if test -s conftest && (./conftest; exit) 2>/dev/null; then
  tclmajor=`cat tclmajor`
  tclminor=`cat tclminor`
  TCL_VERSION=$tclmajor.$tclminor
  echo $ac_n "it's $TCL_VERSION :""$ac_c " 1>&6
  rm -f tclmajor tclminor
else
  echo "$ac_t""can't happen" 1>&6
fi

TCL_INC_PATH=-I$i
TCL_LIB=tcl$TCL_VERSION
if test $TCL_VERSION_OK = 1; then echo "ok"; else echo "oops"; fi

]) dnl End of AC_CHECK_TCL_VERSION













AC_DEFUN( AC_CHECK_TCL_LIB, [
dnl INPUTS :
dnl  $1 : major tcl version number
dnl  $2 : minor tcl version number
dnl OUPUTS :
dnl  TCL_LIB_OK : 1 if link is OK; 0 otherwise
dnl  TCL_LIB_PATH : path flag to link against tcl (-L/usr/lib f. ex.)
dnl  TCL_LIB : flag to link against tcl lib

CHK_TCL_MAJ=$1
CHK_TCL_MIN=$2
TCL_LIB_OK=0

dirs="$USER_TCL_LIB_PATH /lib /usr/lib /usr/lib/tcl /usr/lib/tcl8.0 /usr/lib/tcl8.1 /shlib /shlib/tcl /shlib/tcl8.0 /shlib/tcl8.1 /usr/shlib /shlib/tcl /usr//shlib/tcl8.0 /usr//shlib/tcl8.1 /usr/local/lib /usr/local/lib/tcl /usr/local/lib/tcl8.0 /usr/local/lib/tcl8.1 /usr/local/shlib /usr/X11/lib/tcl /usr/X11/lib/tcl8.0 /usr/X11/lib/tcl8.1  /usr/lib/X11 /usr/lib/X11/tcl /usr/lib/X11/tcl8.0 /usr/lib/X11/tcl8.1 ../lib ../../lib  /usr/local/tcl /usr/tcl /usr/tcl/lib /usr/local/tcl/lib ."
libnames="tcl$CHK_TCL_MAJ.$CHK_TCL_MIN tcl.$CHK_TCL_MAJ.$CHK_TCL_MIN tcl$CHK_TCL_MAJ$CHK_TCL_MIN tcl.$CHK_TCL_MAJ$CHK_TCL_MIN "
for j in $dirs ; do
for n in $libnames; do
if test -r $j/lib$n.a -o -r $j/lib$n.so -o -r $j/lib$n.so.1.0 -o -r $j/lib$n.sl; then 
echo "  found $n in $j"

TCL_LIB_PATH=-L$j

saved_cflags="$CFLAGS"
saved_ldflags="$LDFLAGS"
saved_cppflags="$CPPFLAGS"
CFLAGS=$CFLAGS" $TCL_INC_PATH" 
CPPFLAGS=$CPPFLAGS" $TCL_INC_PATH" 
LDFLAGS=$LDFLAGS" $TCL_LIB_PATH" 

# Check for Tcl lib
echo $ac_n "  ""$ac_c"
AC_CHECK_LIB($n, Tcl_DoOneEvent, TCL_LIB_OK=1,TCL_LIB_OK=0,[$X_LIBS $X_EXTRA_LIBS $TCLTK_LIBS])
CFLAGS="$saved_cflags"
CPPFLAGS="$saved_ldflags"
LDFLAGS="$saved_cppflags"

fi
if test $TCL_LIB_OK = 1; then 
TCL_LIB=$n
break 2;
fi
dnl end of name finding loop
done
dnl end of dir finding loop
done 
])






AC_DEFUN( AC_CHECK_TK_VERSION, [
dnl INPUTS :
dnl  $1 : Path where to find the include file (/include f. ex.)
dnl  $2 : Major version number ( 8 f. ex)
dnl  $3 : Minor version number (0 f. ex.)
dnl  $4 : include file name (tk.h f. ex.)
dnl  ** WARNING : uses TCL_INC_PATH. it must be set correctly **
dnl
dnl OUTPUTS
dnl  TK_VERSION_OK : 1 if OK, 0 otherwise
dnl  TK_INC_PATH : include path flag for tcl.h (-I/usr/include f. ex.)
dnl  TK_LIB : tcl lib name ( tk8.1 f. ex.)
dnl  TK_VERSION : ( 8.1 f. ex.)

CHK_TK_INCLUDE_PATH=$1
CHK_TK_MAJOR=$2
CHK_TK_MINOR=$3
CHK_TK_INC_NAME=$4
saved_cppflags="$CPPFLAGS"
CPPFLAGS="$CPPFLAGS $TCL_INC_PATH $X_CFLAGS"
echo $ac_n "  Testing version (need $CHK_TK_MAJOR.$CHK_TK_MINOR or later)... " $ac_c
AC_GREP_CPP(TK_VERSION_OK,
[
#include "$CHK_TK_INCLUDE_PATH/$CHK_TK_INC_NAME"
#if (TK_MAJOR_VERSION > $CHK_TK_MAJOR)
TK_VERSION_OK
#else
#if ((TK_MAJOR_VERSION == $CHK_TK_MAJOR) && (TK_MINOR_VERSION >= $CHK_TK_MINOR))
TK_VERSION_OK
#endif
#endif
],\
TK_VERSION_OK=1,\
TK_VERSION_OK=0 )

cat > conftest.$ac_ext <<EOF
#include "confdefs.h"
#include <stdio.h>
#include "$CHK_TK_INCLUDE_PATH/$CHK_TK_INC_NAME"
main() {
        FILE *maj = fopen("tkmajor","w");
        FILE *min = fopen("tkminor","w");
        fprintf(maj,"%d",TK_MAJOR_VERSION);
        fprintf(min,"%d",TK_MINOR_VERSION);
        fclose(maj);
        fclose(min);
        return 0;
}
EOF
eval $ac_link
if test -s conftest && (./conftest; exit) 2>/dev/null; then
  tkmajor=`cat tkmajor`
  tkminor=`cat tkminor`
  TK_VERSION=$tkmajor.$tkminor
  echo $ac_n "it's $TK_VERSION :""$ac_c " 1>&6
  rm -f tkmajor tkminor
else
  echo "$ac_t""can't happen" 1>&6
fi

TK_INC_PATH=-I$i
TK_LIB=tk$TK_VERSION
if test $TK_VERSION_OK = 1; then echo "ok"; else echo "oops"; fi
CPPFLAGS=$saved_cppflags
]) dnl End of AC_CHECK_TK_VERSION















AC_DEFUN( AC_CHECK_TCLTK, [
dnl this macro finds and test the tcl/tk files
dnl **** it uses $X_LDFLAGS $X_LIBS  to find X libs  ****
dnl
dnl INPUT : it has no input but uses the following variables
dnl  $X_LDFLAGS $X_LIBS : for X libs
dnl  $TCLTK_LIBS : must contain the (sometimes) optional -ldl link flags an paths
dnl  $USER_TCL_INC_PATH : user specified path where to look for tcl.h
dnl  $USER_TK_INC_PATH : user specified path where to look for tk.h
dnl  $USER_TCL_LIB_PATH : user specified path where to look for libtcl
dnl  $USER_TK_LIB_PATH : user specified path where to look for libtk
dnl
dnl OUPUTS :  the following variables are set
dnl  WITH_TKSCI : =1 if all was OK, 0 otherwise
dnl  TCL_INC_PATH : flag to give to cpp if one wants to include tcl.h
dnl  TK_INC_PATH : flag to give to cpp if one wants to include tk.h
dnl  TCLTK_LIBS : complete line to link tcl/tk with scilab
dnl    it might be something like "-L/usr/lib -ltk8.0 -L/usr/local/lib -ltcl8.0 -ldl"
dnl  TCL_VERSION : version of the found tcl includes and libs
dnl  TK_VERSION : version of the found tk includes and libs
dnl In addition, if the test was OK, the WITH_TK cpp symbol is defined


WITH_TKSCI=0
TCL_LIB_OK=0
# Check for tcl header file
echo "checking for tcl.h"
dirs="$USER_TCL_INC_PATH /include /usr/include /usr/include/tcl /usr/include/tcl8.0 /usr/include/tcl8.1 /usr/local/include /usr/local/include/tcl /usr/local/include/tcl8.0 /usr/local/include/tcl8.1 /usr/X11/include/tcl /usr/X11/include/tcl8.0 /usr/X11/include/tcl8.1  /usr/include/X11 /usr/include/X11/tcl /usr/include/X11/tcl8.0 /usr/include/X11/tcl8.1 ../include ../../include /usr/tcl /usr/local/tcl /usr/local/tcl/include /usr/tcl/include"
for i in $dirs ; do
if test -r $i/tcl.h; then 

echo "  found tcl.h in $i"
AC_CHECK_TCL_VERSION($i,8,0,tcl.h)

TCL_LIB_OK=0;
if test $TCL_VERSION_OK = 1; then
AC_CHECK_TCL_LIB($tclmajor, $tclminor)
fi

if test $TCL_LIB_OK = 1; then 
  TCLTK_LIBS=" $TCL_LIB_PATH -l$TCL_LIB $TCLTK_LIBS"
   break;
fi
fi
done

#perform tk tests if tcl test passed
if test $TCL_LIB_OK = 1; then 

# Check for tk header file
echo "checking for tk.h"
dirs="$USER_TK_INC_PATH  /include /usr/include /usr/include/tk /usr/include/tk8.0 /usr/include/tk8.1 /usr/local/include /usr/local/include/tk /usr/local/include/tk8.0 /usr/local/include/tk8.1 /usr/X11/include/tk /usr/X11/include/tk8.0 /usr/X11/include/tk8.1  /usr/include/X11 /usr/include/X11/tk /usr/include/X11/tk8.0 /usr/include/X11/tk8.1 ../include ../../include /usr/tk /usr/local/tk /usr/local/tk/include /usr/tk/include  /usr/local/tcl /usr/tcl /usr/tcl/include /usr/local/tcl/include"
for i in $dirs ; do
if test -r $i/tk.h; then 

echo "  found tk.h in $i"
AC_CHECK_TK_VERSION($i,8,0,tk.h)
TK_LIB_OK=0;

if test $TK_VERSION_OK = 1; then
dnl Check for tk library file
CHK_TK_MAJ=$tkmajor
CHK_TK_MIN=$tkminor
dirs="$USER_TK_LIB_PATH /lib /usr/lib /usr/lib/tk /usr/lib/tk8.0 /usr/lib/tk8.1 /shlib /shlib/tk /shlib/tk8.0 /shlib/tk8.1 /usr/shlib /shlib/tk /usr//shlib/tk8.0 /usr//shlib/tk8.1 /usr/local/lib /usr/local/lib/tk /usr/local/lib/tk8.0 /usr/local/lib/tk8.1 /usr/local/shlib /usr/X11/lib/tk /usr/X11/lib/tk8.0 /usr/X11/lib/tk8.1  /usr/lib/X11 /usr/lib/X11/tk /usr/lib/X11/tk8.0 /usr/lib/X11/tk8.1 ../lib ../../lib /usr/tk /usr/local/tk /usr/local/tk/lib /usr/tk/lib /usr/local/tcl /usr/tcl /usr/local/tcl/lib /usr/tcl/lib"

libnames="tk$CHK_TK_MAJ.$CHK_TK_MIN tk.$CHK_TK_MAJ.$CHK_TK_MIN tk$CHK_TK_MAJ$CHK_TK_MIN tk.$CHK_TK_MAJ$CHK_TK_MIN"
for j in $dirs ; do
for n in $libnames; do
if test -r $j/lib$n.a -o -r $j/lib$n.so -o -r $j/lib$n.so.1.0 -o -r $j/lib$n.sl; then 
echo "  found $n in $j"

TK_LIB_PATH=-L$j
TK_LIB=$n
saved_cflags="$CFLAGS"
saved_ldflags="$LDFLAGS"
saved_cppflags="$CPPFLAGS"
CFLAGS=$CFLAGS"  $X_CFLAGS $TK_INC_PATH" 
CPPFLAGS=$CPPFLAGS" $TK_INC_PATH" 
LDFLAGS=$LDFLAGS" $X_LDFLAGS $X_LIBS $TK_LIB_PATH" 

# Check for Tk lib
echo $ac_n "  ""$ac_c"
AC_CHECK_LIB($TK_LIB, Tcl_DoOneEvent, TK_LIB_OK=1, TK_LIB_OK=0,[ -lX11 $X_LIBS $X_EXTRA_LIBS $TCLTK_LIBS ])
CFLAGS="$saved_cflags"
CPPFLAGS="$saved_ldflags"
LDFLAGS="$saved_cppflags"

fi
if test $TK_LIB_OK = 1; then break 2; fi
done
done
fi

if test $TK_LIB_OK = 1; then 
  TCLTK_LIBS=" $TK_LIB_PATH -l$TK_LIB $TCLTK_LIBS"
  WITH_TKSCI=1
  break;
fi
fi
done


# end of tk test
fi

])
