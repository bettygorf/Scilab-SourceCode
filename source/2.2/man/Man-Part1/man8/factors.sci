.TH factors 8 "April 1993" "Scilab Group" "Scilab Function"
.so man1/sci.an 
.SH NAME
factors - numeric real factorization
.SH CALLING SEQUENCE
.nf
[lnum,g]=factors(pol [,'flag'])
[lnum,lden,g]=factors(rat [,'flag'])
.fi
.SH PARAMETERS
.TP
pol
: real polynomial
.TP
rat
: real rational polynomial (\fVrat=pol1/pol2\fR)
.TP
lnum
: list of polynomials (of degrees 1 or 2)
.TP
lden
: list of polynomials (of degrees 1 or 2)
.TP
g
: real number
.TP
flag
: character string \fV'c'\fR or \fV'd'\fR
.SH DESCRIPTION
returns the factors of polynomial \fVpol\fR in the list \fVlnum\fR
and the "gain" g.
.LP
One has pol= g times product of entries of the list lnum.
If argument of \fVfactors\fR is a 1x1 rational \fVrat=pol1/pol2\fR, 
the factors of the numerator \fVpol1\fR and the denominator \fVpol2\fR 
are returned in the lists \fVlnum\fR and \fVlden\fR respectively.
.LP
The "gain" is returned as \fVg\fR.
.LP
If \fVflag\fR is \fV'c'\fR (resp. \fV'd'\fR), the roots of \fVpol\fR 
are refected wrt the imaginary axis (resp. the unit circle), i.e. 
the factors in \fVlnum\fR are stable polynomials.
.LP
Same thing if \fVfactors\fR is invoked with a rational arguments:
the entries in \fVlnum\fR and \fVlden\fR are stable polynomials.



