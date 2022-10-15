// Synthese binomiale et estimation du spectre multifractal 
// par Gdes Deviations
xbasc();xselect();
ystr=['weight (2-D vector of reals in [0,1]) - Synthesis ';
    'number of cascades (integer) - Synthesis ' ;
    'Min scale ; Max scale ; Nb scales (integers) - Estimation ' ;
    'Scale progression (''dec'',''log'',''lin'') - Estimation '  ;
    'Ball type (''asym'',''cent'',''star'') - Estimation ' ; 
    'Holder sampling rate (integer) - Estimation ' ] ;
w=x_mdialog('Choose Binomial measure parameters',...
    ystr,['0.3 0.7';'10';'1 8 4';'dec';'cent';'200'])
if w~=[],
  n = 2.^(evstr(w(2))) ;
  Lim = evstr(w(3)) ; J = Lim(3) ; N = evstr(w(6)) ;
  [mu,I] = multim1d(2,evstr(w(1)),'meas',evstr(w(2))) ;
  [alpha,f_alpha] = multim1d(2,evstr(w(1)),'spec',N) ;
  xselect();xbasc();
  xsetech([0,0,1,0.5]); 
  plot2d(I',mu')
  xtitle('Multinomial measure (Weight =[ '+ w(1)+'])');
  [a,fa] = mcfg1d(mu,Lim,w(4),w(5),N,zeros(1,N), ...
      'hkern','maxdev','gau','suppdf') ;
  xsetech([0,0.5,1,0.5]); 
  plot2d([alpha;a]',[f_alpha;fa(J,:)]')
  xtitle('Multifractal spectrum (theoretical and estimated)');
end
