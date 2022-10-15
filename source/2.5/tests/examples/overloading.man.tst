clear;lines(0);
//DISPLAY
deff('[]=%tab_p(l)','disp([['' '';l(3)] [l(2);string(l(4))]])')
tlist('tab',['a','b'],['x';'y'],rand(2,2))

//OPERATOR
deff('x=%c_a_s(a,b)','x=a+string(b)')
's'+1

//FUNCTION
deff('x=%c_sin(a)','x=''sin(''+a+'')''')
sin('2*x')
