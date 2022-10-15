xbasc();xselect();
ystr=['Characteristic exponent (real in [0,2]) ' ;
    'Skewness parameter (real in [-1,1]) ' ;
    'Location parameter (real) ' ;
    'Scale parameter (real) ' ;
    'Sample size (integer) '] ;
w=x_mdialog('Choose Alpha Stable Process parameters',...
    ystr,['1.5';'0';'0';'1';'5000']) 
if w==[],return,end
alpha = evstr(w(1)) ; beta = evstr(w(2)) ; mu = evstr(w(3)) ; 
gama = evstr(w(4)) ; N = evstr(w(5)) ;
[proc,inc] = sim_stable(alpha,beta,mu,gama,N) ;
t = linspace(0,1,N+1) ;
xselect();xbasc();
xsetech([0,0,1,0.5]); 
plot2d(t,proc') 
xtitle('Alpha Stable Process (alpha='+ w(1)+..
    ',beta='+ w(2)+',mu='+ w(3)+',gamma='+ w(4)+')');
xsetech([0,0.5,1,0.5]); 
plot2d(t(1:N),inc') 
xtitle('Alpha Stable Increments (alpha='+ w(1)+..
    ',beta='+ w(2)+',mu='+ w(3)+',gamma='+ w(4)+')');
[param,sd_param] = McCulloch(inc) ;
mat=[param sd_param] ;
labelv=['alpha';'beta';'mu';'gamma'];
labelh=['Mean','Standard Deviation'];
M=string(mat);M=[' ',labelh;[labelv M]];
M=part(M,1:max(length(M))+1);M=M(:,1)+M(:,2)+M(:,3);

x_message(['Estimated Alpha Stable Parameters';' ';M])


