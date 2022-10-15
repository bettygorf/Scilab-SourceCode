function z=narsimul(a,b,d,sig,u,up,yp,ep)
//z=narsimul(a,b,d,sig,u,[up,yp,ep])
//            ou
//z=narsimul(ar,u,[up,yp,ep])
// Simule un ARMAX multidimensionnel
// Le modele est donne par :
//   A(z^-1) z(k)= B(z^-1)u(k) + D(z^-1)*sig*e(k)
//      (z^-1) est l'operateur retard a1(z^-i) y_k= y_{k-i}
//   A(z)= Id+a1*z+...+a_r*z^r;  ( r=0  => A(z)=Id)
//   B(z)= b0+b1*z+...+b_s z^s;  ( s=-1 => B(z)=0)
//   D(z)= Id+d1*z+...+d_t z^t;  ( t=0  => D(z)=Id)
// z et e sont a valeurs dans dans R^n et u dans R^m
//
// En entree :
//   a est la matrice <Id,a1,...,a_r>     dimension (n,(r+1)*n)
//   b est la matrice <b0,......,b_s>     dimension (n,(s+1)*m)
//   d est la matrice <Id,d_1,......,d_t> dimension (n,(t+1)*n)
//   sig est une matrice (n,n), e_{k} est une suite de v.a gaussiennes
//   n-dimensionnelles de variance 1
//   Au lieu de (a,b,d,sig) on peut donner  ar un processus arma (cfre arma)
//
//   u est une matrice (m,N), donnant la chronique d'entree pour u
//         u(:,j)=u_j
//   up et yp : sont optionnels et servent a d\'ecrire le pass\'e
//      dont on a besoin pour calculer la sortie y(1),....y(N)
//      up=< u_0,u_{-1},...,u_{s-1}>;
//      yp=< y_0,y_{-1},...,y_{r-1}>;
//      ep=< e_0,e_{-1},...,e_{r-1}>;
//      s'ils ne sont pas donnes on leur donne la valeur 0
// En sortie on obtient :
//      y(1),....,y(N)
//
// On utilise le simulateur de syst\`eme dynamique de Scilab rtitr
// Auteur : J-Ph. Chancelier ENPC Cergrene
//
//!
[lhs,rhs]=argn(0)
//-compat type(a)==15 retain for list/tlist compatibility
if type(a)==15|type(a)==16,
   if rhs=2,z=narsimul(ar(2),ar(3),ar(4),ar(7),b);return;end
   if rhs=3,z=narsimul(ar(2),ar(3),ar(4),ar(7),b,d);return;end
   if rhs=4,z=narsimul(ar(2),ar(3),ar(4),ar(7),b,d,sig);return;end
   if rhs=5,z=narsimul(ar(2),ar(3),ar(4),ar(7),b,d,sig,u);return;end
end
// calcul de dimension
   [al,ac]=size(a);adeg=int(ac/al);
   [dl,dc]=size(d);ddeg=int(dc/dl);
   [bl,bc]=size(b);[mmu,Nu]=size(u);bdeg=int(bc/mmu);
// quelques tests a faire : bl=al=dl,
// <i>deg*<i>l=<i>c, pour i=a,b,d
//
// On genere d'abord y(k) solution de : A(z^-1)y(k)=B^(z-1)u(k)
s=poly(0,'s');
// matrice polynomiale A(s)
mata=a(:,1:al)*(s**(adeg-1));
for j=2:adeg,mata= mata+(s**(adeg-j))*a(:,1+(j-1)*al:j*al);end
//
// matrice polynomiale B(s)
matb=b(:,1:mmu)*(s**(bdeg-1));
for j=2:bdeg,matb= matb+(s**(bdeg-j))*b(:,1+(j-1)*mmu:j*mmu);end
num=matb*s**(adeg-1)
den=mata*s**(bdeg-1);
// Utilisation des valeurs passees si elles sont donn\'ees
// yp doit etre de taille (al,(adeg-1))
// up doit etre de taille (al,(bdeg-1))
// ep doit etre de taille (al,(adeg-1))
//
if rhs <=5,
   up=0*ones(mmu,(bdeg-1));
else
   if size(up)<>[mmu,(bdeg-1)],
    write(%io(2)," up=[u(0),u(-1),..,] must be of dimension ("...
    +strin(mmu)+','+string(bdeg-1));
    return;end
end
if rhs <=6,
   yp=0*ones(al,(adeg-1));
else
  if size(yp)<>[al,(adeg-1)]
    write(%io(2)," yp=[y(0),y(-1),..,] must be of dimension ("...
    +strin(al)+','+string(adeg-1));
    return;end
end
if rhs <=7,
   ep=0*ones(al,(ddeg-1));
else
  if size(ep)<>[al,(ddeg-1)]
    write(%io(2)," ep=[e(0),e(-1),..,] must be of dimension ("...
    +strin(al)+','+string(ddeg-1));
    return;end
end;
// Changement pour rtitr
degnum=maxi(degree(den));
yp=[0*ones(al,degnum+1-adeg),yp(:,(adeg-1):-1:1)];
up=[0*ones(mmu,degnum+1-bdeg),up(:,(bdeg-1):-1:1)];
y=rtitr(num,den,u,up,yp);
// On genere bru t.q A(z^-1)bru= D(z^-1) sig*e(t)
matd=d(:,1:dl)*(s**(ddeg-1));
for j=2:ddeg,matd= matd+(s**(ddeg-j))*d(:,1+(j-1)*dl:j*dl);end
num=matd*s**(adeg-1)
den=mata*s**(ddeg-1);
degnum=maxi(degree(den));
ep=[0*ones(al,degnum+1-ddeg),ep(:,(ddeg-1):-1:1)];
rand('normal');
[n1,n2]=size(y);
br=sig*rand(al,n2)
bru=rtitr(num,den,br,ep,0*ones(ep));
//
// z(k) = y(k) + bru(k)
z=y+bru
//end


