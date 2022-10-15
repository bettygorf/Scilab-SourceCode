//[stk,nwrk,txt,top]=f_exp(nwrk)
//Cette macro realise la traduction de la primitive scilab exp.
//
//La  primitive exp ayant  des interpretation differentes   selon que la
//matrice est carree ou non il peut y  avoir des problemes de traduction
//dans le cas ou le systeme  ne saura pas  reconnaitre si la matrice est
//carree ou non (dimensions correspondant a des  expressions 
//que  l'on ne sait  pas comparer. Il faudrait ajouter une primitive de
//comparaison formelle.
//!
nam='exp' 
txt=[]  
s2=stk(top)
if s2(4)<>s2(5)|(s2(4)=='1'&s2(5)=='1') then
  v=s2(1)
  it2=prod(size(v))-1
  if it2==0 then
    [stk,nwrk,txt,top]=f_gener(nam,nwrk)
  else
     error(nam+' complex is not implemented')
  end
else
  [s2,nwrk,t0]=typconv(s2,nwrk,'1')
  n=s2(4)
  [errn,nwrk]=adderr(nwrk,'exp fails!')
  [out,nwrk,t1]=outname(nwrk,'1',n,n,s2(1))
  [wrk,nwrk,t2]=getwrk(nwrk,'1',mulf(n,addf(mulf('4',n),'5')),'1')
  [iwrk,nwrk,t3]=getwrk(nwrk,'0',mulf('2',n),'1')
  txt=[t0;t1;t2;t3;
      gencall(['dexpm1',n,n,s2(1),out,n,wrk,iwrk,'ierr']);
      genif('ierr.ne.0',[' ierr='+string(errn);' return'])]
  [nwrk]=freewrk(nwrk,wrk)
  [nwrk]=freewrk(nwrk,iwrk)
  stk=list(out,'-1','1',n,n)
end
//end


