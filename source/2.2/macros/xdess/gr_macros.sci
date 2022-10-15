
function []=delete(sd)
 //destruction d'un objet
   xx=locate(1);eps=0.2
   mm=clearmode();
   //recherche de l'objet contenant le point
   for ko=2:ksd;
     obj=sd(ko);
     to='rien';if size(obj)<>0 then to=obj(1);end,
     select to
     case 'ligne' then
       z=obj(2),[nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=ligne(obj,'del');
         end,
       end,
     case 'fligne' then
       z=obj(2),[nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=fligne(obj,'del');
         end,
       end,
     case 'rect' then
       x1=obj(2);x2=obj(3);y1=obj(4);y2=obj(5);
       z=[x1,x1,x2,x2,x1 ; y1,y2,y2,y1,y1];
       [nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=rect(obj,'del');
         end,
       end,
     case 'points' then
       z=obj(2),[nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=points(obj,'del');
         end,
       end,
     case 'cercle' then
       dist=norm(obj(2)-xx,2);
       if abs(dist-obj(3))<eps then sd(ko)=cerc(obj,'del');end,
     case 'fleche' then
       o1=obj(2);o2=obj(3);p1=[o1(1);o2(1)];p2=[o1(2);o2(2)];
       e=norm(xx-p1,2)+norm(xx-p2,2)
       if abs(e-norm(p2-p1))< eps then sd(ko)=fleche(obj,'del');end,
     case 'comm' then
       xxr=xstringl(0,0,obj(3))
       hx=xxr(3);
       hy=xxr(4);
       crit=norm(obj(2)-xx)+norm(obj(2)+[hx;hy]-xx)
       if crit<hx+hy then sd(ko)=comment(obj,'del');end
     end, //fin selec to
   end; //fin for ko ...
modeback(mm);
sd=resume(sd)


function [sd1]=symbs(sd,del)
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then 
	n1=x_choose(symbtb,"Choose a mark");
        dime=evstr(x_dialog("Choose a size","0"));
	sd1=list("symbs",n1,dime);
else 
	n1=sd(2);dime=sd(3)
end
xset("mark",n1,dime);

function [sd1]=dashs(sd,del)
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then 
	n1=x_choose(dash,"Choose a dash style");
	sd1=list("dashs",n1);
else 
	n1=sd(2)
end
xset("dashes",n1);

function [sd1]=patts(sd,del)
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then 
	n1=x_choose(patt,["Choose a pattern "]);
	sd1=list("patts",n1);
else 
	n1=sd(2)
end
xset("pattern",n1);

function [sd1]=rect(sd,del)
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then 
	[x1,y1,x2,y2]=xgetm(d_xrect) 
	sd1=list("rect",x1,x2,y1,y2);
else
	x1=sd(2);x2=sd(3),y1=sd(4),y2=sd(5);
end
d_xrect(x1,y1,x2,y2);
 
function [sd1]=cerc(sd,del)
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then 
	[c1,c2,x1,x2]=xgetm(d_circle);
	x=[x1;x2],c=[c1;c2];r=norm(x-c,2);
	sd1=list("cercle",c,r);
else
	c=sd(2);r=sd(3);
end;
d_circle(c,r);
 
function [sd1]=fleche(sd,del)
[lhs,rhs]=argn(0);sd1=[]
if rhs<=0 then,
	[oi1,oi2,of1,of2]=xgetm(d_arrow);
	o1=[oi1;of1],o2=[oi2;of2];
	sd1=list("fleche",o1,o2);
else
	o1=sd(2),o2=sd(3),
end
d_arrow(o1,o2);
 
function [sd1]=comment(sd,del)
[lhs,rhs]=argn(0),sd1=[];
if rhs<=0 then ,
	[i,z1,z2]=xclick();z=[z1;z2];
	com=x_dialog("Enter string"," ");
	sd1=list("comm",z,com)
else
	z=sd(2);com=sd(3);
end;
xstring(z(1),z(2),com,0,0);
 
function [sd1]=ligne(sd,del)
// polyline 
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then ,
	z=xgetpoly(d_seg);
	if z=[], return;end;
	sd1=list("ligne",z);
else
	z=sd(2);
end;
xpoly(z(1,:)',z(2,:)',"lines")


function [sd1]=fligne(sd,del)
// filled polyline 
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then ,
	z=xgetpoly(d_seg);
	if z=[], return;end;
	mm=clearmode();xpoly(z(1,:)',z(2,:)',"lines");modeback(mm)
	sd1=list("fligne",z);
else
	z=sd(2);
end;
	xfpoly(z(1,:),z(2,:),1);

function [sd1]=curve(sd,del)
// smoothed curve 
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then ,
	z=xgetpoly(d_seg);
	if z=[], return;end
	mm=clearmode();xpoly(z(1,:)',z(2,:)',"lines");modeback(mm)
	[x1,k1]=sort(z(1,:));y1=z(2,k1);z=[x1;y1];
	[n1,n2]=size(z);z=smooth(z(:,n2:-1:1));
	sd1=list("ligne",z);
else
	z=sd(2);
end;
	xpoly(z(1,:)',z(2,:)',"lines");

function [sd1]=points(sd,del)
// polymark 
[lhs,rhs]=argn(0);sd1=[];
if rhs<=0 then ,
	z=xgetpoly(d_point);
	if z=[], return;end;
	sd1=list("point",z);
else
	z=sd(2);
end;
xpoly(z(1,:)',z(2,:)',"marks");

function []=redraw(sd,s_t)
ksd=size(sd)
plot2d(0,0,[-1],s_t," ",sd(2));
xset("clipgrf");
for k=3:ksd,
  obj=sd(k);
  if size(obj)<>0 then
     to=obj(1)
     select to,
      case "rect"    then rect(obj);
      case "cercle"  then cerc(obj);
      case "fleche"  then fleche(obj);
      case "cercle"  then cerc(obj);
      case "comm"    then comment(obj);
      case "ligne"   then ligne(obj);
      case "fligne"  then fligne(obj);
      case "point"   then points(obj);
      case "symbs"   then symbs(obj);
      case "dashs"   then dashs(obj);
      case "patts"   then patts(obj);
     end
  end
end

function [x0,y0,x,y,ibutton]=xgetm(m_m) 
// Object aquisition 
  kpd=driver();
  driver("X11");
  xset("alufunction",6);
  // attente du click 
  [ii,x0,y0]=xclick()
  x=x0;y=y0;
  // suivit de la souris en attendant le button release 
  ibutton=-1
  while ( ibutton==-1) 
   // dessin 
   m_m(x0,y0,x,y);
   rep=xgetmouse();
   ibutton = rep(3)
   m_m(x0,y0,x,y)
   x=rep(1);y=rep(2);
  end
  xset("alufunction",3);
  //m_m(x0,y0,x,y)
  driver(kpd);

function []=d_xrect(x0,yy0,x,y)
  xi=min(x0,x);
  w=abs(x0-x);
  yi=max(yy0,y);
  h=abs(yy0-y);
  xrect(xi,yi,w,h);

function []=d_circle(c1,c2,x1,x2)
  [lhs,rhs]=argn(0);
  if rhs==2 then r=c2;c2=c1(2);c1=c1(1);
  else
	  r=norm([x1-c1;x2-x2],2);
  end
  xarc(c1-r,c2+r,2*r,2*r,0,64*360);

function []=d_arrow(c1,c2,x1,x2)
  [lhs,rhs]=argn(0);
  if rhs==2 then x1=c1(2);c1=c1(1);x2=c2(2);c2=c2(1);end
  xarrows([c1;x1],[c2;x2],2);

function [z]=xgetpoly(m_m) 
// interactive polyline aquisition m_m is 
// used to draw between aquisitions 
  kpd=driver();
  driver("X11");
  // attente du click 
  [ii,x0,y0]=xclick()
  x=x0;y=y0;
  z=[x0;y0];
  ibutton=1
  while ibutton<>0
	ibutton=-1
	xset("alufunction",6);
	while ( ibutton==-1) 
	   // dessin 
	   m_m(x0,y0,x,y);
	   rep=xgetmouse();
	   ibutton = rep(3)
	   m_m(x0,y0,x,y)
	   x=rep(1);y=rep(2);
	end
	xset("alufunction",3);
	if ibutton<>0 then 
		m_m(x0,y0,x,y)
		z=[z,[x;y]]
		x0=x;y0=y;
	end 
  end 
  [nn,ll]=size(z);
  if ll==1 then z=[];end
  driver(kpd);

function []=d_seg(x1,y1,x2,y2)
	xpoly([x1,x2],[y1,y2],"lines");

function []=d_point(x1,y1,x2,y2)
	xpoly([x1,x2],[y1,y2],"marks");







