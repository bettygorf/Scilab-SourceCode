function [sl]=ssrand(nout,nin,nstate)
[lhs,rhs]=argn(0)
if rhs=0 then
 rand('unif')
 nout=intrand(1,1,3)+1
 nin=intrand(1,1,3)+1
 nstate=intrand(1,1,5)+1
end
rand('normal')
sl=list('lss',rand(nstate,nstate),rand(nstate,nin),rand(nout,nstate),..
        0*ones(nout,nin),0*ones(nstate,1),'c')



