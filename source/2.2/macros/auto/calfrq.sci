function [frq,bnds]=calfrq(h,fmin,fmax)
//!
k=0.005 //distance relative mini entre deux pt dans le plan de nyquist
tol=0.001 //tolerance pour test des imaginaires purs

//-compat type(h)<>15 retained for list/tlist compatibility

if type(h)<>15&type(h)<>16 then 
  error('first arg. to calfrq : waiting for syslin list'),
end
if h(1)<>'lss'&h(1)<>'r' then 
  error('first arg. to calfrq : waiting for syslin list'),
end
if h(1)='lss' then
  h=ss2tf(h)
end
[m,n]=size(h(2))
if  n<>1 then  
  error('SIMO system only!')
end
dom=h(4)
select dom
  case 'd' then dom=1
   case [] then error(96,1)
end;
//
deff('[f]=%sel(r,fmin,fmax,dom,tol)',['f=[],';
  'if prod(size(r))==0 then return,end';
  'if dom==''c'' then';
  '  f=imag(r(find((abs(real(r))<=tol*abs(r))&(imag(r)>=0))))';
  '  if f<>[] then  f=f(find((f>fmin)&(f<fmax)));end';
  'else ';
  '  f=r(find( ((abs(abs(r)-ones(r)))<=tol)&(imag(r)>=0)))';
  '  if f<>[] then ';
  '    f=atan(imag(f),real(f));nf=prod(size(f))';
  '    for k=1:nf ,';
  '      kk=int((fmax-f(k))/(2*%pi))+1;';
  '      f=[f;f(1:nf)+2*%pi*kk*ones(nf,1)];';
  '    end;';
  '    f=f(find((f>fmin)&(f<fmax)))';
  '  end';
  'end']);comp(%sel)

//
denh=h(3);numh=h(2)
l10=log(10)'

if dom='c' then
  c=2*%pi
else
  c=2*%pi*dom
end
sing=[];zers=[]
fmin=c*fmin,fmax=c*fmax
for i=1:m
  sing=[sing;%sel(roots(denh(i)),fmin,fmax,dom,tol)]
  zers=[zers;%sel(roots(numh(i)),fmin,fmax,dom,tol)]
end
pp=sort([sing' zers']);npp=prod(size(pp));
if npp>0 then
  pp=pp(npp:-1:1)
  f1=fmin;xt=[]
  for i=1:npp
    fp=pp(i)*0.9
    if fp>fmin then
      xt=[xt ,exp(l10*((log(f1)/l10):0.005:(log(fp)/l10))) fp]
    end
    f1=pp(i)*1.1
  end
  if f1<fmax then
    xt=[xt ,exp(l10*((log(f1)/l10):0.005:(log(fmax)/l10))) fmax]
  end
else
  xt=[exp(l10*((log(fmin)/l10):0.005:(log(fmax)/l10))) fmax]
end
if dom='c' then 
  rf=freq(h(2),h(3),%i*xt);
else
  rf=freq(h(2),h(3),exp(%i*xt));
end
//
xmin=mini(real(rf));xmax=maxi(real(rf))
ymin=mini(imag(rf));ymax=maxi(imag(rf))

bnds=[xmin xmax ymin ymax]
dx=xmax-xmin;dy=ymax-ymin
if dx==0 then dx=1,end
if dy==0 then dy=1,end

if pp<>[] then
  frqs=[fmin real(matrix([0.999*pp;1.001*pp],2*prod(size(pp)),1)') fmax]
else
  frqs=[fmin fmax]
end
nfrq=prod(size(frqs))
//
frq=[]
i=1,
pas=frqs(1)/100
while i<nfrq
  f0=frqs(i);fmax=frqs(i+1)
  while f0==fmax do
    i=i+2
    f=frqs(i);fmax=frqs(i+1)
  end
  frq=[frq,f0]

  f=mini(f0+pas,fmax),
  if dom='c' then //cas continu
    while f0<fmax
      rf0=freq(h(2),h(3),(%i*f0))
      rfd=(freq(h(2),h(3),%i*(f0+pas/100))-rf0)/(pas/100);
      rfp=rf0+pas*rfd
      rfc=freq(h(2),h(3),%i*f);
      e=maxi([abs(imag(rfp-rfc))/dy;abs(real(rfp-rfc))/dx])
      pasmin=f*0.000001
      if (e>k&pas/2>pasmin) then
        pas=pas/2;f=mini(f0+pas,fmax)
      elseif e<k/2 then
        pas=2*pas
        frq=[frq,f]
        f0=f;f=mini(f0+pas,fmax),
      else
        frq=[frq,f]
        f0=f;f=mini(f0+pas,fmax),
      end
    end
  else  //cas discret
   while f0<fmax
      rfd=(freq(h(2),h(3),exp(%i*(f0+pas/100)))-freq(h(2),h(3),..
                                                exp(%i*f0)))/(pas/100);
      rfp=freq(h(2),h(3),exp(%i*f0))+pas*rfd
      rfc=freq(h(2),h(3),exp(%i*f));
      e=maxi([abs(imag(rfp-rfc))/dy;abs(real(rfp-rfc))/dx])
      if (e>2*k) then
        pasmin=f*0.0001
        if pas/2>pasmin then
          pas=pas/2;f=mini(f0+pas,fmax)
        else
          frq=[frq,f]
          f0=f;f=mini(f+pas,fmax),
        end
      elseif e<k/2 then
        pas=2*pas
        frq=[frq,f]
        f0=f;f=mini(f+pas,fmax),
      else
        frq=[frq,f]
        f0=f;f=mini(f+pas,fmax),
      end
    end
  end
  i=i+2
end
frq(prod(size(frq)))=fmax
frq=frq/c

