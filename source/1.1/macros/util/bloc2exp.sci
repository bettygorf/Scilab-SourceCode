function [h,name]=bloc2exp(syst,sexp)
//<h [,name]>=bloc2exp(syst[,sexp]) calcule l'expression formelle h du
//systeme dynamique correspondant a la liste syst de type 'blocd'
//
//si  sexp est une matrice vide ou un vecteur de chaines de caracteres
//representant des expressions scilab, h sera donne par une liste dont
//le  deuxieme champ est  un vecteur de  chaines definissant  des sous
//expressions du systeme dynamique et le premier champ  une matrice de
//chaines definissant l'expression formelle du systeme a partir de ses
//sous expressions.
//name est une liste dont le premier champ est le vecteur des noms des
//variables d'entree et le  second le nom des  variables de  sortie du
//systeme
//
//Voir aussi les macros blocdext, eval, %connect
//!
//origine F. Delebecque S. Steer inria   1989
//
[lhs,rhs]=argn(0)
if type(syst)<>15 then
  error('argument must be a list describing the blocks')
end;
if syst(1)<>'blocd' then
  error('argument must be a list describing the blocks')
end;
//inter%connection matrix
nsyst=size(syst)
for l=2:nsyst
 sys=syst(l)
 if sys(1)='blocd' then
    if rhs=1 then  sys=bloc2exp(sys)
                   syst(l)=list('transfer',sys)
             else  [sys]=bloc2exp(sys,sexp)
                   syst(l)=list('transfer',sys(1))
                   sexp=sys(2)
    end;
 end;
end;
if lhs=2 then [t,nio,name]=construct(syst)
             else [t,nio]=construct(syst)
end;
//linear equation
if rhs=1 then
  t=trianfml(t)
else
  [t,sexp]=trianfml(t,sexp)
end
[nt,mt]=size(t)
h=t(nt-nio(2)+1:nt,nt+1:mt)
for kt=1:nio(1),for lt=1:nio(2),
  h(lt,kt)=mulf('-1',h(lt,kt))
end,end,
if rhs=1 then h=trisolve(t(nt-nio(2)+1:nt,nt-nio(2)+1:nt),h)
         else [h,sexp]=trisolve(t(nt-nio(2)+1:nt,nt-nio(2)+1:nt),h,sexp)
              h=list(h,sexp)
end;
if lhs=2 then name=list(name(nt+1:mt)',name(nt-nio(2)+1:nt)'),end,

function [ab,nio,name]=construct(syst)
//!
[lhs,rhs]=argn(0)
if type(syst)<>15 then
  error('input must be a list for block-diagramm representation')
end;
if syst(1)<>'blocd' then
  error('input must be a list for block-diagramm representation')
end;
[lboites,lliens,lentrees,lsorties]=blocdext(syst)
nio=[prod(size(lentrees)),prod(size(lsorties))]
lliens=[lliens,lsorties]
nlignes=prod(size(lliens))
ncols=nlignes+nio(1)
//
ab=string(0*ones(nlignes,ncols))
l=1;
for numero=lboites
//on ecrit les equations relatives a la boite "bloc" --> une ligne bloc de la
//matrice ab
    bloc=syst(numero)
    transfert=bloc(2);[no,ni]=size(transfert);
    l1=l+no-1;
    outint=out1(numero,lliens)
    internes=%connect(numero,lliens);
    externes=%connect(numero,lentrees);
    for inti=internes
      ni=prod(size(inti))
      ab(l:l1,inti(1))=transfert(:,inti(2:ni))
      ll=0;for iout=outint
               ab(l-1+iout(2),iout(1))='-eye'
               ll=ll+1
      end;
    end;
    for ext=externes
      ne=prod(size(ext))
      ab(l:l1,nlignes+ext(1))=transfert(:,ext(2:ne))
      ll=0;for iout=outint
               ab(l-1+iout(2),iout(1))='-eye'
               ll=ll+1
      end;
    end;
    l=l1+1
end;
if lhs=1 then  return,end
name=[]
for kvar=[lliens,lentrees],
obj=syst(kvar)
name=[name,obj(2)]
end;

function [lboites,lliens,lentrees,lsorties]=blocdext(syst)
//!
//
lboites=[]
lliens=[]
lentrees=[]
lsorties=[]
nsyst=size(syst)
for k=2:nsyst
  obj=syst(k)
  if type(obj)=15, if size(obj)>1 then
  select obj(1)
     case 'transfer',
         lboites=[lboites,k]
     case 'link'
         obj2=obj(3)
         if obj2(1)>0 then
            nobj=size(obj)
            is_sortie=[]
            for ko=3:nobj
               objk=obj(ko)
               if objk(1)<0 then is_sortie=[is_sortie,-objk(1)],end
            end;
            if is_sortie=[] then lliens=[lliens,k],
                            else lsorties(1,is_sortie)=k
            end;
                      else lentrees(1,-obj2(1))=k,
         end;
     else error('undefined element')
  end;
  end,end
end;
if mini(lsorties)=0 then error('undefined output'),end
if mini(lentrees)=0 then error('undefined input'),end

function [where]=%connect(bloc,lliens,syst)
//[where]=%connect(bloc,lliens,syst) recherche parmi les liens de syst
//dont les numeros sont donnes dans lliens tous ceux qui arrivent sur
//la sous systeme dont le numero est donne par bloc
//where est une liste dont chaque element est le vecteur:
//      [numero_de_lien,[numeros_des_ports_d'arrive]]
//
//Voir aussi les macros  bloc2exp, blocdext, eval
//!
//origine F. Delebecque s. steer inria 1989
//
where=list();nw=0
nliens=prod(size(lliens))
for l=1:nliens,
         lien=syst(lliens(l));
         nb=size(lien);
         whi=l
         for k=4:nb,
             output=lien(k),
             if bloc=output(1) then whi=[whi,output(2)],end;
         end;
         if prod(size(whi))>1 then nw=nw+1,where(nw)=whi,end
end;

function [where]=out1(bloc,lliens,syst)
//<where>=out1(bloc,lliens,syst)  recherche parmi  les liens  dont les
//numeros sont donnes dans lliens ceux qui sont issus du  sous systeme
//dont le numero est donne par bloc
//where est la matrice : [ [numero_de_lien;numero_du_port_d'origine] ]
//!
//origine f. delebecque s. steer inria 1989
//
where=[];l=0;
for li=lliens
         lien=syst(li)
         nb=size(lien);l=l+1;
         output=lien(3),
         if bloc=output(1) then where=[where,[l;output(2)]],end;
end;
