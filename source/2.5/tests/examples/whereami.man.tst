clear;lines(0);
deff('y=test(a)',['y=sin(a)+1';
                  'y=t1(y)';
                  'y=y+1'])
deff('y=t1(y)',['y=y^2';'whereami()'])
test(1)
