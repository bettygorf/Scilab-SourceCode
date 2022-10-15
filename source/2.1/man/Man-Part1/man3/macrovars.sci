.TH mac2for 1 "April 1993" "Scilab Group" "Scilab Function"
.so man1/sci.an
.SH NAME
mac2for - macro to fortran routine conversion
.SH CALLING SEQUENCE
.nf
[txt]=mac2for(lst,vtps)
.fi
.SH PARAMETERS
.TP 10
lst
: list
.TP 10
vtps
: list
.TP 10
txt
: string (fortran code)
.SH DESCRIPTION
\fVlst\fR is the output of Scilab's primitive \fVmacr2lst\fR
which converts a compiled macro into a list which codes the internal representation of
the macro. Thus, \fVmac2for\fR is usually invoked as:
.nf
txt=mac2for(macr2lst(macro),vtps).
.fi
The elements of the list \fVvtps\fR give the type and dimensions 
of variables of the calling sequence :
.nf
vtps(i)=list(typ,row_dim,col_dim)
.fi
where :
.RS
.TP
typ
: is a character string giving the type of the variable :
.RS
.TP 
"0" 
: constant,integer vector or matrix
.TP
"1" 
: constant,double precision vector or matrix
.TP
"10"
: character string
.RE
.TP
row_dim 
: character string (row dimension)
.TP
col_dim 
: character string (column dimension)
.RE
.TP
txt
: fortran code
.LP
.SH REMARKS
the following keyword :
.nf
 work,iwork,ierr
 iw*  iiw*      
 ilbN   (N integer)          
.fi
may not appear in the macro code.
.SH SEE ALSO
macro
