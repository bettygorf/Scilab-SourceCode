/* Copyright INRIA */

#include "../machine.h"

/** only used to force the linker to load all calelm functions **/

Lapack_contents(x) 
     int x;
{
  if ( x== 1) 
    {
	C2F(dgebak)();
	C2F(dgebal)();
	C2F(dgelq2)();
	C2F(dgelqf)();
	C2F(dgels)();
	C2F(dgeqpf)();
	C2F(dgeqr2)();
	C2F(dgeqrf)();
	C2F(dgerfs)();
	C2F(dgerq2)();
	C2F(dgerqf)();
	C2F(dgetrs)();
	C2F(dggbak)();
	C2F(dggbal)();
	C2F(dlabad)();
	C2F(dlacon)();
	C2F(dlacpy)();
	C2F(dlae2)();
	C2F(dlaev2)();
	C2F(dlaic1)();
	C2F(dlamch)();
	C2F(dlange)();
	C2F(dlansp)();
	C2F(dlanst)();
	C2F(dlantr)();
	C2F(dlapmt)();
	C2F(dlapy2)();
	C2F(dlarf)();
	C2F(dlarfb)();
	C2F(dlarfg)();
	C2F(dlarft)();
	C2F(dlartg)();
	C2F(dlascl)();
	C2F(dlaset)();
	C2F(dlasr)();
	C2F(dlasrt)();
	C2F(dlassq)();
	C2F(dlaswp)();
	C2F(dlatrs)();
	C2F(dlatzm)();
	C2F(dopgtr)();
	C2F(dorg2l)();
	C2F(dorg2r)();
	C2F(dorgqr)();
	C2F(dorgrq)();
	C2F(dorm2r)();
	C2F(dormr2)();
	C2F(dorml2)();
	C2F(dormlq)();
	C2F(dormqr)();
	C2F(dormrq)();
	C2F(dpptrf)();
	C2F(drscl)();
	C2F(dspev)();
	C2F(dspgst)();
	C2F(dspgv)();
	C2F(dsptrd)();
	C2F(dsptrf)();
	C2F(dsteqr)();
	C2F(dsterf)();
	C2F(dtrcon)();
	C2F(dtzrqf)();
	C2F(ilaenv)();
	C2F(lsame)();
	C2F(slamch)();
    }
}
