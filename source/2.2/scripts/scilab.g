#!/bin/SCILABGS
# Warning : some old versions of sh dont allow inline function definitions
# like do_scilex()... . In this case use a system V sh (sh5)
# Set the SCI environment variable if not already set
if test "$SCI" = ""; then
  SCI="SCILAB_DIRECTORY"
fi
PRINTERS="lp:LaserHP:SalleBal:LaserLabo|labo:Secretariat:ColorPS"
#############################################################################
#                                                                           #
#                       DO NOT MODIFY BELOW THIS LINE                       #
#                                                                           #
#############################################################################
export SCI
export PRINTERS
VERSION="SCILAB_VERSION"
export VERSION

do_scilex()
{
    PATH=$PATH:$SCI:$SCI/util
    export PATH
    XAPPLRESDIR=$SCI/X11_defaults
    export XAPPLRESDIR
    XLESSHELPFILE=$SCI/X11_defaults/xless.help
    export XLESSHELPFILE
    NETHELPDIR=$SCI/X11_defaults
    export NETHELPDIR
    tty -s && stty kill '^U' intr '^C' erase '^H' quit '^\' eof '^D' susp '^Z'
    $SCI/bin/scilex $* 
}

do_geci_scilex()
{
    PATH=$PATH:$SCI:$SCI/util
    export PATH
    XAPPLRESDIR=$SCI/X11_defaults
    export XAPPLRESDIR
    XLESSHELPFILE=$SCI/X11_defaults/xless.help
    export XLESSHELPFILE
    NETHELPDIR=$SCI/X11_defaults
    export NETHELPDIR
    tty -s && stty kill '^U' intr '^C' erase '^H' quit '^\' eof '^D' susp '^Z'
    $SCI/bin/geci -local $SCI/bin/scilex $* 
}

do_help()
{
echo "Usage  :"
echo     "	scilab [-ns -nw -display display]"
echo     "	scilab -help <key>"
echo     "	scilab -k <key>"
echo     "	scilab -link <objects>"
echo     "	scilab -function <function-name>"
echo     "	scilab -print_p file printer"
echo     "	scilab -print_l file printer"
echo     "	scilab -save_p file format"
echo     "	scilab -save_l file format"
}

do_mank()
{
	f1=`grep -i $1 $SCI/man/Man-Part1/whatis 2> /dev/null`
	f2=`grep -i $1 $SCI/man/Man-Part2/whatis 2> /dev/null`
	if  test -n "$f1$f2" 
	then
		grep -i $1 $SCI/man/Man-Part1/whatis 2> /dev/null
		grep -i $1 $SCI/man/Man-Part2/whatis 2> /dev/null
	else
		echo $1: nothing appropriate
	fi
}

do_man()
{
	MAN=$SCI/man
	f=`ls $MAN/*/cat*/$1.* 2> /dev/null`
	if  test -n "$f"
	then 
		cat $f
	else
		echo No manual entry for $1
	fi 
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
	$SCI/bin/BEpsf $1 $2 
	lpr -P$3 $2.eps
	rm -f $2 $2.eps

}

do_save() 
{
	case $3 in 
          Postscript)
		$SCI/bin/BEpsf $1 $2 
          	 ;;
          Postscript-Latex)
		$SCI/bin/Blatexpr $1 1.0 1.0 $2 
	   	;;
	  Xfig)
		case $1 in
		-portrait)
			mv $2 $2.fig
		;;
		-landscape)
			sed -e "2s/Portrait/Landscape/" $2 >$2.fig
			rm -f $2
		;;
		esac
           	;;
	esac
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
		do_man scilab|more
		;;
             -link|-function|-k)
		do_help
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
		do_man $2|more
                ;;
            -comp)
		do_compile $2
                ;;
	    -k)
		do_mank $2
		;;
            -link)
                shift
		$SCI/bin/scilink $SCI $*
                ;;
            -function)
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
            -print_l)
                do_print -landscape $2 $3
                ;;
            -print_p)
                do_print -portrait $2 $3
                ;;
            -save_l)
                do_save -landscape $2 $3
                ;;
            -save_p)
                do_save -portrait $2 $3
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
            *)
		do_help
                ;;
        esac
        ;;
esac
