x=1;y=1;vs=5;vw=1;
getf('swim.bas');
comp(swim);
comp(dpfun);
comp(popt);
[ts,ps,tps]=optim(swim,0)
popt(ps);
