function c=getcolor(title,cini)
// Copyright INRIA
colors=string(1:xget("lastpattern"))
[lhs,rhs]=argn(0)
if rhs<2 then cini=xget('pattern'),end
m=size(cini,'*')
ll=list()
for k=1:m
  ll(k)=list('colors',cini(k),colors);
end
c=x_choices(title,ll);




