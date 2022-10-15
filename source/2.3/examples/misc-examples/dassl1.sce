//DASSL
// PROBLEM 1:   LINEAR DIFFERENTIAL/ALGEBRAIC SYSTEM
//
//X1DOT + 10.0*X1 = 0  
//X1 + X2 = 1
//X1(0) = 1.0, X2(0) = 0.0
//
t=1:10;t0=0;y0=[1;0];y0d=[-10;0];
info=list([],0,[],[],[],0,0);
//    Calling Scilab functions
deff('[r,ires]=dres1(t,y,ydot)','r=[ydot(1)+10*y(1);y(2)+y(1)-1];ires=0')
deff('pd=djac1(t,y,ydot,cj)','pd=[cj+10,0;1,1]')
//   scilab function, without jacobian
yy0=dassl([y0,y0d],t0,t,dres1,info);
//   scilab functions, with jacobian
yy1=dassl([y0,y0d],t0,t,dres1,djac1,info);
// fortran routine dres1 in dir. routines/default, without jocabian
yy2=dassl([y0,y0d],t0,t,'dres1',info);   //=yy0
norm(yy2-yy0,1)
// fortran routines dres1 and djac1 in dir. routines/default, with jacobian
yy3=dassl([y0,y0d],t0,t,'dres1','djac1',info);  //=yy1
norm(yy3-yy1,1)
yy3bis=dassl([y0,y0d],t0,t,'dres1',djac1,info); 
// call fortran dres1 and scilab's djac1
yy3ter=dassl([y0,y0d],t0,t,dres1,'djac1',info);
//
// with specific atol and rtol parameters
atol=1.d-6;rtol=0;
yy4=dassl([y0,y0d],t0,t,atol,rtol,dres1,info);
yy5=dassl([y0,y0d],t0,t,atol,rtol,'dres1',info); //=yy4
norm(yy5-yy4,1)
yy6=dassl([y0,y0d],t0,t,atol,rtol,dres1,djac1,info); 
yy7=dassl([y0,y0d],t0,t,atol,rtol,'dres1','djac1',info); //==yy6
norm(yy7-yy6,1)
//    yy7=dassl([y0,y0d],t0,t,atol,rtol,'dres1','djac1',info); //==yy6
norm(yy7-yy6,1)
