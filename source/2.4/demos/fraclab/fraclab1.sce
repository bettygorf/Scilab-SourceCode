// Synthese Weierstrass generalisee et estimation H(t) par GIFS
xbasc();xselect();
ystr=[ 	'Length (integer) ';
    'Holder: starting value (real in [0,1]) - synthesis - ';
  'Holder: ending value (real in [0,1]) - synthesis - ';
  'Smoothness of Holder fnc (real in [0,1]) - synthesis - ' ;
  'Lambda (positive real)  - synthesis - ' ;
  'Time support (positive real) - synthesis - ' ;
  'Limit type (''slope'',''cesaro'') - estimation - '];
w=x_mdialog('Choose parameters for synthesis and estimation',...
    ystr,['1024';'0.2';'0.8';'0';'2';'1';'slope'])
if w~=[],
  h = AtanH(evstr(w(1)),evstr(w(2)),evstr(w(3)),evstr(w(4))) ;
  x = GeneWei(evstr(w(1)),h,evstr(w(5)),evstr(w(6)),0) ;        
  t = linspace(0,evstr(w(6)),evstr(w(1))) ;
  h_est = alphagifs(x,w(7)) ;        
  xselect();xbasc();
  xsetech([0,0,1,0.5]); 
  plot2d(t',x')
  xtitle('Generalized Weierstrass function '+'(H from '+ w(2)+' to '+ w(3)+' ) ',' ',' ');
  xsetech([0,0.5,1,0.5]); 
  plot2d([t;t]',[h;h_est']')
  xtitle('Holder trajectory (prescribed and estimated)',' ',' ');
end
