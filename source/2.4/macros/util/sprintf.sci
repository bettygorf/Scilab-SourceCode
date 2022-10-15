function buf=sprintf(frmt,varargin)
// sprintf - Emulator of C language sprintf
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
kbuf=1
nv=rhs-1
if type(frmt)<>10 then
  error('argument must be a character string')
end
if prod(size(frmt))<>1 then
  error('argument must be a character string')
end
buf=emptystr()
lfmt=length(frmt)
il=0
count=0 // argument counter
while il<=lfmt do
  [str,flags,width,prec,typemod,conv]=analyse_next_format()
  if size(str,'*')>1 then
    buf(kbuf)=buf(kbuf)+str(1)
    buf=[buf;str(2:$)];kbuf=kbuf+size(str,'*')-1
  else
    buf(kbuf)=buf(kbuf)+str
  end
  if conv<>[] then
    w=varargin(count+1)
//    w=evstr('v'+string(count+1))
    buf(kbuf)=buf(kbuf)+cformat(w,flags,width,prec,typemod,conv)
    count=count+1
  end
end

function str=cformat(v,flags,width,prec,typemod,conv)
scifmt=format()
intf=['d','i','o','u','x','X']
floatf=['f','e','E','g','G']
strf=['c','s']
if width==[] then width=0,end
//if prec==[] then prec=6,end
if or(floatf==conv) then
  if type(v)<>1 then 
    error('argument must be a scalar')
  end
elseif or(intf==conv) then
  if type(v)<>1 then 
    error('argument must be a scalar')
  end
  if int(v)<>v then 
    error('argument must be an integer')
  end
  v=int(v)
end  
mxdgt=16
cc=convstr(conv,'l')
if cc=='d' then
  format('v',mxdgt)
  str=string(v)
  n=length(str)
elseif cc=='i' then
  str=string(v)
elseif cc=='o' then
    if prec==[] then prec=1,end
  if v==0 then
    if prec==0 then
      str=emptystr()
    else
      str=part('0',ones(1,prec))
    end
  else
    str=dec2oct(v)
    n=length(str)
    str=part('0',ones(1,prec-n))+str
    if or(flags=='#') then str='0'+str,end
    if conv=='O' then str=convstr(str,'u'),end
  end
elseif cc=='u' then
  format('v',mxdgt)
  str=string(abs(v))
  n=length(str)
elseif cc=='x'then
  if prec==[] then prec=1,end
  if v==0 then
    if prec==0 then
      str=emptystr()
    else
      str=part('0',ones(1,prec))
    end
  else
    str=dec2hex(v)
    n=length(str)
    str=part('0',ones(1,prec-n))+str
    if or(flags=='#') then str='0x'+str,end
    if conv=='X' then str=convstr(str,'u'),end
  end
elseif cc=='f' then
  if prec==[] then prec=6,end
  format('v',mxdgt)
  fct=10^prec
  v=round(v*fct)/fct
  str=string(abs(v))
  ns=length(str)
  i=1
  if prec>0 then
    while i<=ns&part(str,i)<>'.' then i=i+1,end
    if i>ns then str=str+'.';ns=ns+1;end
    str=str+part('0',ones(1,prec-ns+i))
  end
  if v<0 then str='-'+str,end
elseif cc=='e' then
//  fct=10^prec
  [m,e]=float2me(v)
  if prec==[] then ndgt=6, else ndgt=prec,end //nombre de digit apres le .
  ll=ndgt+3;if ndgt==0 then ll=ll-1,end
  format('v',ll);s=string(abs(m))
  n1=length(s);
  if n1==1&(ndgt>0|or(flags=='#')) then s=s+'.';n1=n1+1;end
  str=s+part('0',ones(1,ll-n1-1))
  s=string(abs(e));if length(s)==1 then s='0'+s;end
  if e>=0 then s='+'+s;else s='-'+s,end;
  str=str+conv+s
  if m<0 then str='-'+str,end
elseif cc=='g' then
  if prec==[] then prec=6,end //prec est le nombre total de digits significatif
  [m,e]=float2me(v)
  if e<>0&e<-4|e>=prec  then //use 'e' format
    ndgt=prec
    ll=ndgt+2;if ndgt==0 then ll=ll-1,end
    format('v',ll);str=string(abs(m))
    n1=length(str);
    if or(flags=='#') then
      if n1==1 then str=str+'.';n1=n1+1;end
      str=str+part('0',ones(1,ll-n1))
    end
    s=string(abs(e));if length(s)==1 then s='0'+s;end
    if e>=0 then s='+'+s;else s='-'+s,end;
    if conv=='g' then str=str+'e'+s,else str=str+'E'+s,end
    if m<0 then str='-'+str,end
  else //use f format
    if e>0 then format('v',prec+2),else format('v',prec+2-e);end
    str=string(v)
  end
elseif cc=='c' then
  str=code2str(v)
elseif cc=='s' then
  if prec==[] then
    str=v
  else
    str=part(v,1:prec)
  end
end      
if scifmt(1)==1 then
  format('v',scifmt(2))
else
  format('e',scifmt(2))
end

nflags=prod(size(flags))
lstr=length(str)
minus='-';plus='+';diese='#';blank=' ';z='0'

//sign
if or(flags==plus) then
  if cc=='d'|cc=='i'|cc=='f'|cc=='g'|cc=='e' then
    if v>=0 then str='+'+str,end
  end
elseif or(flags==blank) then
  if cc=='d'|cc=='i'|cc=='f'|cc=='g'|cc=='e' then
    if v>=0 then str=' '+str,end
  end
end
//alternate output form
if or(flags==diese) then
  if cc=='o' then
  elseif cc=='x' then
  elseif cc=='e' then
  elseif cc=='f' then
    if prec==0 then str=str+'.',end
  end
end

//alignement
padding=' ';
if or(flags==z) then padding='0',end
if or(flags==minus) then 
  if lstr<width then str=str+part(padding,ones(1,width-lstr)),end
else 
  if lstr<width then str=part(padding,ones(1,width-lstr))+str,end
end  

function [str,flags,width,prec,typemod,conv]=analyse_next_format()
//Scan frmt for % escapes and print out the arguments.
str=emptystr();kstr=1
width=[];prec=[],flags=[],typemod=[],conv=[]
il=il+1
if il>lfmt then [il,count]=resume(il,count),end

c=part(frmt,il);
while c<>'%' then
  if c=='\' then
    if part(frmt,il+1)=='n' then str=[str;emptystr()],kstr=kstr+1,end
    il=il+1
  else
    str(kstr)=str(kstr)+c
  end
  il=il+1
  if il>lfmt then break, end
  c=part(frmt,il);
end
if il>lfmt then [il,count]=resume(il,count),end
if part(frmt,il+1)=='%' then 
  str(kstr)=str(kstr)+'%',il=il+1
  [il,count]=resume(il,count)
end

//beginning of a format

//get flags
flags=[]
while il<=lfmt do
  il=il+1;c=part(frmt,il)
  if c=='+'|c=='-'|c==' '|c=='0'|c=='#' then 
    flags=[flags c]
  else
    break
  end
else error('incorrect format')
end

width=[]
if isdigit(c)|c=='*' then
  // get width
  if c=='*' then //from args
    count=count+1
    if count>nv then 
      error('incorrect number of arguments')
    end
    w=evstr('v'+string(count+1))
    if type(w)<>1 then
      error('argument must be a character string')
    end
    if prod(size(w))<>1 then
      error('argument must be a character string')
    end
    width=w
    il=il+1;
    if il>lfmt then error('incorrect format'),end
    c=part(frmt,il)
  else //from format
    width=0
    while isdigit(c) do
      width=10*width+evstr(c)
      il=il+1;
      if il>lfmt then error('incorrect format'),end
      c=part(frmt,il)
    end
  end
end
prec=[]
if c=='.' then
  il=il+1;
  if il>lfmt then error('incorrect format'),end
  c=part(frmt,il)
  //get precision
  if c=='*' then //from args
    count=count+1
    if count>nv then 
      error('incorrect number of arguments')
    end
    w=evstr('v'+string(count+1))
    if type(w)<>1 then
      error('argument must be a character string')
    end
    if prod(size(w))<>1 then
      error('argument must be a character string')
    end
    prec=w
    il=il+1;
    if il>lfmt then error('incorrect format'),end
    c=part(frmt,il)
  elseif isdigit(c) //form format
    prec=0
    while isdigit(c) do
      prec=10*prec+evstr(c)
      il=il+1;
      if il>lfmt then error('incorrect format'),end
      c=part(frmt,il)
    end
  else error('incorrect format')      
  end
end

// get type modifier
typemod=[]
if c=='l'| c=='L'|c=='h' then 
  typemod=c
  il=il+1;
  if il>lfmt then error('incorrect format'),end
  c=part(frmt,il)
end

//get conversion
conv=c
[il,count]=resume(il,count)   


function ok=isdigit(c)
ok=(c=='0'|c=='1'|c=='2'|c=='3'|c=='4'|c=='5'|c=='6'|c=='7'|c=='8'|c=='9')

function str2=d2e(str1,e)
ns=length(str1)
str2=emptystr()
for i=1:ns
  c=part(str1,i)
  if c<>'D' then
    str2=str2+c
  else
    str2=str2+e
  end
end

function [m,e]=float2me(x)
// convert a floating point number x to x=m*10^e with 1<=abs(m)<10
if x==0 then
  m=0;e=0
else
 e=int(log(abs(x))/log(10))
 if e<0 then e=e-1,end  
 m=x*10^(-e)
end

function x=dec2hex(a)
d=[string(0:9) 'a' 'b' 'c' 'd','e','f']
x=emptystr(1)
if abs(a)>(2^31-1) then
  error('dec2hex : argument out of bounds')
end
if a<0 then a=2^32+a,end
if a==0 then x='0',end
while a>0
  a1=int(a/16)
  r=a-16*a1
  x=d(r+1)+x
  a=a1
end
if length(x)==0 then x=d(a),end

function x=dec2oct(a)
d=string(0:7)
x=emptystr(1)
if abs(a)>(2^31-1) then
  error('dec2hex : argument out of bounds')
end
if a<0 then a=2^32+a,end
if a==0 then x='0',end
while a>0
  a1=int(a/8)
  r=a-8*a1
  x=d(r+1)+x
  a=a1
end
if length(x)==0 then x=d(a),end
