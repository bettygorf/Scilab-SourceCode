function r=%spbhb(a,b)
//  perform logical elementwise and a&b where a is a boolean sparse matrix 
//  and b a boolean matrix
r=a&sparse(b)
