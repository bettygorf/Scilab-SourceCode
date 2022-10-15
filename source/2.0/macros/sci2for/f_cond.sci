//[stk,nwrk,txt,top]=f_cond(nwrk)
//Cette macro realise la traduction de la primitive scilab cond.
//
//!
txt=[]  
nam='cond'
s2=stk(top)
v=s2(1)
it2=prod(size(v))-1
if it2<>0 then  error(nam+' complex --> not implemented'),end

[s2,nwrk,t0]=typconv(s2,nwrk,'1')
n=s2(4);m=s2(5)
if n==m then
  n1=n
  n2=n
else
  n1='min('+addf(n,'1')+','+m+')'
  n2='min('+n+','+m+')'
end
[errn,nwrk]=adderr(nwrk,'Computation of conditioning fails')
[s,nwrk,t1]=getwrk(nwrk,'1','1',n1)
[e,nwrk,t2]=getwrk(nwrk,'1','1',m)
[wrk,nwrk,t3]=getwrk(nwrk,'1','1',n)
txt=[t0;t1;t2;t3;
    gencall(['dsvdc',s2(1),n,n,m,s,e,'work',n,'work',m,wrk,..
                                                 n,wrk,'00','ierr']);
    genif('ierr.ne.0',[' ierr='+string(errn);' return'])]
out=e+'/'+part(e,1:length(e)-1)+'+'+n2+'-1)'
[nwrk]=freewrk(nwrk,e)
[nwrk]=freewrk(nwrk,s)
[nwrk]=freewrk(nwrk,wrk)

stk=list(out,'0','1','1','1')
//end
