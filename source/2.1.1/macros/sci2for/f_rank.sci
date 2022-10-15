//[stk,nwrk,txt,top]=f_rank(nwrk)
//Cette macro realise la traduction de la primitive scilab rank.
//
//!
txt=[]  
nam='rank'
s2=stk(top-rhs+1)
v=s2(1)
it2=prod(size(v))-1
if it2<>0 then  error(nam+' complex : not implemented'),end

[s2,nwrk,t0]=typconv(s2,nwrk,'1')
n=s2(4);m=s2(5)
if n==m then
  n1=n
  n2=n
else
  n1='min('+addf(n,'1')+','+m+')'
  n2='min('+n+','+m+')'
end
[errn,nwrk]=adderr(nwrk,'echec du calcul du rang')
[s,nwrk,t1]=getwrk(nwrk,'1','1',n1)
[e,nwrk,t2]=getwrk(nwrk,'1','1',m)
[wrk,nwrk,t3]=getwrk(nwrk,'1','1',n)
txt=[t0;t1;t2;t3;
    gencall(['dsvdc',s2(1),n,n,m,s,e,'work',n,'work',m,wrk,'00','ierr']);
    genif('ierr.ne.0',[' ierr='+string(errn);' return'])]
tol=wrk
if rhs==1 then
  nwrk=dclfun(nwrk,'d1mach','1')
  t0=' '+tol+'='+mulf(mulf(mulf('d1mach(4)',m),n),e)
else
  tol1=stk(top)
  t0=' '+tol+'='+mulf(mulf(mulf(tol1(1),m),n),e)
end
[lbl,nwrk]=newlab(nwrk)
tl1=string(10*lbl);
var='ilb'+tl1;
[lbl,nwrk]=newlab(nwrk)
tl2=string(10*lbl);

t1= genif(part(s,1:length(s)-1)+'+'+var+'-1).le.'+tol,' goto '+tl2)
txt=[txt;t0;
     ' do '+tl1+' '+var+' = 0'+','+subf(n2,'1');
     indentfor(t1);part(tl1+'    ',1:6)+' continue';
     ' '+var+'='+n2;
     part(tl2+'    ',1:6)+' continue']
[nwrk]=freewrk(nwrk,e)
[nwrk]=freewrk(nwrk,s)
[nwrk]=freewrk(nwrk,wrk)
stk=list(var,'0','0','1','1')
//end
