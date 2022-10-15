clear;lines(0);
integrate('sin(x)','x',0,%pi)
integrate(['if x==0 then 1,';
           'else sin(x)/x,end'],'x',0,%pi)
