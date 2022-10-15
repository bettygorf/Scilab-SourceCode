clear;lines(0);
 deff('[r,ires]=chemres(t,y,yd)',[
         'r(1)=-0.04*y(1)+1d4*y(2)*y(3)-yd(1);';
         'r(2)=0.04*y(1)-1d4*y(2)*y(3)-3d7*y(2)*y(2)-yd(2);'
         'r(3)=y(1)+y(2)+y(3)-1;'
         'ires=0']);
 deff('[pd]=chemjac(x,y,yd,cj)',[
         'pd=[-0.04-cj , 1d4*y(3)               , 1d4*y(2);';
         '0.04    ,-1d4*y(3)-2*3d7*y(2)-cj ,-1d4*y(2);';
         '1       , 1                      , 1       ]'])

y0=[1;0;0];
yd0=[-0.04;0.04;0];
t=[1.d-5:0.02:.4,0.41:.1:4,40,400,4000,40000,4d5,4d6,4d7,4d8,4d9,4d10];

info=list([],0,[],[],[],0,0);
y=dassl([y0,yd0],0,t,chemres,info);
info(2)=1;
y=dassl([y0,yd0],0,4d10,chemres,info);
y=dassl([y0,yd0],0,4d10,chemres,chemjac,info);
