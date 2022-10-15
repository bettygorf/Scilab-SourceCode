//[stk,nwrk,txt,top]=f_ent(nwrk)
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
s2=stk(top)
 
if s2(4)=='1'&s2(5)=='1' then
  stk=list('int('+s2(1)+')','0','0',s2(4),s2(5))
else
  [out,nwrk,txt]=outname(nwrk,'0',s2(4),s2(5))
  txt=[txt;gencall(['db2int',mulf(s2(4),s2(5)),s2(1),'1',out,'1'])]
  stk=list(out,'-1',0,s2(4),s2(5))
end
 
//end


