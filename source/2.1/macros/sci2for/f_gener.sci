//[stk,nwrk,txt,top]=f_gener(nam,nwrk,targ)
// stk : liste dont les elements sont des listes et qui joue  plus ou
//       moins un role similaire a celui de la partie haute  la pile scilab
//       (contient la description) des variables sur lesquelles on travaille
//       comme dans la pile scilab stk(top) est la derniere variable definie
//
//       chaque element de stk a la structure suivante:
//       stk(k)=list(definition,type_expr,type_var,nb_ligne,nb_col)
//
//      *definition peut etre soit:
//         - une expression fortran a+2*b-3*c(1) si sa valeur est scalaire
//         - une reference a la premiere adresse d'un tableau fortran:
//                 a   si a est une matrice qui est definie
//                 work(iwn) si la variable est stockee dans un tableau de
//                           travail double precision
//                 iwork(iiwn) si la variable est stockee dans un tableau de
//                           travail entier
//      *type_expr code le type de l'expression et sert essentiellement a
//          determiner comment parentheser
//          '2' : somme de termes
//          '1' : produits de facteurs
//          '0' : atome
//          '-1': valeur stockee dans un tableau fortran pas besoin de
//                parentheser
//      *type_var code le type fortran de la variable
//          '1' : double precision
//          '0' : entier
//          '10': caractere
//          remarques: pour le moment les complexes sont determines par
//                     un champ definition a 2 composantes : partie R et
//                     partie I
//      *nb_ligne , nb_col : nombre de ligne et de colonne, ce sont aussi
//          des chaines de caracteres
// ATTENTION: stk entre par le contexte et l'on ne ressort que la valeur
//            courante
//
//  nwrk : variable qui contient les infos sur les tableaux de travail,
//         les indicateurs d'erreur, ce tableau est manipule par les macro
//         outname adderr getwrk
//
//  txt  : est la portion de texte fortran genere pour realiser la fonction
//         si besoin est (calcul matriciel)
//!
txt=[] 
[lhs,rhs]=argn(0);if rhs=2 then targ=['1','1'],end
tin=targ(1);tout=targ(2)
cnvf='dble'
if tin='0' then cnvf='int',end
//
s2=stk(top)
if s2(4)=='1'&s2(5)=='1' then
//cas d'un argument scalaire
  if s2(3)<>tin then s2(1)=cnvf+'('+s2(1),')',end
  stk=list(nam+'('+s2(1)+')','0',tout,s2(4),s2(5))
  return
end
if s2(3)<>tin then cnv=%t,else cnv=%f,end
if part(s2(1),1:5)=='work(' then
  pti=part(s2(1),6:length(s2(1))-1)
  [outn,nwrk,txt]=outname(nwrk,tout,s2(4),s2(5))
  in='work'
elseif part(s2(1),1:6)=='iwork(' then
  pti=part(s2(1),6:length(s2(1))-1)
  [outn,nwrk,txt]=outname(nwrk,tout,s2(4),s2(5))
  in='iwork'
else
  pti='0'
  outn=s2(1)
  in=s2(1)
end
if part(outn,1:5)=='work(' then 
  pto1=part(outn,6:length(outn)-1),
  out='work'
elseif part(outn,1:6)=='iwork(' then 
  pto1=part(outn,7:length(outn)-1),
  out='iwork'
else
  out=outn
  pto1='0'
end
if s2(4)=='1'|s2(5)=='1' then
  [lbl,nwrk]=newlab(nwrk)
  tl1=string(10*lbl);
  var='ilb'+tl1;
  if cnv then
    t1=' '+out+'('+addf(pto1,var)+')='+..
                              nam+'('+cnvf+'('+in+'('+addf(pti,var)+')))'
  else
    t1=' '+out+'('+addf(pto1,var)+')='+nam+'('+in+'('+addf(pti,var)+'))'
  end
  txt=[txt;' do '+tl1+' '+var+' = 0,'+subf(mulf(s2(4),s2(5)),'1');
           indentfor(t1);part(tl1+'    ',1:6)+' continue']

else
  [lbl,nwrk]=newlab(nwrk)
  tl2=string(10*lbl);
  var2='ilb'+tl2;
  [lbl,nwrk]=newlab(nwrk)
  tl1=string(10*lbl);
  var1='ilb'+tl1;
  if out=='work' then
     t1=' '+out+'('+addf(pto1,addf(var2,mulf(var1,s2(4))))+') = '
  else
     t1=' '+out+'('+var2'+','+var1+') = '
  end
  if in=='work' then
     iar=in+'('+addf(pti,addf(var2,mulf(var1,s2(4))))+')'
  else
     iar=in+'('+var2+','+var1+')'
  end
  if cnv then
    t1=t1+nam+'('+cnvf+'('+iar+'))'
  else
    t1=t1+nam+'('+iar+')'
  end
  txt=[txt;' do '+tl1+' '+var1+' = 0,'+subf(s2(5),'1');
           indentfor([' do '+tl2+' '+var2+' = 0,'+subf(s2(4),'1');
                      indentfor(t1);
                      part(tl2+'    ',1:6)+' continue']);
           part(tl1+'    ',1:6)+' continue'];

end
stk=list(outn,'-1','1',s2(4),s2(5))
//end


