clear;lines(0);
z=poly(0,'z');
h=(1-2*z)/(z^2-0.5*z+5)
rep=[0;ldiv(h('num'),h('den'),20)]; //impulse response
H=time_id(2,'impuls',rep)
//  Same example with flts and u
u=zeros(1,20);u(1)=1;
rep=flts(u,tf2ss(h));        //impulse response
H=time_id(2,u,rep)
//  step response
u=ones(1,20);
rep=flts(u,tf2ss(h));     //step response.
H=time_id(2,'step',rep)
H=time_id(3,u,rep)    //with u as input and too high order required
