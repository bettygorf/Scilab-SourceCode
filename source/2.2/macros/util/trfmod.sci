function h=trfmod(h,job)
// hm=trfmod(h [,job])
// To visualize the pole-zero structure of a SISO transfer function h 
//     job='p' : visualization of polynomials (default)
//     job='f' : visualization of natural frequencies and damping
//
//!


typ=type(h)
//-compat next row added for list/tlist compatibility
if typ==15 then typ=16,end
if typ==16&h(1)=='r' then
  if size(h(2))<>[1 1] then
    error(' SISO plant only')
  end
  flag='r'
elseif typ==16&h(1)=='lss' then
  if size(h(5))<>[1 1] then
    error('SISO plant only')
  end
  flag='lss'
  den=real(poly(h(2),'s'))
  na=degree(den)
  c=h(4)
  [m,i]=maxi(abs(c))
  ci=c(i)
  t=eye(h(2))*ci;t(i,:)=[-c(1:i-1), 1, -c(i+1:na)]
  al=h(2)*t;
  t=eye(h(2))/ci;t(i,:)=[c(1:i-1)/ci, 1, c(i+1:na)/ci]
  al=t*al;ai=al(:,i),
  b=t*h(3)
  al(:,i)=ai+b
  num=-(real(poly(al,'s'))-den)*ci
  h=tlist('r',num,den,h(7))+h(5);
else
  error('waiting for a transfer function as argument ')
end
 
 
//
format('v',15)
[lhs,rhs]=argn(0)
if rhs==1 then job='p',end
//
if type(h(2))==1 then h(2)=poly(h(2),varn(h(3)),'c'),end
if type(h(3))==1 then h(3)=poly(h(3),varn(h(2)),'c'),end
 
var=varn(h(2)),nv=length(var);
while part(var,nv)==' ' then nv=nv-1,end;var=part(var,1:nv);
 
fnum=polfact(h(2))
fden=polfact(h(3))
g=coeff(fnum(1))/coeff(fden(1))
nn=prod(size(fnum))
nd=prod(size(fden))
//
num=[]
for in=2:nn
  p=fnum(in)
  if job=='p' then
    num=[num;pol2str(p)]
  else
    if degree(p)==2 then
      p=coeff(p)
      omeg=sqrt(p(1))
      xsi=p(2)/(2*omeg)
      num=[num;string(omeg)+'    '+string(xsi)]
    else
      num=[num;string(-coeff(p,0))]
    end
  end
end
//
den=[];
for id=2:nd
  p=fden(id)
  if job=='p' then
    den=[den;pol2str(p)]
  else
    if degree(p)==2 then
      p=coeff(p)
      omeg=sqrt(p(1))
      xsi=p(2)/(2*omeg)
      den=[den;string(omeg)+'    '+string(xsi)]
    else
      den=[den;string(-coeff(p,0))]
    end
  end
end
 
txt=['Gain :';string(g);'Numerator :';num;'Denominator : ';den]
 
id=[]
if job=='p' then
  tit=['  Irreducible Factors        ';
       '  of transfer function (click below)  ']
else
  tit=['  Irreducible Factors               ';
       '  of transfer function              ';
       '  natural frequency and damping factor (click below) ']
end
while id=[] then
  t=x_dialog(tit,txt)
  id=find(t=='Denominator : ')
end
txt=t;
 
tgain=txt(2)
tnum=txt(4:id-1)
tden=txt(id+1:prod(size(txt)))
execstr(var+'=poly(0,'''+var+''')')
num=1
for in=1:prod(size(tnum))
  txt=tnum(in)
  if length(txt)==0 then txt=' ',end
  if job=='p' then
    t=' ';
    for k=1:length(txt),
      tk=part(txt,k),
      if tk<>' ' then t=t+tk,end
    end
    f=1;if t<>' ' then f=evstr(t),end
  else
    if txt==part(' ',1:length(txt)) then
      f=1
    else
      f=evstr(txt)
      select prod(size(f))
      case 1 then
        f=poly(f,var)
      case 2 then
        f=poly([f(1)*f(1), 2*f(1)*f(2),1],var,'c')
      else error('incorrect answer...')
      end
    end
  end
  num=num*f
end
//
den=1
for id=1:prod(size(tden))
  txt=tden(id);
  if length(txt)==0 then txt=' ',end
  if job=='p' then
    t=' ';
    for k=1:length(txt),
      tk=part(txt,k),
      if tk<>' ' then t=t+tk,end
    end
    f=1;if t<>' ' then f=evstr(t),end
  else
    if txt==part(' ',1:length(txt)) then
      f=1
    else
      f=evstr(txt)
      select prod(size(f))
      case 1 then
        f=poly(f,var)
      case 2 then
        f=poly([f(1)*f(1), 2*f(1)*f(2),1],var,'c')
      else error('incorrect answer...')
      end
    end
  end
  den=den*f
end
x=evstr(tgain)/coeff(den,degree(den))
h(2)=num*x
h(3)=den/coeff(den,degree(den))
format(10)
if flag='lss' then h=tf2ss(h),end



