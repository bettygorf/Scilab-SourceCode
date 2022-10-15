//
n=23;
ncontr=2;
nf=16;
ng=4;
nn=40;
nnx=100;
tmin=0;

flags=ones(1,2*n);flags(5)=0;flags(18)=0;flags(n+1)=0;
speed=8;
leanangle=0;
heading=0;

exec(path+'/param.sci');
[q0,qd0]=qinit(speed,leanangle,heading);
