function [Q]=orth(A)
// Orthogonal basis for the span of A.
// Range(Q) = Range(A) and Q'*Q=eye
//!
[X,n]=colcomp(A);
Q=X(:,1:n);


