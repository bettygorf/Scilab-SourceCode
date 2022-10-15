function [Se,R,T]=sensi(G,Sk)
// [Se,R,T]=sensi(G,Sk) computes sensitivity functions  
//!
flag=0;
if G(1)='r' then G=tf2ss(G);flag=1;end
if Sk(1)='r' then Sk=tf2ss(Sk);flag=flag+1;end
[ny,nu]=size(G);Iu=eye(nu,nu);Iy=eye(ny,ny);
Ouy=zeros(nu,ny);Oyu=zeros(ny,nu);Ouu=zeros(nu,nu);
Oyy=zeros(ny,ny);
W1=[Iy,Oyu,Oyy;
    Ouy,Iu,Ouy;
   -Iy,Oyu,Iy;
    Iy,Oyu,Oyy];
W2=[Iy,-G;
    Ouy,Iu;
    Iy,Oyu];
SRT=lft(W1*W2,Sk);
Se=SRT(1:ny,:);
R=SRT((ny+1):(ny+nu),:);
T=SRT((nu+ny+1):(nu+ny+ny),:);
if flag >0 then
   Se=ss2tf(Se);R=ss2tf(R);T=ss2tf(T);
end



