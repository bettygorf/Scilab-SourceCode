//[]=addinter(files,spname,fcts)
// ajoute un ensemble de primitives definies dans un fichier 
// d'interface.
//Syntaxe
//   addinter(files,spname,fcts)
//
// spname : chaine de caractere  de 6 caracteres maximum 
//          contenant le nom du sous programme d'interface que l'on 
//          veut ajouter
// files  : chaine de caracteres donnant les fichiers objets
//          ou les librairies qui definissent le sous programme
//          spname. chaque fichier est separe par un caractere blanc
// fcts   : vecteur de chaines de caracteres donnant le nom des 
//          primitives definies dans spname (dans l'ordre des valeurs
//          du parametre fin
//!
//origine S Steer INRIA 1992
//
link(files,spname)

ki=find(link()==part(spname,1:20));

nfcts=prod(size(fcts))
for k=1:nfcts
  clearfun(fcts(k))
  newfun(fcts(k),10000*ki+k)
end
//end
