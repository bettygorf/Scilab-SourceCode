function []=boucle(fch,abruit,xdim,npts,farrow)
[lhs,rhs]=argn(0);
// appel minimal
if rhs<=4,farrow='f';end;
if rhs<=3,write(%io(2),'integration : nb points,pas du systeme '),
  npts=read(%io(1),1,2),
end
if rhs <= 2,
  write(%io(2),'cadre du dessin : xmin,ymin,xmax,ymax'),
  xdim=read(%io(1),1,4),
// Test sur le cadre
  if xdim(3) <= xdim(1),
  write(%io(2),'Erreur:  xmin ] xmax '),return,end
  if xdim(4) <= xdim(2),
  write(%io(2),'Erreur:  ymin ] ymax '),return,end
end
if rhs <=1,abruit=0.0;end
tcal=npts(2)*(0:npts(1))
rand('normal')
br=sqrt(abruit)*rand(1,npts(1)+1);
if type(fch)=10;
// Passage des constantes a un programme Fortran d'initialisation
  idisp=0;
  pp_c=[ppr,ppk,ppa,ppb,ppm,pps,ppl]
  fort('icomp',xe,1,'r',ue,2,'r',f,3,'r',g,4,'r',h,5,'r',...
      k,6,'r',l,7,'r',br,8,'r',npts(2),9,'r',npts(1),10,'i',...
      pp_c,11,'r',idisp,12,'i','sort');
end
xset("window",0);xselect();xclear();
// Boucle sur les points de depart
  goon=1
  while goon=1,
       ftest=1;
       while ftest=1,
//          addtitle(fch);
          plot2d([xdim(1);xdim(1);xdim(3)],[xdim(2);xdim(4);xdim(4)])
          plot2d([xe(1)],[xe(2)],[-2,-4],"111",...
              "Point d''equilibre pour ue='+string(ue),xdim);
          write(%io(2),'Utilisez la souris : ');
          write(%io(2),' -] Bouton de droite pour quiter ');
          write(%io(2),' -] Bouton du milieu ou de gauche ');
          write(%io(2),'      pour indiquer x0 ');
          [n,xx0,yy0]=xclick()
          if n=2,goon=0;return;end
          x0=[xx0,yy0];
          write(%io(2),'Utilisez la souris : ');
          write(%io(2),' -] Bouton de droite pour quiter ');
          write(%io(2),' -] Bouton du milieu ou de gauche ');
          write(%io(2),'      pour indiquer xchap0 (observateur) ');
          [n,xx0,yy0]=xclick()
          if n=2,goon=0;return;end
          xchap0=[xx0,yy0];
          if type(fch)=10,
             ftest=desorb1([x0,xchap0]',npts,fch,farrow,xdim);
          else
             ftest=desorb1([x0,xchap0]',npts,list(fch,abruit,...
                         npts(2),npts(1)),farrow,xdim);
          end
          if ftest=1;write(%io(2),'conditions initiales hors du cadre'),end
       end
  end


function [res]=desorb1(x0,n1,fch,farrow,xdim);
//[res]=desorb1(x0,n1,fch,farrow,xdim);
//!
res=0
write(%io(2),'Calculs en cours')
tcal=n1(2)*(0:n1(1))
xxx=ode(x0,0,tcal,fch);
[nn1,nn2]=size(tcal);
comcom=-k*(xxx(3:4,:)-xe*ones(1,nn2));
//dessin de l'evolution conjointe de la deuxieme
//composante de l'etat et de son estimee (observateur)
xset("window",1);xclear();
plot2d([tcal;tcal]',xxx([2,4],:)',[1,2],"111",...
       "x2(t) @observateur de x2(t)",[0,xdim(2),n1(1)*n1(2),xdim(4)])
xset("window",2);xclear();
//dessin de la commande lineaire
plot2d([tcal]',[comcom]',[1],"121",...
       "commande lineaire en fonction du temps (ecart par rapport a ue)")
xset("window",0);xclear();
//portrait de phase
plot2d(xxx([1,3],:)',xxx([2,4],:)',[1,2],"111","(x1,x2)@observateur ",...
xdim);



