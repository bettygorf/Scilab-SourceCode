function [stk,nwrk,txt,top]=f_ones(nwrk)
//!purpose
//  Scilab ones function translation
//!parameters
// - stk :
//      On entry stk is a global variable of type list
//      entries indexed from top-1+rhs:top give the definition of the rhs
//      function input variables 
//
//      After execution stk(1:lhs) must contain the definition of the
//      lhs returned variables
//
//      stk entries have the following structure:
//      stk(k)=list(definition,type_expr,type_var,nb_lig,nb_col)
//
//      *definition may be:
//         - a character string containing a Fortran  expression with
//           a scalar value ex:'a+2*b-3*c(1);
//         - a character string containing a reference to the first
//           entry of a Fortran array
//                 'a'           if a is a defined matrix
//                 'work(iwn)'   if  variable is stored in the  double
//	                         precision working array work
//                 'iwork(iiwn)' if  variable is stored in the integer
//	                         working array iwork
//      remark: complex array are defined by a definition part
//                  with 2 elements (real and imaginary parts definition)
//      *type_expr a character string: the expression type code (used
//            to indicate need of parenthesis )
//          '2' : the expression is a sum of terms
//          '1' : the expression is a product of factors
//          '0' : the expression is an atome
//          '-1': the value is stored in a Fortran array
//      *type_var a character string: codes the variable fortran type:
//          '1' : double precision
//          '0' : integer
//          '10': character
//
//      *nb_lig (, nb_col) : character strings:number of rows
//              (columns) of the matrix		
//          des chaines de caracteres

// Copyright INRIA
//
//  nwrk : this variable contain information on working arrays, error
//         indicators. It only may be modified by call to scilab functions
//         outname adderr getwrk
//
//  txt  : is a column vector of character string which contain the
//         fortran code associated to the function translation if
//         necessary.
//  top  : an integer 
//         global variable on entry
//         after execution top must be equal to top-rhs+lhs
//!

txt=[]
select rhs
case 1 then
   s2=stk(top)
   [out,nwrk,txt]=outname(nwrk,'1',s2(4),s2(5))
   txt=[txt;gencall(['dset',mulf(s2(4),s2(5)),'1.0d0',out,'1'])]
   stk=list(out,'-1','1',s2(4),s2(5))
case 2  then
   s1=stk(top-1)
   s2=stk(top)
   [out,nwrk,txt]=outname(nwrk,'1',s1(1),s2(1))
   txt=[txt;gencall(['dset',mulf(s1(1),s2(1)),'1.0d0',out,'1'])]
   stk=list(out,'-1','1',s1(1),s2(1))
   top=top-1
end



