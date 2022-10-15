function val=evstr(str)
select type(str)
 case 10 then
    [m,n]=size(str),
    %t1='%t=[',
    for l=1:m,
       t=' ',
       for k=1:n, t=t+str(l,k)+' ',end,
       %t1(l+1)=t,
    end,
    %t1(m+1)=%t1(m+1)+']',
    deff('[%t]=%ev',%t1);
    comp(%ev);
    val=%ev(),
 case 15 then
    sexp=str(2),
    nstr=prod(size(sexp)); %=list();
    for k=1:nstr, %(k)=evstr(sexp(k)),end,
    val=evstr(str(1))
case 1 then
   val=str
else 
   error('waiting for: matrix of strings or list'),
end



