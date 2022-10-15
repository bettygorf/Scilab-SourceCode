function []=gainplot(sl,fmin,fmax,pas,comments)
//!
[lhs,rhs]=argn(0);
//---------------------
pas_def='auto' // default
//
ilf=0
flag=type(sl);
if flag==15 then flag=16;end
select flag
case 16 then  // sl,fmin,fmax [,pas] [,comments]
  typ=sl(1);typ=typ(1);
  if typ<>'lss'&typ<>'r' then
    error(97,1)
  end
  sl1=sl(1);
  if sl1(1)='r' then dom=sl(4),else dom=sl(7),end
  if dom==[] then error(96,1),end
  if dom=='d' then dom=1;end
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
      comments=pas;pas=pas_def
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
    [phi,d]=phasemag(fmin),fmin=[]
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
     error('inputs:frq,db,phi,[com] or frq,repf,[com]')
   end;
   frq=sl;sl=[];[mn,n]=size(frq);
   if mn<>1 then
      ilf=1;//un vecteur de frequences par reponse
   else
      ilf=0;//un seul vecteur de frequence
   end;
else 
   error('gainplot: invalid plot')
end;
[mn,n]=size(phi)
//
//Captions
if comments=' ' then
   comments(mn)=' ';
   mnc=0
  strf='011'
else
   mnc=mn
  strf='111'
end;

xmn=mini(frq),xmx=maxi(frq),npx=10
//Magnitude
[ymn,ymx,npy]=graduate(mini(d),maxi(d))
rect=[xmn,ymn,xmx,ymx];axis=[10,npx,10,npy]
if ilf==0 then
     	plot2d1("oln",frq',d',[1,3:mn+1],strf,strcat(comments,'@'),rect,axis);
	xgrid()
else
     	plot2d1("gln",frq',d',[1,3:mn+1],strf,strcat(comments,'@'),rect,axis);
	xgrid()
end
xtitle(' ','Hz','db');
