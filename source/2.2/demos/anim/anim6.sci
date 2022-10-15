function chaina(yt)
[n1,n2]=size(yt);
x=ones(n1/2,n2);
y=ones(n1/2,n2);
x(1,:)=2*r(1)*cos(yt(1,:));
y(1,:)=2*r(1)*sin(yt(1,:));
for i=2:n1/2, 
  x(i,:)=x(i-1,:)+2*r(i)*cos(yt(i,:));
  y(i,:)=y(i-1,:)+2*r(i)*sin(yt(i,:));
end
x=[0*ones(1,n2);x];
y=[0*ones(1,n2);y];
rr=r(1)/(n1+1);
rect=2*[-(n1/2+1),-(n1/2+1),n1/2+1,n1/2+1];
plot2d(0,0,[0],"012"," ",rect);
for j=1:n2,
  xset("wwpc");chaind([x(:,j),y(:,j)],rr,rect);
  xset("wshow");
end

function chaind(p,r,rect)
//draw chain given sequence of points
//!
[n,ign]=size(p);
th=xget("thickness");
xset("thickness",1)
arcs=[ -r ,r,2*r,2*r,0,64*360].*.ones(n,1);
arcs=[ p, 0*ones(n,4)] + arcs;
xarcs(arcs');
xset("thickness",4);
xpolys([p(1:(n-1),1),p(2:n,1)]',[p(1:(n-1),2),p(2:n,2)]',-(1:n));
xset("thickness",th);
