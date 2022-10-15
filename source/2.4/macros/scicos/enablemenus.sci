function enablemenus(men)
// Copyright INRIA
[lhs,rhs]=argn()
curwin=xget('window')
if rhs<1 then men=menus(1),end
for k=1:size(men,'*')
  setmenu(curwin,men(k))
end
