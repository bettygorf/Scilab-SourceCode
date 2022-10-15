function []=hist3d(f,labels,view)
// hist3d() ---> example
defaults=list(['x','y','z'],[0,%pi/4,%pi/3,xget("white"),2,0.25])
smod=0;first=1-smod;
//gestion de la liste d'appel
[lhs,rhs]=argn(0),
if rhs<=0, write(%io(2),'hist3d(rand(10,10));');
   hist3d(rand(10,10));
   return;end;
enable_r=0
select rhs
case 1 then,[labels,view]=defaults(1:2);enable_r=1
case 2 then,
  select type(labels)
    case 10 then view=defaults(2);enable_r=1
    case 1 then view=labels;[labels]=defaults(1);enable_r=0
    else error('param3d(f,[,legends] [,view])')
  end
end,
//tests de coherence
select type(f)
case 1 then
  [nr,nc]=size(f);
  xx=0:nc; yy=0:nr;
case 15 then
  xx=f(2); yy=f(3);f=f(1); [nr,nc]=size(f);
  if prod(size(xx))<>nc+1 then error(89),end
  if prod(size(yy))<>nr+1 then error(89),end
else error('first argument must be matrix or list (f,x,y)')
end
select prod(size(view))
 case 3 then view(4:6)=[15,2,0.25]
 case 5 then view(6)=0.25
 case 1 then view(2:6)=[%pi/4,%pi/3,15,2,0.25];enable_r=1
end
//grid variables
//--------------
prop=view(6)
d=(1-prop)/2
//
x=matrix(xx,1,nc+1),
if prop<1 then
//  x=ones(1,nc).*.[d,d,1-d,1-d]+(0:nc-1).*.[1 1 1 1];x=[0 x  nc]
  x1=x(1);xn=x(nc+1)
  x=(x(2:nc+1)-x(1:nc)).*.[d,d,1-d,1-d]+x(1:nc).*.[1 1 1 1];x=[x1 x  xn]
  nc=4*nc+2
else
  x1=x(1);xn=x(nc+1)
  x=x(2:nc).*.[1 1 1];x=[x1 x1 x xn xn]
  nc=3*nc+1
end
mnx=mini(x);mxx=maxi(x);xc=(mnx+mxx)/2
//
y=matrix(yy,nr+1,1),
if prop<1 then
  y1=y(1);yn=y(nr+1)
  y=(y(2:nr+1)-y(1:nr)).*.[d;d;1-d;1-d]+y(1:nr).*.[1;1;1;1];y=[y1;y;yn]
  nr=4*nr+2
else
  y1=y(1);yn=y(nr+1)
  y=y(2:nr).*.[1;1;1];y=[y1;y1;y;yn;yn]
  nr=3*nr+1
end
mny=mini(y);mxy=maxi(y);yc=(mny+mxy)/2
x=x-xc*ones(x);y=y-yc*ones(y)
//
xe=[mnx-xc mxx-xc];ye=[mny-yc mxy-yc]
//
//parametres de visualisation initiaux
//------------------------------------
//rotation and projection ; (xr,yr)=PROJ(ROT(theta,phi)*(x,y,f))
//ou  ROT est la matrice de rotation :
//     | ct     -st     0|
// ROT=| cp*st  cp*ct -sp|
//     | sp*st  sp*ct  cp|
//et  PROJ((xr,yr,fr))=(xr,yr)
//
//angles de rotation
theta=view(2),phi=view(3);
st=sin(theta);ct=cos(theta);sp=sin(phi);cp=cos(phi);
//gain
mxf=maxi(0,maxi(f));mnf=mini(0,mini(f))
range=(mxf-mnf);
gain=view(1);
 
if gain=0 then,
  gain=.25*sp*(abs(ye(2)-ye(1))*abs(st)+abs(xe(2)-xe(1))*abs(ct))/range;
  print(6,gain),
end,
f=f*gain;mxf=mxf*gain;mnf=mnf*gain;
if prop<1 then
  f=f.*.[0 0 0 0;0 1 1 0;0 1 1 0;0 0 0 0]
  f=[0*ones(nr-1,1) [0*ones(1,nc-2);f]];f(nr,nc)=0
else
  f=f.*.[0 0 0;0 1 1;0 1 1];f(nr,nc)=0
end
//
//variables utiles
//----------------
//calcul de la suite des indices relatifs a une ligne de la matrice
nl=2 //nombre de lignes visulaisees simultaneement
ind=ones(1,nc-1).*.[1 1 2 2]+((0:nc-2).*.[1 0 0 1]+(1:nc-1).*.[0 1 1 0])*2;
nind=(nc-1)*4
nc2=nl*nc
xsel=[1 2 2 1];ysel=[1 1 2 2];
//
//boucle de localisation
//----------------------
btn=1;
while 0=0,
  //enveloppe convexe
  all=[1;1].*.([xe(xsel)' ye(ysel)']*[ct cp*st;-st cp*ct]);
  all(:,2)=all(:,2)+sp*[mxf*ones(4,1);mnf*ones(4,1)]
  //
  //extrema dans la fenetre
  xmax=maxi(all(:,1));xmin=mini(all(:,1));
  ymax=maxi(all(:,2));ymin=mini(all(:,2));
  dx=0.1*(xmax-xmin)
  dy=0.1*(ymax-ymin)
  xb=[xmin,xmax]
  yb=[ymin,ymax]
   if first=1 then
    //definition  de la fenetre
    plot2d(0,0,0,"010"," ",[xb(1),yb(1),xb(2),yb(2)])
    first=0
  end
  //
 
  //trace des aretes de l'enveloppe convexe
  ksel=[1 2 2 3 3 4 4 1  5 6 6 7 7 8 8 5  1 5 2 6 3 7 4 8];
  if smod=0 then xsegs(all(ksel,1),all(ksel,2)),end
  //
  //definition des points visibles de l'enveloppe convexe
  //  iur (idr) : point en haut (bas) a droite
  //  iul (idl) : point en haut (bas) a gauche
  //  iu1 (id1) : point en haut (bas) et face avant
  //  iub (idb) : point en haut (bas) et face arriere
  [w,ir]=maxi(all(1:4,1))
  i1=modulo(ir,4)+1,
  if all(i1,2)>all(ir,2) then
     i1=modulo(ir+2,4)+1,
     il=modulo(i1+2,4)+1
     ib=modulo(Ir,4)+1
  else
     i1=modulo(ir,4)+1,
     il=modulo(i1,4)+1
     ib=modulo(ir+2,4)+1
  end
  if sp<0 then
     id1=i1;idr=ir;idl=il;idb=ib;
     iu1=i1+4;iur=ir+4;iul=il+4;iub=ib+4;
  else
     iu1=i1;iur=ir;iul=il;iub=ib;
     id1=i1+4;idr=ir+4;idl=il+4;idb=ib+4;
  end
  //
  //le triedre visible
  vis=[all(iu1,:);all(id1,:);all(iu1,:);all(iur,:);all(iu1,:);all(iul,:)]
  //la surface visible de l'enveloppe convexe
  front=[all(iu1,:);all(id1,:);all(idr,:);all(iur,:);..
         all(iu1,:);all(id1,:);all(idl,:);all(iul,:);..
         all(iu1,:);all(iur,:);all(iub,:);all(iul,:)];
  //
  //trace de la surface
  //-------------------
  //
  // choix de l'ordre de parcours
  if btn=1 then
    mm=modulo(iu1-1,4)
    print(6,mm)
    select modulo(iu1-1,4)
    case 0,
     l0=nr;il=-1;ind1=ind(nind:-1:1);ilab=[3,1,2]
    case 1,
     l0=nr;il=-1;ind1=ind;ilab=[3,2,1]
    case 2,
     l0=1;il=1;ind1=ind;ilab=[3,1,2]
    case 3,
     l0=1;il=1;ind1=ind(nind:-1:1);ilab=[3,2,1]
    end
    //trace
    xx(1:2:nc2)=ct*x-st*y(l0)*ones(x)
    yy(1:2:nc2)=cp*(st*x+ct*y(l0)*ones(x))+sp*f(l0,:)
    ff(1:2:nc2)=f(l0,:)
    for l=nr:-1:2
      l0=l0+il
      xx(2:2:nc2)=ct*x-st*y(l0)*ones(x);
      yy(2:2:nc2)=cp*(st*x+ct*y(l0)*ones(x))+sp*f(l0,:);
      ff(2:2:nc2)=f(l0,:)
 
      zer=find([1 1 1 1]*abs(matrix(ff(ind1)',4,nind/4))<%eps);zer=zer';
      pat=2*xget("white")+2-view(4);
      coul=pat*ones(nind/4,1)
      pat=2*xget("white")+2-view(5);
      coul(zer)=pat*ones(zer)
      xfpolys(matrix(xx(ind1),4,nind/4),..
              matrix(yy(ind1),4,nind/4),coul);
      xx(1:2:nc2)=xx(2:2:nc2);
      yy(1:2:nc2)=yy(2:2:nc2);
      ff(1:2:nc2)=ff(2:2:nc2)
    end,
    //
    if smod=0 then
    //trace du triedre visible et des legendes
    xsegs(vis(:,1),vis(:,2));
    for il=1:3
      orig=vis(2*il,:)+0.1*(vis(2*il,:)-vis(1,:))
      xstring(orig(1),orig(2),labels(ilab(il)),0,0);
    end
    end
  end
  //deplacement eventuel
  //--------------------
  //
  if enable_r=0 then return,end
  if smod=1 then return,end
  [btn,xc,yc]=xclick();xy=[xc,yc]';
  if btn<>1 then
    //recherche du sommet de l'enveloppe qui a ete designe
    dist=abs(all-ones(8,1)*xy')*[1;1];
    [m,i]=mini(dist);
    // pas un sommet on quitte
    if abs((all(i,1)-xy(1))/(xmax-xmin))>0.1 then return,end
    if abs((all(i,2)-xy(2))/(ymax-ymin))>0.1 then return,end
    //acquisistion de la nouvelle position choisie pour ce sommet
      [btn,xc,yc]=xclick();xy=[xc,yc]';
    // calcul de la transformation correspondante
    if i>4 then m=mnf,i=i-4,else m=mxf,end;
    ex=xe(xsel(i));ey=ye(ysel(i));
    theta=real(asin( xy(1)/sqrt(ex*ex+ey*ey)))-atan(ex,-ey);
    st=sin(theta);ct=cos(theta);
    //
    u=ex*st+ey*ct;
    phi=real(asin((xy(2))/(sqrt(u*u+m*m)))-atan(u,m));
    sp=sin(phi);cp=cos(phi);
    //
    //on efface l'enveloppe convexe
    xclear();
  end
end;



