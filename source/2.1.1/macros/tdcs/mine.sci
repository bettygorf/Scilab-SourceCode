//[cout,feed]=mine(n1,n2,uvect)
//[cout,feed]=mine(n1,n2,uvect)
// extraction optimale d'un minerai d'une mine a ciel ouvert
// en avancant progressivement (k=1,2,...,n2) et en
// prelevant a l'abcisse k+1 la tranche de profondeur x(k+1)
// par une commande u a partir de la profondeur x(k)
// a l'abcisse k.
//
// la resolution du probleme se fait par programmation dynamique
// en calculant la commande optimale maximisant le critere :
//
//   -- n2-1
//   \
//   /        f(x(k),k) + V_F(x,n2)
//   -- k=1
//  avec : x(k+1)=x(k) + u
//  x(k) est la profondeur de la mine a l'abcisse k (x=1
//      est le niveau du sol)
// la fonction gain instantane f(i,k) represente le benefice
//      si on creuse la profondeur i a l'abcisse k
//  V_F(i,n2) est un cout final destine a forcer l'etat final
//       a valoir 1 (pour sortir de la mine ...)
//       V_F(i,n2) vaut -10000 en tout les points i\ne1 et 0
//       pour i=1
//
// le programme mine necessite de connaitre
//    n1    : l'etat est discretise en n1 points
//    n2    : nombre d'etapes
//    uvect : vecteur ligne des valeurs discretes que peut
//          prendre u (3 valeurs, on monte, on descend ou on avance)
// et le programme mine retourne alors deux matrices
//    cout(n1,n2) : valeurs de la fonction de Bellman
//    feed(n1,n2) : valeurs de la commande a appliquer
//          lorsque l'etat varie de 1 a n1 et
//          l'etape de 1 a n2.
//!
xgr=1:(n1+2)
// tableau ou l'on stocke la fonction de Bellman
cout=0*ones(n1+2,n2);
// tableau ou l'on stocke le feedback u(x,t)
feed=0*ones(n1,n2);
// calul de la fonction de Bellman au  temps final
penal=10000;
cout(:,n2)=-penal*ones(n1+2,1);
cout(2,n2)=0;
// calcul retrograde de la fonction de Bellman et
// du controle optimal au temps temp par l'equation de Bellman
for temp=n2:-1:2,
  loc=0*ones(n1+2,3);
  for i=1:3,
    newx=mini(maxi(xgr+uvect(i)*ones(xgr),1*ones(xgr)),(n1+2)*ones(xgr)),
    loc(:,i)=cout(newx,temp)+ff_o(xgr,temp-1),
  end;
  [mm,kk]=maxi(loc(:,1),loc(:,2),loc(:,3)),
  cout(xgr,temp-1)=mm;
  cout(1,temp-1)=-penal;
  cout(n1+2,temp-1)=-penal;
  feed(xgr,temp-1)=uvect(kk)';
end
feed=feed(2:(n1+1),1:(n2-1));
cout=cout(2:(n1+1),:);
//end


//[y]=ff_o(x,t)
//[y]=ff_o(x,t)
// gain instantane apparaissant dans le critere du
// programme mine.
//
// pour des raisons techniques, l'argument x doit
// etre un vecteur colonne et donc egalement la sortie y.
// en sortie y=[ ff_0(x(1),t),...ff_o(x(n),t)];
//!
xxloc=ones(x);
y= k0*(1- (t-te)**2/n2)*xxloc + (x-xe*xxloc)**3/(n1**3) -kc*x
y=y';
//end

//[]=showcost(n1,n2,teta,alpha)
//[]=showcost(n1,n2,teta,alpha)
// Montre en 3d la fonction de gain instantanee (ff)
// x: profondeur (n1)
// y: abscisse  (n2)
// en z : valeur de ff_o(x,t)
//!
[lhs,rhs]=argn(0)
if rhs=2,teta=45,alpha=45,end
m=[];
for i=1:n2,m=[m,ff_o(1:n1,i)],end
plot3d(1:n1,1:n2,m,teta,alpha,"profondeur @ abscisse @ gain inst",[2,1]);
//end

//[]=trajopt(feed)
//[]=trajopt(feed)
// feed est la matrice de feedback calculee par mine
// trajopt calcule et dessine la trajectoire et le controle
// optimaux pour un point de depart (1,1)
//!
[n1,n2]=size(feed)
xopt=0*ones(1,n2)
uopt=0*ones(1,n2+1)
xopt(1)=1;
for i=2:(n2+1),xopt(i)=feed(xopt(i-1),i-1)+xopt(i-1),
             uopt(i-1)=feed(xopt(i-1),i-1),end
plot2d([1:(n2+1);1:(n2+1)]',[uopt;-xopt]',[-1,-2],"111",...
       "commande optimale@trajectoire optimale",...
       [1,-10,n2,2]);
//end



//[]=tdinit3()
// Macro qui initialise les donnees du
// td3
//!
n1=20
n2=20;
te=0;
xe=-0.1;
k0=100;
kc=1;
[n1,n2,te,xe,k0,kc]=resume(...
        n1,n2,te,xe,k0,kc);
//end
