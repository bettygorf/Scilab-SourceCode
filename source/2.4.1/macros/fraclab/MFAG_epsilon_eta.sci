function lp_norm=MFAG_epsilon_eta(mu_n,N,s,e,norm_type);

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



// function lp_norm=MFAG_epsilon_eta(mu_n,N,s,e,norm_type)
//
// Computes a matrix of the norm of the difference 
// of computed Continuous Large Deviation spectrum 
// of a 1d pre-multifractal measure
// with varying scale: eta(i) (related to the scale factor (s: eta=s*eta_n)
// and varying precision epsilon: e(j) (e)
//
// inputs : 	mu_n: input 1d pre-multifractal measure
//		(normalized strictly positive vector)
//		N: # of hoelder exponents
//		(strictly positive integer scalar)
//		s: scale factor 
//		(strictly positive vector)
//		e: set the precision epsilon of the pdf 
//		(strictly positive scalar)
//		norm_type: type of the Lp norm
//		(1,2,inf,-inf,P)
//
// outputs :   

// lp_norm matrix is [n-1,m*m]
// where [height,n]=size(s) and [height,m]=size(e)

// set nu_n, eta_n, m, n, lp_norm, f1, f2
[height,width]=size(mu_n);
nu_n=max(height,width);
eta_n=1./nu_n;
[height,m]=size(e);
[height,n]=size(s);
lp_norm=zeros(n-1,m*m);
f1=zeros(m,N);
f2=zeros(m,N);

// compute lp_norm
for j=1:m
	[a,f]=mcfge(mu_n,N,2,s(1),e(j));
	f1(j,:)=f;
end
for i=2:n
	for j=1:m
		[a,f]=mcfge(mu_n,N,2,s(i),e(j));
		f2(j,:)=f;
		for k=1:m
			diff=abs(f2(j,:)-f1(k,:));
			lp_norm(i-1,m*(j-1)+k)=norm(diff,norm_type);
		end
	end
	f1=f2;	
end

// plot lp_norm on figure(1) with grayplot
eta_i=eta_n.*s(2:n);
epsilon=e(1).*[1:m*m];
grayplot(epsilon,eta_i,lp_norm');

// return results
return;


