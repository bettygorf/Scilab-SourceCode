function t=sci2exp(a,nom)
// sci2exp - convert a variable to an expression
//%SYNTAX
// t=sci2exp(a [,nam])
//%PARAMETERS
//   a  : matrix of scalar or polynomials
//   nam: character string
//   t  : vector of string, contains the expression definition
//%Example
//  a=[1 2;3 4]
//  sci2exp(a,'aa')
//!
[lhs,rhs]=argn(0)
lmax=70;dots='..';
select type(a)
case 1 then
  t=mat2exp(a)
case 2 then
  t=pol2exp(a)
case 10 then
  t=str2exp(a)
case 15 then
  t=list2exp(a)
else
  error('Non implante')
end,
if rhs==2 then
  t(1)=nom+' = '+t(1)
end


function t=str2exp(a)
[m,n]=size(a),
dots='.'+'.'
kk=1;t=[];
for i=1:m
  x=' '
  for j=1:n,
    v=a(i,j);
    nv=length(v)
    y=emptystr()
    for k=1:nv
      vk=part(v,k)
      y=y+vk
      if part(v,k)==''''|part(v,k)=='""' then y=y+vk,end
    end
    y=''''+y+''''
    l=1;
    if length(x(kk))+length(y)<lmax then
      if j=1 then
        x=y
      else
        x(kk)=x(kk)+' , '+y,
      end
    else
      x(kk)=x(kk)+','+dots;
      x(kk+1)=y
      kk=kk+1
    end
  end
  t=[t;x]
end,
if m*n>1 then
  t(1)='['+t(1)
  [nt,mt]=size(t)
  t(nt)=t(nt)+']'
end

function t=mat2exp(a)
if a=[] then t='[]',return,end
[m,n]=size(a),a=string(a)
dots='.'+'.'
t=[];
for i=1:m
  x=emptystr()
  kk=1
  for j=1:n,
    y=a(i,j);
    l=1;
    if length(x(kk))+length(y)<lmax then
      if j=1 then
        x=y
      else
        x(kk)=x(kk)+' , '+y,
      end
    else
      x(kk)=x(kk)+','+dots;
      x(kk+1)=y
      kk=kk+1
    end
  end
  t=[t;x]
end,
if m*n>1 then
  t(1)='['+t(1)
  [nt,mt]=size(t)
  t(nt)=t(nt)+']'
end

function t=pol2exp(a)
[m,n]=size(a),var=' ';lvar=1
var=varn(a),lvar=length(var);
while part(var,lvar)=' ' then lvar=lvar-1,end
var=part(var,1:lvar)
kk=1;t=[];
for i=1:m
  x=' '
  for j=1:n,
    v=a(i,j);d=degree(v);
    v=coeff(v);
    k0=1;while (k0<d+1)&(v(k0))==0 then k0=k0+1,end
    y=emptystr(1)
    l=1;
    for k=k0:(d+1),
      mnm=var
      if k>2 then mnm=mnm+'^'+string(k-1),end
      if v(k)<0 then 
        s=string(v(k))
      elseif v(k)>0
        if k==k0 then
          s=string(v(k)),
        else
          s='+'+string(v(k)),
        end
      elseif k0==d+1
        s='0'
      else
        s=emptystr(1)
      end
      if length(s)<>0 then
        if s=='+1' then
          s='+'+mnm
        elseif s=='-1'
          s='-'+mnm
        elseif k>1 then
          s=s+'*'+mnm
        end
        ls=length(s)
        if length(y(l))+ls <lmax then
          y(l)=y(l)+s
        else
          y(l)=y(l)+dots
          l=l+1
          y(l)=s
        end
      end
    end
    [ny,my]=size(y)
    if length(x(kk))+length(y(1))<lmax then
      if j=1 then
         x=y(1)
      else
         x(kk)=x(kk)+' , '+y(1),
      end
      if ny>1 then x(kk+1:kk+ny-1)=y(2:ny),end
      kk=kk+ny-1
    else
      x(kk)=x(kk)+','+dots;
      x(kk+1:kk+ny)=y
      kk=kk+ny
    end
  end
  t=[t;x]
end,
if m*n>1 then
  t(1)='['+t(1)
  [nt,mt]=size(t)
  t(nt)=t(nt)+']'
end

function t=list2exp(l)
dots='.'+'.';lmax=70
t='list('
n=length(l)
for k=1:n
  lk=l(k)
  sep=',',if k==1 then sep=emptystr(),end
  [nt,mt]=size(t)
  if type(lk)==15 then
    t1=list2exp(lk)
  else
    t1=sci2exp(lk)
  end
  if prod(size(t1))==1&maxi(length(t1))+length(t(nt))<lmax then
    t(nt)=t(nt)+sep+t1
  else
    t(nt)=t(nt)+sep+dots
    t=[t;t1]
  end
end
[nt,mt]=size(t)
t(nt)=t(nt)+')'
