//[]=finit()
// Initialisation de parametres relatif au probleme
// de l'alunissage
//k     : acceleration de poussee de la fusee
//gamma : acceleration de la pesanteur sur la lune
//umax  : debit maximum d'ejection des gaz
//mcap  : masse de la capsule
//cpen  : penalisation dans la fonction cout de l'etat final
//!
k=100
gamma=1
umax = 1
mcap = 10
cpen =100;
[k,gamma,umax,mcap,cpen]=resume(k,gamma,umax,mcap,cpen)
//end


//[ukp1]=fuseegrad(niter,ukp1,pasg)
//[ukp1]=fuseegrad(niter,ukp1,pasg)
// niter : nombre d'iteration de gradient a faire a partir
// de ukp1 solution initiale de taille 135
// pasg  : le pas de gradient choisit
// la valeur renvoyee est la derniere loi de commande obtenue.
// l'optimum s'obtient avec ubang(135,50)
// (optimum du pb non penalise)
//!
// fenetres graphiques
xset("window",0);xclear();
xset("window",1);
if xget("window")=0 , xinit('unix:0.0'),xset("window",1),end
xclear();
xset("window",2);
if xget("window")=0 , xinit('unix:0.0'),xset("window",2),end
xclear();
// on s'arrete a tf=135
tf=135
[n1,n2]=size(ukp1)
if n2 <>135, print(%io(2),"uk doit etre un vecteur (1,135)")
     return,end
// Calculs de gradient et dessins
for i=1:niter, [c,xk,pk,ukp1]=fcout(tf,ukp1,pasg),
write(%io(2),c,'(''Cout : '',f20.2)');
write(%io(2),xk(3,135),'(''Masse de la fusee : '',f20.2)');
xset("window",0);
tt=1:tf;
plot2d(tt',xk(1,:)',[-1],"111","Trajectoire",[1,0,tf,5200]);
xset("window",1);
plot2d(tt',xk(3,:)',[-1],"111","Evolution de la masse",[1,10,tf,100]);
xset("window",2);
plot2d(tt',ukp1',[-1],"111","Commande",[1,-1,tf,2]);
end
//end


//[c,xk,pk,ukp1]=fcout(tf,uk,pasg)
//[c,xk,pk,ukp1]=fcout(tf,uk,pasg)
// pour une loi de commande uk
// Calcule la fonction cout que l'on cherche a minimiser
// c = -m(tf) + C*( h(tf)**2 + v(tf)**2)
// (on veut minimiser la consommation et atteindre la
// cible h=0 avec une vitess nulle obtenue par penalisation)
// la trajectoire associee
// Calcule aussi une nouvelle loi de commande par une methode
// de gradient
//!
[xk,pk]=equad(tf,uk);
c= - xk(3,tf) +cpen*(xk(1,tf)**2 +xk(2,tf)**2);
grad =   k*pk(2,:)./xk(3,:) -pk(3,:);
//gradient projete su [0,umax]
ukp1=maxi(mini(uk- pasg*grad,umax*ones(1,tf)),0*ones(1,tf));
//end



//[xdot]=fusee(t,x)
//[xdot]=fusee(t,x)
// dynamique de la fusee
//!
xd= x(2);
if x(3)<= 10, md=0
yd= -gamma;
,else md= -pousse(t),
yd= k*pousse(t)/x(3)-gamma;
end;
xdot=[xd;yd;md];
//end


//[pdot]=fuseep(t,p)
//[pdot]=fuseep(t,p)
//equation adjointe
//!
xp=0
yp=-p(1);
zp= p(2)*k*pousse(t)/(traj(t)**2);
pdot=[xp;yp;zp]
//end


//[ut]=pousse(t)
//[ut]=pousse(t)
// la loi de commande u(t) constante par morceaux
// construite sur la loi de comande discrete uk
//!
[n1,n2]=size(uk);
ut=uk(mini(maxi(ent(t),1),n2));
//end


//[uk]=ubang(tf,tcom)
//[uk]=ubang(tf,tcom)
// genere une loi bang-bang qui vaut 0 de 0 a tcom
// et 1 de tcom a tf
//!
uk=0*ones(1,tf)
uk(tcom:tf)=1*ones(1,tf-tcom+1);
//end


//[]=sfusee(tau,h0,v0,m0,Tf)
//[]=sfusee(tau,h0,v0,m0,Tf)
//
// calcule la trajectoire de la fusee soumise a
// une commande bang-bang
// tau est la date de commutation
// h0 : la hauteur initiale
// v0 : la vitesse initiale ( negative si chute)
// m0 : la masse initiale ( carburant + capsule)
// Tf : l'horizon d'integration
//!
// Premiere phase : chute libre
n=20;
ind=1:n;
t= ind*tau/n;
m(ind)= m0*ones(1,n);
v(ind)=-gamma*(t)+v0*ones(1,n);
h(ind)= - gamma*(t.*t)/2 +  v0*(t) + h0*ones(1,n);
m = [ m0,m]
v=  [ v0,v]
h= [h0,h]
t= [ 0 t]
// Deuxieme phase : frein plein gaz
n1=40;
ind=1:n1;
ind1=0:(n1-1)
t1= ind1*Tf/(n1-1) +tau* ((n1-1)*ones(1,n1)-ind1)/(n1-1);
m1(ind)= ( m0+umax*tau)*ones(1,n1) -umax*(t1);
mcapsul=mcap*ones(1,n1);
m1=maxi(m1,mcapsul);
v1(ind)= - gamma*(t1)+ v0*ones(1,n1) -k *log( m1(ind)/m0);
h1(ind)= - gamma*(t1.*t1)/2 +  v0*(t1) + (h0-k*tau)*ones(1,n1)...
      +(k/umax)*m1(ind).*log(m1(ind)/m0)+k*t1;
m=[m,m1];
v=[v,v1];
h=[h,h1];
t=[t,t1];
// a revoir
[m1,m2]=maxi(h,0*h);
m2=2*ones(m2)-m2;
[n1,n2]=size(m2);
ialu=1;
for i=1:n2,if m2(i)=0,ialu=[ialu,i],end,end
ialu=ialu(2);
write(%io(2),t(ialu),'('' Date alunissage'',f7.2)')
write(%io(2),m(ialu),'('' Masse  alunissage'',f7.2)')
write(%io(2),v(ialu),'('' Vitesse alunissage'',f7.2)')
xset("window",0)
xclear();
// Dessin
[q1,q2]=size(h)
h1=0*ones(h);
//h1(ialu:q2)=maxi(h)*ones(1,q2-ialu+1);
//
plot2d([t]',[h]',[-1;1],"111","distance par rapport au sol",...
    [0,0,tf,maxi(h)])
xset("window",1)
if xget("window")=0 , xinit('unix:0.0'),xset("window",1),end
xclear();
plot2d([t;t]',[v;0*v]',[-1;-1],"121",...
       "vitesse de la fusee (si + v ascent.)@0");
//recherche de la date d'arrivee au sol
//end


//[xk,pk]=equad(tf,uk)
//[xk,pk]=equad(tf,uk)
// pour une loi de commande u(t)  stockee dans uk, calcule
// la trajectoire xk associee et l'etat adjoint pk
//!
xk=ode([5220;-5;100],1,1:tf,0.01,0.01,fusee);
deff('[y]=gg(t,x)','y=-fuseep('+string(tf)+'-t,x)');
// condition finales pour l'equation adjointe
// en fait on minimise -m(tf)**2+...
pk=ode([2*cpen*xk(1,tf);2*cpen*xk(2,tf);-xk(3,tf)],0.01,0.01:tf,...
    1,1,gg);
pk(1,:)=pk(1,tf:-1:1);
pk(2,:)=pk(2,tf:-1:1);
pk(3,:)=pk(3,tf:-1:1);
//end


//[xt]=traj(t)
//[xt]=traj(t)
// approximation constante par morceaux de l'evolution de la masse
// construite sur xk : trajectoire discrete.
//!
xt=xk(3,maxi(ent(t),1));
//
//end
