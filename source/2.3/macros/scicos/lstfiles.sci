function lst=lstfiles(path,opt)
// lstfiles - retourne les noms des fichiers correspondants a un filtre
//%Syntaxe
//  lst=lstfiles(path [,opt])
//%Parametres
// path   : chaine de caractere donnant la regle de selection des fichiers
//          par defaut on recherche tous les fichier du repertoire courant
// lst    : vecteur de chaines de caractere donnant les path-name des
//          fichiers
// opt    : chaine de caracteres pouvant valoir 'file' (defaut),'dir','all'
//          permettant de selectionner uniquement les fichiers de type
//          correspondant.
//!
[lhs,rhs]=argn(0)
if rhs<1 then path=' ',end
if rhs<=1 then opt='file',end
[np,mp]=size(path);np=np*mp;path=matrix(path,np,1);
lst=[]
for k=1:np
  cmd='ls -F -c '+path(k)
  host(cmd+'>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err')
  lst=[lst;read(TMPDIR+'/unix.out',-1,1,'(a)')]
end
if prod(size(lst))==0 then lst=[],end
n=prod(size(lst))
if n==0 then return,end
isdir=[]
for k=1:n
  last=part(lst(k),length(lst(k)))
  if last=='/' then
    isdir(k)=%t
    lst(k)=part(lst(k),1:length(lst(k))-1)
  else
    if last=='*'|last=='@' then lst(k)=part(lst(k),1:length(lst(k))-1),end
    isdir(k)=%f
  end
end
if opt=='file' then
  lst=lst(find(~isdir))
elseif opt='dir' then
  lst=lst(find(isdir))
end


















