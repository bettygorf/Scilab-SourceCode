function [stk,txt,ilst,vnms,vtps,nwrk]=exp2for(lst,ilst,vnms,vtps,nwrk)
//
//!
nlst=size(lst)
top=0
stk=list()
txt=[]
ilst=ilst-1
cmod=0;
nwrk3=nwrk(3)
nwrk6=nwrk(6)
//
ok=%t
while ilst<nlst&ok then
  lhs=1
  ilst=ilst+1
  op=lst(ilst)
  if type(op)=10 then
    //write(6,'exp2f '+op(1)+'   '+op(2))//,pause
    select op(1)
    case '0' then
 
    case '2' then //stackg
      if whereis(op(2))==[] then
        [stk,top,vnms,vtps]=get2f(op(2),stk,top,vnms,vtps)
      else //appel des macros
        [stk,nwrk,t1,top]=func2f(op,stk,nwrk)
        txt=[txt;t1]
        ilst=ilst+1
      end
    case '3' then //string
      [stk,top]=str2f(op(2),stk)
    case '4' then //matrice vide
      top=top+1
      stk(top)=list('[]','0','?','0','0')
    case '5' then //allops
      t1=[]
      iop=evstr(op(2))
      top1=top
      execstr('[stkr,nwrk,t1,top]=%'+ops(iop,2)+'2for(nwrk)')
      for ktp=top:top1,ss=stk(top);nwrk=freewrk(nwrk,ss(1));end
      stk(top)=stkr
      txt=[txt;t1]
    case '6' then //num
      [stk,top]=num2f(op(2),stk)
    case '20' then //functions
        [stk,nwrk,t1,top]=func2f(op,stk,nwrk)
        txt=[txt;t1]
    else
      ok=%f
    end
  else
    ok=%f
  end
end
//
 
used='0';for k=nwrk(2), used=addf(used,k(1)),end
iused='0';for k=nwrk(5), iused=addf(iused,k(1)),end
 
 
if used<>'0' then
  n3=prod(size(nwrk3))
  k=n3+1;ok=n3>0;delta=' '
  while ok then
   k=k-1
   delta=subf(used,nwrk3(k))
   ok=part(delta,1)<>'-' &k>1
  end
  if part(delta,1)<>'-' then   nwrk(3)=[nwrk3,used];end
end
if iused<>'0' then
  n6=prod(size(nwrk6))
  k=n6+1;ok=n6>0;delta=' '
  while ok then
   k=k-1
   delta=subf(iused,nwrk6(k))
   ok=part(delta,1)<>'-' &k>1
  end
  if part(delta,1)<>'-' then   nwrk(6)=[nwrk6,iused];end
end
nwrk(1)=1;nwrk(2)=[]
nwrk(4)=1;nwrk(5)=[]



