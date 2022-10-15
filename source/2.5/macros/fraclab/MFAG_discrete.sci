function [a,f]=MFAG_discrete(n,p)               

// This Software is ( Copyright INRIA . 1998  1 )
// 
// INRIA  holds all the ownership rights on the Software. 
// The scientific community is asked to use the SOFTWARE 
// in order to test and evaluate it.
// 
// INRIA freely grants the right to use modify the Software,
// integrate it in another Software. 
// Any use or reproduction of this Software to obtain profit or
// for commercial ends being subject to obtaining the prior express
// authorization of INRIA.
// 
// INRIA authorizes any reproduction of this Software.
// 
//    - in limits defined in clauses 9 and 10 of the Berne 
//    agreement for the protection of literary and artistic works 
//    respectively specify in their paragraphs 2 and 3 authorizing 
//    only the reproduction and quoting of works on the condition 
//    that :
// 
//    - "this reproduction does not adversely affect the normal 
//    exploitation of the work or cause any unjustified prejudice
//    to the legitimate interests of the author".
// 
//    - that the quotations given by way of illustration and/or 
//    tuition conform to the proper uses and that it mentions 
//    the source and name of the author if this name features 
//    in the source",
// 
//    - under the condition that this file is included with 
//    any reproduction.
//  
// Any commercial use made without obtaining the prior express 
// agreement of INRIA would therefore constitute a fraudulent
// imitation.
// 
// The Software beeing currently developed, INRIA is assuming no 
// liability, and should not be responsible, in any manner or any
// case, for any direct or indirect dammages sustained by the user.
// 
// Any user of the software shall notify at INRIA any comments 
// concerning the use of the Sofware (e-mail : FracLab@inria.fr)
// 
// This file is part of FracLab, a Fractal Analysis Software



// function [a,f]=MFAG_discrete(n,p)
// Discrete Large Deviation spectrum computation on measure: test function
// Christophe Canus 1997 

// display initialization
xbasc();
xset("window",0);
xset("use color",1); 
xset("font",2,0);

// computation of pre-multifractal binomial measure: mu_n
// resolution of the pre-multifractal measure
// n=16;
// parameter of the besicovitch measure
// p=.4;
// synthesis of the pre-multifractal besicovitch 1d measure
[mu_n,I_n]=bm1d(n,p);
// plot the pre-multifractal besicovitch 1d measure
xsetech([0,0,0.5,0.5]);
plot2d(I_n,mu_n,[2]);
xtitle(["Besicovitch pre-multifractal 1d measure n=16, p=.4";" "],"I_n","mu_n");


// computation of coarse Hoelder exponents: ch
// discretization of the unit interval
m=1;
// scale factor
s=1;
ch=mch(mu_n,m,s);
// plot of the coarse Hoelder exponents
xsetech([0.5,0,0.5,0.5]);
plot2d(I_n,ch,[2]);
xtitle(["coarse Hoelder exponents";" "],"I_n","alpha_n");

// computation of the Discrete Large Deviation spectrum: f
//  # of hoelder exponents
N=200; 
// computation of the Discrete Large Deviation spectrum 
[a,f,pdf]=mdfg(mu_n,N,1);
// plot the Probability Density function
xsetech([0,0.5,0.5,0.5]);
plot2d(a,pdf,[5]);
xtitle(["Probability Density function";" "],"alpha","p(alpha)");

// computation of the theoric Hausdorff spectrum
[ta,tf]=bm1ds(N,p);
// plot the theoric Hausdorff spectrum
xsetech([0.5,0.5,0.5,0.5]);
plot2d(ta,tf,[2]);
// plot the Discrete Large Deviation spectrum 
plot2d(a,f,[6]);
xtitle(["Discrete Large Deviation spectrum";" "],"alpha","fg(alpha)");

// back to default values for the sub window
xsetech([0,0,1,1]);
xset("default');
