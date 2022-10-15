function [rep]=xdialog(labels,vali)
//
if typeof(labels)<>'character'; write(%io(2),'First arg  must be a string vector');
return;end
if typeof(vali)<>'character'; write(%io(2),'Second arg. must be a string vector');return;end
[m,n]=size(labels);
[m1,n1]=size(vali);
if n<>1, write(%io(2),'First arg. must be a column vector');return;end
if n<>1, write(%io(2),'Second arg. must be a column vector');return;end
rep=sconvert(idialog(sconvert(labels),sconvert(vali)));
return
