clear;lines(0);
//Example 1 :
  s=poly(0,'s')
  h=syslin('c',(s^2+2*0.9*10*s+100)/(s^2+2*0.3*10.1*s+102.01))
  nyquist(h,0.01,100,'(s^2+2*0.9*10*s+100)/(s^2+2*0.3*10.1*s+102.01)')
  m_circle();
//Example 2:
  xbasc();
  h1=h*syslin('c',(s^2+2*0.1*15.1*s+228.01)/(s^2+2*0.9*15*s+225))
  nyquist([h1;h],0.01,100,['h1';'h'])
  m_circle([-8 -6 -4]);
