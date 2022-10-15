clear;lines(0);
u=file('open','results','unknown') //open the result file
t=0:0.1:2*%pi;
for tk=t
 fprintf(u,'time = %6.3f value = %6.3f',tk,sin(tk)) // write a line
end
file('close',u) //close the result file
