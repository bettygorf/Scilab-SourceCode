//[stk,nwrk,txt,top]=%c2for(nwrk)
//
//!
nrc=evstr(op(3))
if op(2)=23 then
  ncc=1
elseif op(2)=27 then
  ncc=nrc;nrc=1;
else
  ncc=evstr(op(4))
end
nc='0';typ=0
top1=top-nrc*ncc
for k=1:ncc
  sk=stk(top1+k)
  typ=maxi(typ,evstr(sk(3)))
  nc=addf(nc,sk(5))
end
nl='0'
for l=1:nrc
 sk=stk(top1+(l-1)*ncc+1)
 typ=maxi(typ,evstr(sk(3)))
 nl=addf(nl,sk(4))
end
typ=string(typ)
 
[out,nwrk,txt]=outname(nwrk,typ,nl,nc)
lout=length(out)
//
rpos='1'
for l=1:nrc
  cpos='0';
  for k=1:ncc
    sk=stk(top1+k+(l-1)*ncc)
    if part(out,lout)==')' then
      o1=part(out,1:lout-1)+'+'+addf(mulf(cpos,nl),rpos)+')'
    else
      o1=out+'('+rpos+','+addf(cpos,'1')+')'
    end
    n1=sk(5)
    m1=sk(4)
    txt=[txt;gencall(['dmcopy',sk(1),n1,o1,nl,n1,m1])];
    cpos=addf(n1,cpos)
  end
  rpos=addf(m1,rpos)
end
stk=list(out,'-1',typ,nl,nc)
top=top-nrc*ncc+1
 
//end


