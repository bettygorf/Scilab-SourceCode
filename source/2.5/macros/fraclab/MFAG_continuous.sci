function [alpha,fgc_alpha]=MFAG_continuous(p,n)

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



// function [alpha,fgc_alpha]=MFAG_continuous(n,p)
// Continuous Large Deviation spectrum computation on measure: test function
// Christophe Canus 1997-1998

// display initialization
xbasc();
xset("window",0);
xset("use color",1); 
xset("font",2,0);

// synthesis of the pre-multifractal binomial 1d measure: mu_n
[mu_n,I_n]=binom(p,'meas',n);
// plot the pre-multifractal binomial 1d measure
xsetech([0,0,0.5,0.5]);
plot2d(I_n,mu_n,[2]);
xtitle(["Binomial 1d measure n=16, p=.4";" "],"I_n","mu_n");

// computation of coarse Hoelder exponents: alpha_eta_x
// # of scale, first and last scale factors
J=4;a=1;A=8;
[alpha_eta_x,eta,x]=mch1d(mu_n,J,a,A,'dec','asym');
// plot of the coarse Hoelder exponents
xsetech([0.5,0,0.5,0.5]);
plot2d(x,alpha_eta_x,[2]);
xtitle(["coarse Hoelder exponents";" "],"x","alpha_eta(x)");

// computation of the continuous Large Deviation spectrum: fgc_alpha
// # of hoelder exponents, precision vector  
N=200;epsilon=zeros(1,N); 
// estimate the continuous large deviation spectrum
[alpha,fgc_alpha,pc_alpha,epsilon_star]=mcfg1d(mu_n,J,a,A,'dec','asym',N,epsilon,'hkern','maxdev','gau','suppdf'); 
// plot the pdf
xsetech([0,0.5,0.5,0.5]);
plot2d(alpha,fgc_alpha,[5]);
xtitle(["";" "],"alpha","pdf(alpha)");

// computation of the theoric Hausdorff spectrum
[talpha,tf_alpha]=binom(p,'spec',N);
// plot the theoric Hausdorff spectrum
xsetech([0.5,0.5,0.5,0.5]);
plot2d(talpha,tf_alpha,[2]);
// plot the Continuous Large Deviation spectrum 
plot2d(alpha,fgc_alpha,[6]);
xtitle(["Continuous Large Deviation spectrum";" "],"alpha","fgc(alpha)");

// back to default values for the sub window
xsetech([0,0,1,1]);
xset("default');
