function []=bode(sl,fmin,fmax,pas,comments)
//!
[lhs,rhs]=argn(0);
//---------------------
pas_def='auto' // default
xbasc()
ilf=0
select type(sl)
case 15 then  // sl,fmin,fmax [,pas] [,comments]
  typ=sl(1)
  if typ<>'lss'&typ<>'r' then
    error(97,1)
  end
if typ=='lss' then
if sl(7)==[] then error('Undefined time domain (sl(7))');end
end
if typ=='r' then
if sl(4)==[] then error('Undefined time domain (sl(4))');end
end
  select rhs
  case 1 then //sl
   comments=' '
   [frq,d,phi]=repfreq(sl);sl=[] 
  case 2 then // sl,frq
   comments=' '
   [frq,d,phi]=repfreq(sl,fmin);fmin=[];sl=[]
  case 3 , //sl,frq,comments ou sl,fmin,fmax
   if type(fmax)==1 then
      comments=' '
      [frq,d,phi]=repfreq(sl,fmin,fmax,pas_def),sl=[]
   else
      comments=fmax
      [frq,d,phi]=repfreq(sl,fmin);fmin=[];sl=[]
   end
  case 4 ,
    if type(pas)==1 then 
      comments=' ',
    else 
      comments=pas;pas=pas_def;
    end,
    [frq,d,phi]=repfreq(sl,fmin,fmax,pas)
  case 5 then,
    [frq,d,phi]=repfreq(sl,fmin,fmax,pas)
  else 
    error('Invalid call: sys,fmin,fmax [,pas] [,com]')
  end;

case 1 then //frq,db,phi [,comments] ou frq, repf [,comments]
  select rhs
  case 2 , //frq,repf
    comments=' '
    [phi,d]=phasemag(fmin);fmin=[]
  case 3 then
    if type(fmax)=1 then
      comments=' '//frq db phi
      d=fmin,fmin=[]
      phi=fmax,fmax=[]
    else
      [phi,d]=phasemag(fmin);fmin=[]
      comments=fmax
     end;
   case 4 then 
     comments=pas;d=fmin;fmin=[];phi=fmax;fmax=[]
   else 
     error('Invalid call: frq,db,phi,[com] or frq,repf,[com]')
   end;
   frq=sl;sl=[];[mn,n]=size(frq);
   if mn<>1 then
      ilf=1;//un vecteur de frequences par reponse
   else
      ilf=0;//un seul vecteur de frequence
   end;
else 
   error('Bode: invalid call')
end;
[mn,n]=size(phi)
//
//Captions
if comments=' ' then
   comments(mn)=' ';
   mnc=0
   hx=0.48
   else
   mnc=mn
   hx=0.43
end;

[ffr,bds]=xgetech();
xmn=mini(frq),xmx=maxi(frq),npx=10
//Magnitude
[ymn,ymx,npy]=graduate(mini(d),maxi(d))
rect=[xmn,ymn,xmx,ymx];axis=[10,npx,10,npy]

xsetech([0,0,1.0,hx*0.95]);
plot2d1("oln",frq',d',-[1,3:mn+1],"011",' ',rect,axis);
xgrid([1,npy],-2,'ln')
xtitle('Magnitude ',' Hz','db');

//phase
ymn=floor((mini(phi)-1)/90)*90
ymx=ceil((maxi(phi)+1)/90)*90
npy=modulo((ymx-ymn)/90-1,10)+1;
//[ymn,ymx,npy]=graduate(mini(phi)-1,maxi(phi)+1)
rect=[xmn,ymn,xmx,ymx];axis=[10,npx,10,npy]
xsetech([0,hx,1.0,hx*0.95]);
plot2d1("oln",frq',phi',-[1,3:mn+1],"011",' ',rect,axis)
xgrid([1,npy],-2,'ln')
xtitle('Phase ',' Hz','degrees');
if mnc>0 then
  xsetech([0,2*hx,1.0,0.1],[0 0 1 1]);
  dash=xget('dashes')
  y0=0.7;dy=-1/3
  x0=0;dx=1/2
  count=0
  for k=1:mnc
    xset('dashes',k-1)
    xsegs([x0;x0+0.08],[y0;y0])
    xstring(x0+0.1,y0,comments(k))
    count=count+1
    y0=y0+dy
    if count==3 then x0=x0+dx;y0=0.7,end
  end
  xset('dashes',dash)
end
xsetech(ffr,bds);
