function [frq,db,phi]=repfreq(sys,fmin,fmax,pas)
pas_def='auto';
l10=log(10);
[lhs,rhs]=argn(0)
//discretization 
if type(sys)<>15 then  error(97,1),end;
if sys(1)='r' then dom=sys(4),else dom=sys(7),end
if dom==[]|dom==0 then error(96,1),end
if dom=='d' then dom=1;end

select  rhs
case 1 then
  pas=pas_def
  fmin=1.d-3
  if dom=='c' then fmax=1.d3; else fmax=1/(2*dom),end
case 2 then
  frq=fmin
case 3 then
  pas=pas_def
case 4 then ,
else error('calling sequences: sys,fmin,fmax [,pas] or sys,frq')
end;
if rhs<>2 then
  if type(pas)==1 then
    frq=[exp(l10*((log(fmin)/l10):pas:(log(fmax)/l10))) fmax];
  else
    frq=calfrq(sys,fmin,fmax)
  end
end
//
typ=sys(1)
select typ
case 'r' then
  [n,d]=sys(2:3),
  [mn,nn]=size(n)
  if nn<>1 then error(95,1),end
  if dom='c' then 
    db=freq(n,d,2*%pi*%i*frq),
  else 
    db=freq(n,d,exp(2*%pi*%i*dom*frq)),
  end;
case 'lss' then
  [a,b,c,d,x0]=sys(2:6),
  [mn,nn]=size(b)
  if nn<>1 then error(95,1),end
  if dom='c' then 
    db=freq(a,b,c,d,2*%pi*%i*frq)
  else 
    db=freq(a,b,c,d,exp(2*%pi*%i*dom*frq))
  end;
else error(97,1),
end;
//representation
select lhs
case 3 then
  phi=phasemag(db);
  db=20*log(abs(db))/log(10),// amplitude (db)
case 1 then
  frq=db
end;



