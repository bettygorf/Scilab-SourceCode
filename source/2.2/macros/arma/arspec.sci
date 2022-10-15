//<>=arspec(z)
//<>=arspec(z)
// Estimation de la puissance spectrale d'un processus
// ARMA z
// test de mese et de arsimul
//!
[lhs,rhs]=argn(0)
m=18
[sm,fr]=mese(z,m);
plot2d([fr]',[20*log(sm/sm(1))/log(10)]', [-1,1],"121",...
   "log(p) : estimee ar");
//end


