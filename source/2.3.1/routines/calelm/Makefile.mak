SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/calelm.lib

OBJSC =

OBJSF = coshin.obj arcosh.obj  dad.obj dadd.obj dasum.obj daxpy.obj dcopy.obj ddif.obj \
	ddot.obj dmcopy.obj dmmul.obj dnrm2.obj drot.obj drotg.obj dscal.obj dset.obj dsort.obj \
	dsum.obj dswap.obj dtild.obj dvmul.obj entier.obj franck.obj gdcp2i.obj hilber.obj \
	icopy.obj idamax.obj iset.obj isort.obj iwamax.obj kronc.obj kronr.obj magic.obj \
	mtran.obj pythag.obj  round.obj simple.obj urand.obj wasum.obj watan.obj \
	waxpy.obj wcopy.obj wdiv.obj wdotci.obj wdotcr.obj wlog.obj wmmul.obj wmul.obj \
	wnrm2.obj wrscal.obj wscal.obj wsign.obj wsqrt.obj wswap.obj wvmul.obj dipow.obj \
	ddpow.obj dwpow.obj wdpow.obj wipow.obj wwpow.obj int2db.obj rea2db.obj \
	isoval.obj isova0.obj imcopy.obj dlblks.obj rat.obj lnblnk.obj dmmul1.obj \
	ddpowe.obj dipowe.obj dwpowe.obj wdpowe.obj wipowe.obj wwpowe.obj \
	ddpow1.obj dwpow1.obj wdpow1.obj wwpow1.obj \
	wwdiv.obj wddiv.obj dwdiv.obj ddrdiv.obj wwrdiv.obj dwrdiv.obj wdrdiv.obj\
	ivimp.obj intp.obj cusum.obj cupro.obj cuproi.obj rcsort.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak




