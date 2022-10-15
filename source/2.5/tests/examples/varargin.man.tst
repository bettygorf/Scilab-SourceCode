clear;lines(0);
deff('exampl(a,varargin)',['[lhs,rhs]=argn(0)'
                          'if rhs>=1 then disp(varargin),end'])
exampl(1)
exampl()
exampl(1,2,3)
l=list('a',%s,%t);
exampl(1,l(2:3))
