function rep=x_message(comment,btns)
// message - dialogue affichant un message
//%Syntaxe
// message(comment)
//%Parametres
//comment : vecteur de chaine contenant le texte du message
//%Remarques
//Dans l'environnement Xwindow  cette  macro provoque  l'ouverture d'une
//fenetre de message. L'utilisateur doit confirmer la lecture du message
//en cliquant dans "ok"
//
//Dans un autre environnement la macros affiche le message dans
// la fenetre scilab et attend que l'utilisateur confirme la lecture
// par un retour-chariot
//%exemple
//  message(['Identification du systeme';'methode des moindres carres'])
//!
rep=[]
[lhs,rhs]=argn(0)
comment=matrix(comment,prod(size(comment)),1)
if rhs==1 then
  write(%IO(2),[comment;' ';'Ok ?';' '])
else
  if size(btns,'*')==1
    write(%IO(2),[comment;' ';'Ok ?';' '])
  else
    write(%IO(2),[comment;' ';btns(:);' '])
    str=readline()	
    rep=find(str==btns)
  end
end


//str=read(%IO(1),1,1,'(a)')


function str=x_dialog(comment,default)
// dialog - dialogue pour l'acquisition d'une reponse
//%Syntaxe
// str=dialog(comment [,default])
//%Parametres
//comment : vecteur de chaine contenant le texte commentaire de la 
//          reponse demandee
//default : reponse par defaut, peut etre donnee par un vecteur de
//          chaines
//
//str     : vecteur de chaine de caracteres correspondant a la reponse
//%Remarques
//Dans l'environnement Xwindow  cette  macro provoque  l'ouverture d'une
//fenetre de dialogue. L'utilisateur devant alors y  entrer et/ou editer
//sa reponse eventuellement su plusieurs lignes
//
//Dans un autre environnement la macros affiche le  commentaire   dans
//la fenetre basile et attend que l'utilisateur fournisse le texte de
// sa reponse ou simplement retour-chariot (reponse par defaut).
// Dans ce cas la reponse doit etre donnee en une seule ligne
//%exemple
// gain=evstr(dialog('donnez le gain du transfert','0.75'))
// bode(evstr(dialog(['BODE';'Entrez le nom du systeme'],'h')),0.01,100)
//!
[lhs,rhs]=argn(0)
if rhs==1 then default=' ',end
comment=matrix(comment,prod(size(comment)),1)
default=default(1) // for lmitool
write(%IO(2),[comment;'reponse par defaut :'+default;' '])
str=readline()	
if str==' ' then str=default,end
write(%IO(2),'o[k]/c[ancel]')
rep=readline()	
if part(rep,1)=='c' then str=[],end



function str=x_mdialog(description,labels,valuesini)
//mdialog - dialogue d'acquisition de plusieures reponses textuelles
//%Syntaxe
//str=dialog(description,labels [,valuesini])
//%Parametres
//description : vecteur de chaines contenant le texte commentaire des
//             reponses demandees
//labels      : vecteur des chaines de caracteres donnant le texte associe
//              a chacun des champs question
//valuesini   : vecteur des chaines de caracteres donnant la reponse par 
//              defaut pour chacun des champs.
//
//str     : chaine de caracteres correspondant a la reponse
//%Remarques
//Dans l'environnement Xwindow  cette  macro provoque  l'ouverture d'une
//fenetre de dialogue. L'utilisateur devant alors y  entrer et/ou editer
//sa reponse.
//
//Dans un autre environnement la macros affiche le  commentaire   dans
//la fenetre basile et attend que l'utilisateur fournisse le texte de
// sa reponse ou simplement retour-chariot (reponse par defaut).
// Dans ce cas la reponse doit etre donnee en une seule ligne
//%exemple
// sig=mdialog('specifier le signal sinusoidal',..
//             ['amplitude';'frequence';'phase    ';],['1';'10';'0'])
// ampl=evstr(sig(1))
// freq=evstr(sig(2))
// ph=evstr(sig(3))
//
// rep=mdialog(['Simulation du systeme';'avec un regulateur PI'],..
//                      ['gain proportionnel';'gain integral'],[' ';' '])
//%Voir aussi
//  x_dialog, x_choose, x_message, dialog, choose, message
//!
[lhs,rhs]=argn(0)
n=prod(size(labels))
if rhs==2 then valuesini(n)=' ',end

  write(%IO(2),description)
  n=prod(size(labels))
//  disp('ici');pause
  for k=1:n
    write(%IO(2), labels(k) +' valeur par defaut :'+valuesini(k))
    str(k,1)=readline()
    if str(k)==' ' then str(k)=valuesini(k),end
  end
  write(%IO(2),'o[k]/c[ancel]')
  rep=readline()
  if part(rep,1)=='c' then str=[],end
//  disp('la');pause

function num=x_choose(tochoose,comment,button)
// choose - dialogue de selection
//%Syntaxe
// num=choose(tochoose,comment)
//%Parametres
//tochoose  : vecteur de chaines  de caracteres correspondants a  chacun
//            des choix possibles
//
//comment : vecteur de chaine contenant le texte commentaire a ce choix
//
//button  : chaine de caractere donnant le texte a apparaitre dans le bouton
//          de refus de choix
//%Remarques
//Dans l'environnement Xwindow  cette  macro provoque  l'ouverture d'une
//fenetre de selection. L'utilisateur devant alors  designer a la souris
//sa selection.
//
//Dans un autre environnement la macros affiche le texte des  choix dans
//la fenetre basile et attend que l'utilisateur reponde par le numero du
//choix qu'il veut effectuer la reponse 0 signifiant le refus des choix.
//%Exemple
//  choose(['PID';'Adaptatif';'LQG'],'Choisissez un type de regulateur')
//!
[lhs,rhs]=argn(0)
n=prod(size(tochoose))
tochoose=matrix(tochoose,n,1)
comment=matrix(comment,prod(size(comment)),1)
if rhs==2 then button='Annuler',end

sep=[],
for l=0:n,sep=[sep;':'],end
lmx=maxi([length(tochoose);length(comment)])
  
tochoose=[string(0:n)', [button;tochoose]]

write(%IO(2),[comment;' ';mat2tab(tochoose)])
num=-1
while num<0|num>n  then
  write(%IO(2),'Donnez le numero de votre choix')
  num=evstr(readline())
end



function tab=mat2tab(str,del)
//Etant   donne une  matrice  de chaine  de  caracteres str, mat2tab(str)
//retourne un vecteur colonne de chaines de caracteres  representant les
//elements de str repartis sous forme d'un tableau.
//mat2tab(str,del) (ou del est un vecteur de chaines a un ou deux elements) 
//  retourne le meme tableau ou les colonnes sont separees par la chaine de
//   caracteres contenue dans del(1) et lignes par del(2) s'il exite
//%Exemple
//  tt=['0','a';'1','b';'2','c']
//  write(%io(2),mat2tab(tt))
//  write(%io(2),mat2tab(tt,'|'))
//  write(%io(2),mat2tab(tt,['|','-']))
//!
//origine S Steer 1991
[lhs,rhs]=argn(0)
job=0
if rhs=1 then 
  delc=' ',
else
  delc=del(1)
  if prod(size(del))=2 then
    dell=del(2)
    dell=part(dell,1)
    job=1
  end
end
blk='                              ';blk=blk+blk+blk

[m,n]=size(str);len=length(str)
lmx=[];for col=len,lmx=[lmx,maxi(col)+1],end

ln=sum(lmx)+(n+1)*length(delc)
if job=1 then
  rd=delc
  for l=2:ln-1,rd=rd+dell,end
  rd=rd+delc
  tab=rd
else
  tab=[]
end
for l=1:m
  ll=delc+str(l,1)
  for k=2:n

    ll=ll+part(blk,1:lmx(k-1)-len(l,k-1))+delc+str(l,k)
  end
  ll=ll+part(blk,1:lmx(n)-len(l,n))+delc
  tab=[tab;ll]
  if job=1 then tab=[tab;rd],end
end 


function [btn,xc,yc,win]=xclick();
str=readline()
rep=evstr('['+str+']')
btn=rep(1)
xc=rep(2)
yc=rep(3)
if size(rep,'*')==4 then win=rep(4),end

function str=readline()
rep=read(%IO(1),1,1,'(a)')
comm='/'+'/'
n=length(rep);n0=n
with=%f
while n>1 do
  if part(rep,n-1:n)==comm then
    n=n-2
    with=%t
    break
  end
  n=n-1
end
if with then
  com=part(rep,n+2:n0)
  if n==0 then 
    str=emptystr()
  else
    str=part(rep,1:n)
  end
else
  str=rep
  com=emptystr()
end
str=stripblanks(str)
bl='=';txt=com+':'+str;txt=part(bl,ones(1,60-length(txt)))+txt
write(%io(2),[' ';txt;' '])
    


