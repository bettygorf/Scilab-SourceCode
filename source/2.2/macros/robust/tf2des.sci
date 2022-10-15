function [S]=tf2des(G)
//[S]=tf2des(G) 
// Transfer function to descriptor form: S=list('d',A,B,C,0,E)
//  E*dx=A*x+B*u
//  y=C*x+D*u
//!
Num=G(2);Den=G(3);
%s=poly(0,varn(Den));
[n,m]=size(Num);
pol=zeros(n,m);pro=pol;
//        Pro = strictly proper part of G
//        Pol = polynomial part of G.
for l=1:n,
    for k=1:m,
      denlk=Den(l,k);
      [r,q]=pdiv(Num(l,k)+0*%s,denlk+0*%s);
      pol(l,k)=q;
      pro(l,k)=r/denlk;
    end;
end;
 
sp=tf2ss(pro);
spol=tf2ss(horner(pol,1/%s)/%s);
 
[n1,n1]=size(sp(2));
[n2,n2]=size(spol(2));
A=[sp(2),0*ones(n1,n2);
   0*ones(n2,n1),eye(n2,n2)];
E=[eye(n1,n1),0*ones(n1,n2);
   0*ones(n2,n1),spol(2)];
B=[sp(3);
   spol(3)];
C=[sp(4),-spol(4)];
S=list('des',A,B,C,0*C*B,E)



