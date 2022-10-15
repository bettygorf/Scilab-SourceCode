//[]=fchamp(macr_f,fch_t,fch_xr,fch_yr,arfact,flag)
//[]=fchamp(f,t,xr,yr,arfact,flag)
//   Visualisation de champ de vecteur dans R^2,
//   Les champs de vecteur que l'on visualise seront d\'efinis sous
//   la forme <y>=f(x,t,[u]), pour \^etre compatible avec la macro ode
//    f : le champ de vecteur . Peut etre soit :
//	 une macro donnant la valeur d'un champ en un point x,<y>=f(t,x,[u])
//       un object de type liste list(f1,u1) ou f1 est une macro de type
//        <y>=f1(t,x,u) et u1 est la valeur que l'on veut donner a u
//    t : est la date \`a laquelle on veut le champ de vecteur.
//    xr,yr: deux vecteurs implicites donnant les points de la grille
//      ou on veut visualiser le champ de vecteur.
//    arfact : un argument optionnel qui permet de controler la taille
//      de la tete des fleches qui indique la valeur du champ (1.0 par defaut)
//    flag : chaine de caractere
//          "0" pas d'indication sous les axes
//          "1" les valeur de xr et yr son rajoutees en indications
//              sous les axes
//          "2" on utilise le cadre et les indications sous les axes
//              en utilisant les valeurs d'un appel
//  	        precedent
//Exemple : taper fchamp pour voir un exemple
//     deff('[xdot] = derpol(t,x)',['xd1 = x(2)';
//     'xd2 = -x(1) + (1 - x(1)**2)*x(2)';
//     'xdot = [ xd1 ; xd2 ]']);
//      fchamp(derpol,0,-1:0.1:1,-1:0.1:1,1);
//!
[lhs,rhs]=argn(0);
if rhs <=0,s_mat=['deff(''[xdot] = derpol(t,x)'',[''xd1 = x(2)'';';
                 '''xd2 = -x(1) + (1 - x(1)**2)*x(2)'';';
                 '''xdot = [ xd1 ; xd2 ]'']);';
                 'fchamp(derpol,0,-1:0.1:1,-1:0.1:1,1);']
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs <= 2,fch_xr=-1:0.1:1;end
if rhs <= 3,fch_yr=-1:0.1:1;end
if rhs <= 4,arfact=1.0;end
if rhs <= 5,flag="0";end
[p1,q1]=size(fch_xr);
[p2,q2]=size(fch_yr);
if type(macr_f)=11 then comp(macr_f),end;
fch_rect=[fch_xr(1),fch_yr(1),fch_xr(q1),fch_yr(q2)];
if type(macr_f) <> 15,
  deff('[yy]=mmm(x1,x2)',['xx=macr_f(fch_t,[x1;x2])';'yy=xx(1)+%i*xx(2);']);
  comp(mmm);
  fch_v=feval(fch_xr,fch_yr,mmm);
else
  mmm1=macr_f(1)
  deff('[yy]=mmm(x1,x2)',['xx=mmm1(fch_t,[x1,x2],macr_f(2));';
                          'yy=xx(1)+%i*xx(2);']);
  comp(mmm);
  fch_v=feval(fch_xr,fch_yr,mmm);
end
  fch_vx=real(fch_v)
  fch_vy=imag(fch_v)
champ(fch_vx,fch_vy,arfact,...
   [fch_xr(1),fch_yr(1),fch_xr(q1),fch_yr(q2)],flag);
//end



