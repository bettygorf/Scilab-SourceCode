function [x,f,lagr,info]=linpro(x0,p,c,d,ci,cs,mi,modo,imp)
[lhs,rhs]=argn(0)
if rhs=8 then imp=0,end,
n=maxi(size(p))
[x,f,lagr,info]=quapro(x0,0*ones(n,n),p,c,d,ci,cs,mi,modo,imp)

