clear;lines(0);
A=diag([0.9,-2,3]);B=[0;0;1];Sl=syslin('c',A,B,[]);
[ns,nc,U]=st_ility(Sl);
U'*A*U
U'*B
[ns,nc,U]=st_ility(syslin('d',A,B,[]));
U'*A*U
U'*B
