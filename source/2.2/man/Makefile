SHELL = /bin/sh

include ../Makefile.incl

the-man::
	catman -M Man-Part1 12345678
	catman -M Man-Part1 -w 12345678
	catman -M Man-Part2 12345
	catman -M Man-Part2 -w 12345

world: Manual the-man
	man-scilab.sh

Manual:
	cd LaTeX-doc; $(MAKE) $(MFLAGS) all

distclean::
	cd Man-Part1; $(RM) man*?/?*.[0-9].~ man*?/"#"*
	cd Man-Part2; $(RM) man*?/?*.[0-9].~ man*?/"#"*
	cd LaTeX-doc; $(MAKE) $(MFLAGS) distclean

clean::
	cd Man-Part1; $(RM) man*?/?*.[0-9].~ man*?/"#"*
	cd Man-Part2; $(RM) man*?/?*.[0-9].~ man*?/"#"*
	cd LaTeX-doc; $(MAKE) $(MFLAGS) clean
