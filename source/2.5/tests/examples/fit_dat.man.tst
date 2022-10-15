clear;lines(0);
deff('y=FF(x)','y=a*(x-b)+c*x.*x')
X=[];Y=[];
a=34;b=12;c=14;for x=0:.1:3, Y=[Y,FF(x)+100*(rand()-.5)];X=[X,x];end
Z=[Y;X];
deff('e=G(p,z)','a=p(1),b=p(2),c=p(3),y=z(1),x=z(2),e=y-FF(x)')
[p,err]=fit_dat(G,[3;5;10],Z)
xset('window',0)
xbasc();
plot2d(X',Y',-1) 
plot2d(X',FF(X)',5,'002')
a=p(1),b=p(2),c=p(3);plot2d(X',FF(X)',12,'002')

a=34;b=12;c=14;
deff('s=DG(p,z)','y=z(1),x=z(2),s=-[x-p(2),-p(1),x*x]')
[p,err]=fit_dat(G,[3;5;10],Z,DG)
xset('window',1)
xbasc();
plot2d(X',Y',-1) 
plot2d(X',FF(X)',5,'002')
a=p(1),b=p(2),c=p(3);plot2d(X',FF(X)',12,'002')
