function [stk,txt,top]=sci_eig()
// Copyright INRIA
txt=[]
if rhs==1 then
  if lhs==1 then
    stk=list('spec'+'('+stk(top)(1)+')','0',stk(top)(3),'1','?')
  else
    //eig is called with to lhs arguments. Get their names
    [v,d]=lhsvarsnames()
    txt=lhsargs([d,v])+'=bdiag('+stk(top)(1)+'+0*%i,1/%eps)'
    sz=stk(top)(3)
    //eig output variable are already defined in txt, set expr_type to '-2' 
    //for both
    stk=list(list('?','-2',sz,sz,'?'),list('?','-2',sz,sz,'?'))
  end
else // more than one input argument (option or generalized eigen values?)
  if stk(top)(5)=='10' then  //option
    write(logfile,'Eig : '''+stk(top)(1)+''' option not translated')
    top=top-1
    if lhs==1 then
      stk=list('spec'+'('+stk(top)(1)+')','0',stk(top)(3),'1','?')
    else
      [v,d]=lhsvarsnames()
      txt=lhsargs([d,v])+'=bdiag('+stk(top)(1)+'+0*%i,1/%eps)'
      sz=stk(top)(3)
      stk=list(list('?','-2',sz,sz,'?'),list('?','-2',sz,sz,'?'))
    end
    return
  end
  if stk(top)(5)<>'1' then
    txt='Eig with 2 rhs args: generalized eigen assumed. Check '
    write(logfile,'Warning: '+txt)
    txt='//'+txt
  end  
  if lhs==1 then
    al=gettempvar()
    be=gettempvar()
    V=lhsvarsnames()
    txt=[txt;
        lhsargs([al,be,V])+' = gspec'+rhsargs([stk(top-1)(1),stk(top)(1)])+';']
    stk=list(' ','-2','0','0','0')
  else
    al=gettempvar(1)
    be=gettempvar(2)
    [V,D]=lhsvarsnames()
    txt=[txt;
        lhsargs([al,be,V])+' = gspec'+rhsargs([stk(top-1)(1),stk(top)(1)])+';'
        D+' = '+al+'./'+be+';']
    stk=list(list(' ','-2','0','0','0'),list(' ','-2','0','0','0'))
  end
end    


