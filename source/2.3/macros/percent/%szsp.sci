function r=%szsp(a,b)
// a.\.b with a full b sparse
if a==[] then r=[],return,end
r=sparse(a).\.b

