//[x]=efs(Emat,vec,q,qd,u,lambda,p,pd,param,paramopt)
A=list('sparse',...
Emat(q,qd,u,lambda,p,pd,param),Ematww,66,20000)
x=lusolve(vec(q,qd,u,lambda,p,pd,param,paramopt),A)
//end
