function [newmacro]=makemacro(p)
   n=size(p);
   num=mulf(makestr(p(1)),'1');
   for k=2:n,
      new=mulf(makestr(p(k)),'s^'+string(k-1));
      num=addf(num,new);
   end,
   text='p='+num;
   deff('<p>=newmacro(t)',text),


function [str]=makestr(p)
   n=degree(p)+1,
   c=coeff(p),
   str=string(c(1)),
   x=part(varn(p),1),
   xstar=x+'^',
   for k=2:n, 
      ck=c(k), 
      if ck<>0 then,
      str=addf(str,mulf(string(c(k)),(xstar+string(k-1))));
      end;
   end,
