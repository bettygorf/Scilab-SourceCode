xbasc();xselect();
mode(1)
ystr=['Number of time samples (integer) - fBm Synthesis ';
    'Holder exponent (real in [0,1]) - fBm Synthesis ' ;
    'Min scale ; Max scale ; Nb of scales (integers) - Wavelet computation ' ;
    'Wavelet type (''Morlet'',''Mexican'') - Wavelet computation '] ;
w=x_mdialog('Choose wavelet decomposition parameters',...
    ystr,['512';'0.5';'1 5 128';'Morlet'])
if w==[] then return,end

N = evstr(w(1)) ; H = evstr(w(2)) ; 
s = evstr(w(3)) ; smin = s(1) ; smax = s(2) ; ns = s(3) ;
WaveType = w(4) ;
t = linspace(0,1,N) ;
if WaveType == 'Morlet' |  WaveType == 'morlet'
  wave = 8*%i ;
elseif WaveType == 'Mexican' | WaveType == 'mexican'  
  wave = 0 ;
else
  break;
end
x = fbmlevinson(N,H) ;
// Next instruction may take a while, please wait
[wt,scale,freq] = contwtmir(x,2^(-smax),2^(-smin),ns,wave) ;

xselect();xbasc();
xsetech([0,0,1,0.5]); 
plot2d(t,x')
xtitle('Fractional Brownian Motion (H = '+ w(2)+')');
xsetech([0,0.5,1,0.5]); 
Zinf = 10^(-28/10) ;
TheMat = (abs(wt).^2) ;
TheMat = TheMat./max(max(TheMat)) ;
TheMat = log10(max(ones(ns,N).*Zinf,TheMat)) ;
viewmat(TheMat,t',linspace(smin,smax,ns)') ;
xtitle('Wavelet transform (wavelet = '+ WaveType+')');

