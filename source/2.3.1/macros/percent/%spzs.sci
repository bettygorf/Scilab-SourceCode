function r=%spzs(a,b)
// a.\.b with a  sparse b full
if b==[] then r=[],return,end
r=a.\.sparse(b)
