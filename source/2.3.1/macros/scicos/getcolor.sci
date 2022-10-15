function c=getcolor(title,cini)
colors=string(1:xget("lastpattern"))
m=prod(size(cini))
//if size(legs,'*')<>m then error(42),end
//cini=maxi(cini,2*ones(cini))
ll=list()
m=prod(size(cini))
for k=1:m
  ll(k)=list('colors',cini(k),colors);
end
c=x_choices(title,ll);




