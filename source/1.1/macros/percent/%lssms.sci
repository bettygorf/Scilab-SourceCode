function [s]=%lssms(s1,d2)
// s=s1*gain
//!
// origin s. steer inria 1987
// SISO case FD
[a1,b1,c1,d1,x1,dom1]=s1(2:7);
[n2,m2]=size(D2);
if prod(size(s1))==1 then
 if n2==1 then D=D1*D2; [A1,B1*D2]; s=list('lss',a1,b1*d2,c1,D,x1,dom1);return;end
 if m2==1 then s=list('lss',a1,b1,d2*c1,d2*d1,x1,dom1);return;end   //Transpose
 [Q,M]=fullrf(D2);[n2,mq]=size(Q);
 if mq==1 then s=Q*list('lss',a1,b1*M,c1,d1*M,x1,dom1);return;end   //Transpose
 w=s1; for k=2:mq, w=sysdiag(w,s1);end
 s=w*M;s=Q*s;return;
end
D=D1*D2; [A1,B1*D2]; s=list('lss',a1,b1*d2,c1,D,x1,dom1);

