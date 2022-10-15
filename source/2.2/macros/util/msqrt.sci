function x=msqrt(a)
//   msqrt - computes the matrix square root. 
//%CALLING SEQUENCE
//   x=msqrt(a)
//%PARAMETERS
//   a   : square hermitian or diagonalizable matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//   This macro is called by the function sqrt to compute square matrix
//   square root.
//!
x=mpow(a,0.5);
