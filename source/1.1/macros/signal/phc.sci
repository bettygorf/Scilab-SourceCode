//<H,F,G>=phc(hk,d,r)
//<H,F,G>=phc(hk,d,r)
//macro which computes the matrices H, F, G by the principal hankel
//component approximation method, from the hankel matrix built
//from the covariance sequence of a stochastic process.
//   hk  : hankel matrix
//   d   : dimension of the observation
//   r   : desired dimension of the state vector
//       : for the approximated model
//   H,F,G  : relevant matrices of the state-space model
//!
//author G. Le Vey  Date: 16 Febr. 1989
 
   [p,q]=size(hk);
   [u,s,v]=svd(hk);
   s=diag(sqrt(diag(s(1:r,1:r))));
   obs=u(:,1:r)*s;
   g=s*v(:,1:r)';
   g=g(:,1:d);
   ofl=obs(d+1:p,:);opr=obs(1:p-d,:);
   f=opr\ofl;
   h=obs(1:d,:);
//end


