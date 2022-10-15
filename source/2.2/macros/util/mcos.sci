function x=mcos(a)
//   mcos - computes the matrix cosine 
//%CALLING SEQUENCE
//   x=mcos(a)
//%PARAMETERS
//   a   : square hermitian or diagonalizable matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//This macro is called by the function cos to compute square matrix cosine
//!
if norm(imag(a),1)==0 then
x=real(exp(%i*a))
else
x=0.5*(exp(%i*a)+exp(-%i*a));
end



