clear;lines(0);
mprintf('For iteration %i,\tResult is:\nalpha=%f",10,0.535)

t=msprintf('For iteration %i, Result is: alpha=%f",10,0.535)

mprintf('The hexadecimal value of %i is %x',123456,123456)

x=1.23456789;
mprintf('!%f!%15f!%.1f!%#.0f!%.13f!',x,x,x,x,x);
x=-341.234567;
mprintf('!%g!%15g!%.1g!%#.0g!%.13g!',x,x,x,x,x);

x=-0.0000023456;
mprintf('!%e!%15e!%.1e!%#.0e!%.13e!',x,x,x,x,x);

u=mopen(TMPDIR+'/foo','w')
t=0:0.1:2*%pi;
for tk=t
 mfprintf(u,'time = %6.3f value = %6.3f\n',tk,sin(tk)) // write a line
end
mclose(u) //close the result file
unix_g('cat '+TMPDIR+'/foo')
