function o=standard_define(sz,model,label)
//initialize graphic part of the block data structure
[lhs,rhs]=argn(0)
if rhs<3 then label=' ',end
[nin,nout,ncin,ncout]=model(2:5)
if nin>0 then pin(nin,1)=0,else pin=[],end
if nout>0 then pout(nout,1)=0,else pout=[],end
if ncin>0 then pcin(ncin,1)=0,else pcin=[],end
if ncout>0 then pcout(ncout,1)=0,else pcout=[],end
graphics=list([0,0],sz,%t,label,pin,pout,pcin,pcout)
[ln,mc]=where()
o=list('Block',graphics,model,' ',mc(2))
