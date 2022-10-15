function x=msin(a)
//   msin - computes the matrix sine 
//%CALLING SEQUENCE
//   x=msin(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//This macro is called by the function sin to compute square matrix sine
if norm(imag(a),1)==0 then
x=imag(exp(%i*a))
else
x=-0.5*%i*(exp(%i*a)-exp(-%i*a));
end

