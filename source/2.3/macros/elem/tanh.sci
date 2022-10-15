function t=tanh(x)
//Element wise Hyperbolic tangent
if type(x)<>1 then error(53),end
t=exp(x);
t=(t-ones(t)./t)./(t+ones(t)./t)



