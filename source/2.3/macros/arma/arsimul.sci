function z=arsimul(a,b,d,sig,u,up,yp,ep)
//z=arsimul(a,b,d,sig,u,[up,yp,ep])
//            ou
//z=arsimul(ar,u,[up,yp,ep])
// Simulation of multidimensionnal ARMAX
// Model :
//   A(z^-1) z(k)= B(z^-1)u(k) + D(z^-1)*sig*e(k)
//      (z^-1) :delay  a1(z^-i) y_k= y_{k-i}
//   A(z)= Id+a1*z+...+a_r*z^r;  ( r=0  => A(z)=Id)
//   B(z)= b0+b1*z+...+b_s z^s;  ( s=-1 => B(z)=0)
//   D(z)= Id+d1*z+...+d_t z^t;  ( t=0  => D(z)=Id)
// z and e in R^n,  u in R^m
//
// Inputs :
//   a matrix <Id,a1,...,a_r>     dimension (n,(r+1)*n)
//   b matrix <b0,......,b_s>     dimension (n,(s+1)*m)
//   d matrix <Id,d_1,......,d_t> dimension (n,(t+1)*n)
//   u matrix (m,N), 
//         u(:,j)=u_j
//   sig matrix (n,n), e_{k} gaussian r.v
//
//   up, yp :  optionial args: past values
//      up=< u_0,u_{-1},...,u_{s-1}>;
//      yp=< y_0,y_{-1},...,y_{r-1}>;
//      ep=< e_0,e_{-1},...,e_{r-1}>;
//      default=)
// Output :
//      y(1),....,y(N)
//
// Method : State-space approach
// Auteur : J-Ph. Chancelier ENPC Cergrene
//!
//
[lhs,rhs]=argn(0)
//-compat type(a)==15 retain for list/tlist compatibility
if type(a)==15|type(a)==16,
   if rhs=2,z=arsimul(a(2),a(3),a(4),a(7),b);return;end
   if rhs=3,z=arsimul(a(2),a(3),a(4),a(7),b,d);return;end
   if rhs=4,z=arsimul(a(2),a(3),a(4),a(7),b,d,sig);return;end
   if rhs=5,z=arsimul(a(2),a(3),a(4),a(7),b,d,sig,u);return;end
   if rhs=6,z=arsimul(a(2),a(3),a(4),a(7),b,d,sig,u,up);return;end
   if rhs=7,z=arsimul(a(2),a(3),a(4),a(7),b,d,sig,u,up,yp);return;end
   if rhs=8,z=arsimul(a(2),a(3),a(4),a(7),b,d,sig,u,up,yp,ep);return;end
end
z=0;
[lhs,rhs]=argn(0)
[bl,bc]=size(b);[al,ac]=size(a);[dl,dc]=size(d);
adeg=int(ac/al);
[mmu,Nu]=size(u);
bdeg=int(bc/mmu);
ddeg=int(dc/dl);
// la dimension de la representation d'etat a retenir
nn=maxi([adeg,bdeg,ddeg])-1;
// Construction d'une representation d'etat
// Y_{n+1}= a_fff*Y_{n}  +b_fff*u_n +d_fff* e(n)
a1=[ -a(:,al+1:ac), 0*ones(al,al*(nn-adeg+1))];
a_fff=a1(:,1:al);
for j=2:nn,a_fff= [ a_fff ; a1(:,1+(j-1)*al:j*al)];end
a2=[diag(1*ones(1,nn-1),1).*.eye(al)];
a_fff=[a_fff,a2(:,al+1:nn*al)];
//----b_fff
b1=[ b(:,mmu+1:bc), 0*ones(al,mmu*(nn-bdeg+1))];
b_fff=b1(:,1:mmu);
for j=2:nn,b_fff= [ b_fff ; b1(:,1+(j-1)*mmu:j*mmu)];end
//----d_fff
d1=[ d(:,al+1:dc), 0*ones(al,al*(nn-ddeg+1))];
d_fff=d1(:,1:al)
for j=2:nn,d_fff= [ d_fff ; d1(:,1+(j-1)*al:j*al)];end
d_fff=d_fff+a_fff(:,1)
//
deff('[xdot]=fff(t,x)',['xdot=a_fff*x+b_fff*u(:,t)+d_fff*br(:,t)']);

// simulation de e(n) le bruit
rand('normal');
br=sig*rand(al,Nu);
// Calcul des Conditions initiales pour le systeme en Y_n
// yp doit etre de taille (al,(adeg-1))
// up doit etre de taille (al,(bdeg-1))
// ep doit etre de taille (al,(adeg-1))
if rhs <=5,
   up=0*ones(mmu,(bdeg-1));
else
   up_s=size(up)
   if up_s(1)<>mmu|up_s(2)<>(bdeg-1) then
    write(%io(2)," up=[u(0),u(-1),..,] must be of dimension ("...
    +string(mmu)+','+string(bdeg-1));
    return;end
end
if rhs <=6,
   yp=0*ones(al,(adeg-1));
else
  yp_s=size(yp);
  if yp_s(1)<>al|yp_s(2)<>(adeg-1) then 
    write(%io(2)," yp=[y(0),y(-1),..,] must be of dimension ("...
    +string(al)+','+string(adeg-1));
    return;end
end
if rhs <=7,
   ep=0*ones(al,(ddeg-1));
else
  ep_s=size(ep);
  if ep_s(1)<>al|ep_s(2)<>(ddeg-1) then
    write(%io(2)," ep=[e(0),e(-1),..,] must be of dimension ("...
    +string(al)+','+string(ddeg-1));
    return;end
end;
yinit=[ yp, 0*ones(al,al*(nn-adeg+1))];
uinit=[up, 0*ones(al,mmu*(nn-bdeg+1))];
yinit=matrix(yinit,nn*al,1);
uinit=matrix(uinit,nn*mmu,1);
y1=a1*yinit+b1*uinit;
for i=1:nn-1, a1=[a1(:,al+1:nn*al), 0*ones(al,al)];
           b1=[ b1(:,mmu+1:nn*mmu), 0*ones(al,mmu)];
           y1=[y1;a1*yinit+b1*uinit];
end;
// Simulation par ode et calcul de la sortie
// z = premiere composante ``bloc'' de Y
if size(a_fff)=[0,1];
   z=b(1:al,1:mmu)*u(:,:)+d(1:al,1:al)*br(:,:);
else
   z=ode('discret',y1,1,2:Nu,fff);z=[y1,z];
   z=z(1:al,:)+b(1:al,1:mmu)*u(:,:)+d(1:al,1:al)*br(:,:);
end



