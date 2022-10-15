function [P,r]=augment(G,flag)
// Augmented plants P
//!
[LHS,RHS]=argn(0)
if RHS==1 then flag='SRT';end
r=size(G);
 [ny,nu]=size(G);Iu=eye(nu,nu);Iy=eye(ny,ny);
 Ouy=zeros(nu,ny);Oyu=zeros(ny,nu);Ouu=zeros(nu,nu);
 Oyy=zeros(ny,ny);
ssflag=0;
if G(1)='r' then ssflag=1;end
long=length(flag);
select long
case 3 then
// 'SRT'
 if ssflag==0 then
 W1=[Iy,Oyu,Oyy;
     Ouy,Iu,Ouy;
    -Iy,Oyu,Iy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end
 if ssflag ==1 then
    P=[Iy,-G;
       Ouy,Iu;
       Oyy,G;
       Iy,-G]
 end
return  
case 2 then
if flag=='SR' then
 if ssflag==0 then
 W1=[Iy,Oyu,Oyy;
     Ouy,Iu,Ouy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end
 if ssflag==1 then
    P=[Iy,-G;
       Ouy,Iu;
       Iy,-G];
 end
return
end
if flag=='ST' then
 if ssflag==0 then
 W1=[Iy,Oyu,Oyy;
    -Iy,Oyu,Iy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end
 if ssflag ==1 then
    P=[Iy, -G;
       Oyy, G;
       Iy, -G];
 end
return
end
if flag=='RT' then
 if ssflag==0 then
 W1=[Ouy,Iu,Ouy;
    -Iy,Oyu,Iy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end;
 if ssflag ==1 then
    P=[Ouy,Iu;
       Oyy,G;
       Iy,-G];
 end
return  
end 
case 1 then
if flag=='S' then
 if ssflag==0 then
 W1=[Iy,Oyu,Oyy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end;
 if ssflag ==1 then
    P=[Iy,-G;
       Iy,-G];
 end
return
end
if flag=='R' then
 if ssflag==0 then
 W1=[Ouy,Iu,Ouy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end
 if ssflag ==1 then
    P=[Ouy,Iu;
       Iy,-G];
 end
return
end
if flag=='T' then
 if ssflag==0 then
 W1=[-Iy,Oyu,Iy;
     Iy,Oyu,Oyy];
 W2=[Iy,-G;
     Ouy,Iu;
     Iy,Oyu];
 P=W1*W2;
 end
 if ssflag ==1 then
    P=[Oyy,G;
       Iy,-G];
 end
return
end
end




