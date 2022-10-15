function []=nyquist(sl,fmin,fmax,pas,comments)
// Nyquist plot
//!
[lhs,rhs]=argn(0);
pas_def='auto' //valeur du pas par defaut
//---------------------
//xbasc()
ilf=0
typ=type(sl)
//-compat next line added for list/tlist compatibility
if typ==15 then typ=16,end
select typ
case 16 then  // sl,fmin,fmax [,pas] [,comments]
  typ=sl(1);typ=typ(1);
  if typ<>'lss'&typ<>'r' then
    error(97,1)
  end
  select rhs
  case 1 then //sl
   comments=' '
   [frq,repf]=repfreq(sl);sl=[] 
  case 2 then // sl,frq
   comments=' '
   [frq,repf]=repfreq(sl,fmin);fmin=[];sl=[]
  case 3 , //sl,frq,comments ou sl,fmin,fmax
   if type(fmax)==1 then
      comments=' '
      [frq,repf]=repfreq(sl,fmin,fmax,pas_def),sl=[]
   else
      comments=fmax
      [frq,repf]=repfreq(sl,fmin);fmin=[];sl=[]
   end
  case 4 ,
    if type(pas)==1 then 
      comments=' ',
    else 
      comments=pas;pas=pas_def
    end,
    [frq,repf]=repfreq(sl,fmin,fmax,pas)
  case 5 then,
    [frq,repf]=repfreq(sl,fmin,fmax,pas)
  else 
    error('invalid call: sys,fmin,fmax [,pas] [,com]')
  end;
case 1 then //frq,db,phi [,comments] ou frq, repf [,comments]
  select rhs
  case 2 , //frq,repf
    comments=' '
    repf=fmin;fmin=[]
  case 3 then
    if type(fmax)=1 then
      comments=' '//frq db phi
      repf=exp(log(10)*fmin/20 + %pi*%i/180*fmax);
      fmin=[]; fmax=[]  
    else
      repf=fmin;fmin=[]
      comments=fmax
     end;
   case 4 then 
     repf=exp(log(10)*fmin/20 + %pi*%i/180*fmax);
     comments=pas;
     fmin=[];fmax=[]
   else 
     error('invalid call: frq,db,phi,[com] or frq,repf,[com]')
   end;
   frq=sl;sl=[];[mn,n]=size(frq);
   if mn<>1 then
      ilf=1;//un vecteur de frequences par reponse
   else
      ilf=0;//un seul vecteur de frequence
   end;
else 
   error('Nyquist: invalid call')
end;

[mn,n]=size(repf)
//
if comments=' ' then
   comments(mn)=' ';
   mnc=1
else
   mnc=mn+1
end;
//
//trace d
repi=imag(repf);repf=real(repf)
//
mnx=mini(repf);
mny=mini(repi);
mxx=maxi(repf);
mxy=maxi(repi);
[mnx,mxx,npx]=graduate(mnx,mxx)
[mny,mxy,npy]=graduate(mny,mxy)
rect=[mnx,mny,mxx,mxy]
axis=[5 npx 5 npy]
if mnc==1 then
  plot2d(repf',repi',(1:mn),"011",' ',rect,axis);
else
 plot2d(repf',repi',(1:mn),"111",strcat(comments,'@'),rect,axis);
end
xgrid();
xgeti=xget("mark");
xset("mark",2,xgeti(2));
xset("clipgrf");
kk=1;p0=[repf(:,kk) repi(:,kk)];ks=1;d=0;
dx=rect(3)-rect(1)
dy=rect(4)-rect(2)
dx2=dx^2;dy2=dy^2

while kk<n
  kk=kk+1
  d=d+mini(((repf(:,kk-1)-repf(:,kk))^2)/dx2+((repi(:,kk-1)-repi(:,kk))^2)/dy2)
  if d>0.001 then
  if mini(abs(frq(:,ks(prod(size(ks))))-frq(:,kk))./frq(:,kk))>0.2 then
   ks=[ks kk]
   d=0
  end
  end
end
kf=1
for k=1:mn,
    xnumb(repf(k,ks),repi(k,ks),frq(kf,ks),0);
    xpoly(repf(k,ks),repi(k,ks),'marks',0);
  kf=kf+ilf
end;

xset("mark",xgeti(1),xgeti(2));
xpoly([rect(1),rect(3)],[0,0],'lines');
xpoly([0,0],[rect(2),rect(4)],'lines');
t=(0:0.1:2*%pi)';
//plot2d(sin(t),cos(t),[(mn+1) -mnc],'100','Unit Circle')
xclip();
xtitle('Nyquist plot ','Re(h(2i*pi*f))','Im(h(2i*pi*f))');
