alfa=15;
beta=alfa*alfa;
gamma=2;

  g    = 9.8;
  ro   = 28/360*%pi*2;
  kapa = 17/360*%pi*2;
  v1 = .8;
  v2 = sin(ro)/cos(kapa)*v1;
  d  = v1*(cos(ro)+sin(ro)*tan(kapa));
  di = v1/2*(cos(ro)+sin(ro)*tan(kapa));
  r1 = .3;
  r4 = .3;
  b2 = v1/2;
  b4 = v2/2;
  k = %pi-ro+kapa;
//  delta=0.05;
  delta=0;
 
// rear wheel

  m1 =.5;
  Ir1= 1/2*m1*r1**2;
  In1= 1/4*m1*r1**2;

// front wheel

  m4 =.5;
  Ir4= 1/2*m4*r4**2;
  In4= 1/4*m4*r4**2;
  
// frame;
  m2 =10*v1;
  Ir2=m2/2*0;
  In2=b2*m2;  

//handlebars;

  m3 =10*v2;
  Ir3=m3/2*0;
  In3=b4*m3;

param=[r1,m1,m2,m3,m4,Ir1,Ir2,Ir3,Ir4,In1,In2,In3,In4,g,d,b2,b4,v1,v2,delta];

