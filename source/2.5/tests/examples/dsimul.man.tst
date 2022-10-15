clear;lines(0);
z=poly(0,'z');
h=(1-2*z)/(z^2-0.2*z+1);
sl=tf2ss(h);
u=zeros(1,20);u(1)=1;
x1=dsimul(sl,u)   //Impulse response
u=ones(20,1);
x2=dsimul(sl,u);  //Step response
