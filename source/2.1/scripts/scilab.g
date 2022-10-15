#!/bin/sh
# Warning : some old versions of sh dont allow inline function definitions
# like do_scilex()... . In this case use a system V sh (sh5)
# Set the SCI environment variable
SCI="SCILAB_DIRECTORY"
MYMANPATH=
CCOMPILER="Ccompiler"
FCOMPILER="Fcompiler"
#############################################################################
#                                                                           #
#                       DO NOT MODIFY BELOW THIS LINE                       #
#                                                                           #
#############################################################################
export SCI
VERSION="SCILAB_VERSION"
export VERSION
SCIMANPATH=$SCI/man/Man-Part1:$SCI/man/Man-Part2
export SCIMANPATH
MANPATH=$MYMANPATH:$SCIMANPATH
export MANPATH

do_scilex()
{
    PATH=$PATH:$SCI:$SCI/util
    export PATH
    XAPPLRESDIR=$SCI/X11_defaults
    export XAPPLRESDIR
    tty -s && stty kill '^U' intr '^C' erase '^H' quit '^\' eof '^D' susp '^Z'
    $SCI/bin/scilex $* 
}

do_geci_scilex()
{
    PATH=$PATH:$SCI:$SCI/util
    export PATH
    XAPPLRESDIR=$SCI/X11_defaults
    export XAPPLRESDIR
    tty -s && stty kill '^U' intr '^C' erase '^H' quit '^\' eof '^D' susp '^Z'
    $SCI/bin/geci -local $SCI/bin/scilex $* 
}

do_help()
{
echo "Usage  :"
echo     "	scilab [ -ns -nw -display display]"
echo     "	scilab -help <key>"
echo     "	scilab -xhelp [ -display display]"
echo     "	scilab -k <key>"
echo     "	scilab -link <objects>"
echo     "	scilab -macro <macro-name>"
}

do_xman()
{
        x="Xman*manualFontNormal:-misc-fixed-medium-r-normal--*-130-*-*-c-*-iso8859-1"
        y="Xman*manualFontBold:-adobe-times-bold-r-normal--*-100-*-*-p-*-iso8859-1"
        z="Xman*manualFontItalic:-adobe-times-medium-i-normal--*-100-*-*-p-*-iso8859-1"
	xman -xrm $x -xrm $y -xrm $z -bothshown -notopbox $*  &
}

do_mank()
{
    man -k $* 
}


do_man()
{
    man  $* 
}

do_man_mips()
{
	MAN1=$SCI/man/Man-Part1/
	MAN2=$SCI/man/Man-Part2/
	if  grep $1 $MAN1/whatis  > /dev/null
	then 
		/usr/ucb/man -P $MAN1 $1
	else 
		if  grep $1 $MAN2/whatis > /dev/null
	then 
		/usr/ucb/man -P $MAN2 $1
	else 
		echo No manual entry for $1
	fi 
	fi 
}

do_mank_mips()
{
    grep $1 $SCI/man/Man-Part1/whatis
    grep $1  $SCI/man/Man-Part2/whatis
}


do_mank_hp()
{
    grep $1 $SCI/man/Man-Part1/whatis
    grep $1  $SCI/man/Man-Part2/whatis
}

do_compile()
{
	umask 002
	rm -f report
	name=`basename $1 .sci`
	echo generating $name.bin
	echo "%u=file('open','$name.bin','unknown','unformatted');predef();\
	      getf('$name.sci','c');save(%u),file('close',%u);quit"\
	      | $SCI/bin/scilex -ns -nw | sed 1,/--\>/d 1>report 2>&1
	if (grep error report 1> /dev/null  2>&1);
	then cat report;echo " " 
	   echo see `pwd`/report for more informations
	   grep libok report>/dev/null; 
	else rm -f report;
	fi
	umask 022
	exit 0
}

do_lib()
{
	umask 002
	rm -f report
	echo "%u=file('open','$2/lib','unknown','unformatted');$1=lib('$2/');\
	      save(%u,$1);file('close',%u);quit"\
	      | $SCI/bin/scilex -ns -nw |sed 1,/--\>/d 1>report 2>&1
	if (grep error report 1> /dev/null  2>&1);
	then cat report;echo " " 
		echo see `pwd`/report for more informations
		grep libok report>/dev/null; 
	else rm -f report;
	fi
	umask 022
	exit 0
}

do_print() 
{
	if [ "P$PRINTER" = "P" ]	
	then  $SCI/bin/Blpr " " $1  | lpr 
	else  $SCI/bin/Blpr " " $1  | lpr -P$PRINTER
	fi
	rm -f $1 
}

case $# in
    0)
	do_geci_scilex &
        ;;
    1)
        case $1 in
             -ns)
		do_scilex $* &
		;;
	     -nw)	
		do_geci_scilex $*
		;;
	     -help)
		do_man scilab
		;;
             -link|-macro|-k)
		do_help
                 ;;
	     -xhelp)
                shift
		do_xman 
		;;
             *)
		do_help
                ;;
        esac
        ;;
    2)
        case $1 in
             -ns)
                case $2 in 
                   -nw)
                      do_scilex $*
                      ;;
                   *)
                      do_scilex $* &
                      ;;
                esac
		;;
	     -nw)
		do_geci_scilex $* 
		;;
             -display)
		do_geci_scilex $*
		;;
            -help)
		do_man $2
                ;;
            -xhelp)
		do_xman
                ;;
            -comp)
		do_compile $2
                ;;
            -print)
		do_print $2
                ;;
	    -k)
		do_mank $2
		;;
            -link)
                shift
		$SCI/bin/scilink $SCI $*
                ;;
            -macro)
		$SCI/bin/minfopr $SCI $2
		;;
            *)
		do_help
                ;;
        esac
        ;;
    3)
        case $1 in
            -lib)
		do_lib $2 $3
                ;;
            *)
		do_help
                ;;
        esac
        ;;
    *)
        case $1 in
            -link)
                shift
		$SCI/bin/scilink $SCI $*
                ;;
	    -xhelp)
		shift
		do_xman $*
		;;
            *)
		do_help
                ;;
        esac
        ;;
esac

