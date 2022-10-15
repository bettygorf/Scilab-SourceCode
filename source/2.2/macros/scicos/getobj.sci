function [k,wh]=getobj(objs,pt)
n=size(objs)
wh=[];
x=pt(1);y=pt(2)
data=[]
k=[]
for i=2:n
  o=objs(i)
  if o(1)=='Block' then
    graphics=o(2)
    [orig,sz]=graphics(1:2)
    data=[(orig(1)-x)*(orig(1)+sz(1)-x),(orig(2)-y)*(orig(2)+sz(2)-y)]
    if data(1)<0&data(2)<0 then k=i,break,end
  elseif o(1)=='Link' then
    [frect1,frect]=xgetech();
    eps=0.01*min(abs(frect(3)-frect(1)),abs(frect(4)-frect(2)))
    xx=o(2);yy=o(3);
    x=x;y=y;
    n=prod(size(xx))
    t=((yy(1:n-1)-yy(2:n))*x+(xx(2:n)-xx(1:n-1))*y+..
	                  xx(1:n-1).*yy(2:n)-xx(2:n).*yy(1:n-1))...
			  ./sqrt((xx(2:n)-xx(1:n-1))^2+..
			  (yy(2:n)-yy(1:n-1))^2)  
    l=find(abs(t)<eps)
    for j=1:prod(size(l))
      lj=l(j)
      if (x-xx(lj))*(x-xx(lj+1))<0 then wh=lj;k=i,break,end
      if (y-yy(lj))*(y-yy(lj+1))<0 then wh=lj;k=i,break,end
    end
  elseif o(1)=='Text' then
    graphics=o(2)
    [orig,sz]=graphics(1:2)
    data=[(orig(1)-x)*(orig(1)+sz(1)-x),(orig(2)-y)*(orig(2)+sz(2)-y)]
    if data(1)<0&data(2)<0 then k=i,break,end
  end
end

