 function [X]=dscr_lyap2(E,A)
// Copyright INRIA
// Generated by lmitool on Tue Jan 31 21:58:20 MET 1995
 Mbound = 1e3;
 abstol = 1e-10;
 nu = 10;
 maxiters = 100;
 reltol = 1e-10;
 options=[Mbound,abstol,nu,maxiters,reltol];
 /////////////////DO NOT REMOVE THIS LINE
 X_init=zeros(A)
 /////////////////DO NOT REMOVE THIS LINE
 XLIST0=list(X_init)
 XLIST=lmisolver(XLIST0,dscr_lyap2_eval,options)
 [X]=XLIST(:)
 /////////////////EVALUATION FUNCTION////////////////////////////
 function [LME,LMI,OBJ]=dscr_lyap2_eval(XLIST)
 [X]=XLIST(:)
 /////////////////DO NOT REMOVE THIS LINE
 LME=E'*X-X'*E
 LMI=list(-A'*X-X'*A-eye,E'*X)
 OBJ=[]
