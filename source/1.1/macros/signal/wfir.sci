//<wft,wfm,fr>=wfir(ftype,forder,cfreq,wtype,fpar)
//<wft,wfm,fr>=wfir(ftype,forder,cfreq,wtype,fpar)
//Macro which makes linear-phase, FIR low-pass, band-pass,
//high-pass, and stop-band filters
//using the windowing technique.
//Works interactively if called with no arguments.
//  ftype  :Filter type ('lp','hp','bp','sb')
//  forder :Filter order (pos integer)(odd for ftype='hp' or 'sb')
//  cfreq  :2-vector of cutoff frequencies (0<cfreq(1),cfreq(2)<.5)
//         :only cfreq(1) is used when ftype='lp' or 'hp'
//  wtype  :Window type ('re','tr','hm','hn','kr','ch')
//  fpar   :2-vector of window parameters
//         :     Kaiser window: fpar(1)>0 fpar(2)=0
//         :     Chebyshev window: fpar(1)>0 fpar(2)<0 or
//         :                       fpar(1)<0 0<fpar(2)<.5
//  wft    :Time domain filter coefficients
//  wfm    :Frequency domain filter response on the grid fr
//  fr     :Frequency grid
//!
//author: C. Bunks  date: 12 March 1988
 
//check arguments of macro call
 
   [lhs,rhs]=argn(0);
 
//if macro called with no arguments query user for values
 
   if rhs<=0 then,
 
//Query user for filter type and filter length
 
write(%io(2),'Input type of filter to be designed (lp, hp, bp, sb):')
ftype=read(%io(1),1,1,'(a2)')
write(%io(2),'Input filter length (n=pos. integer):')
forder=read(%io(1),1,1);
 
//Select filter type and Query user for cut-off frequencies
 
flag=0;
select ftype
case 'lp' then
   write(%io(2),'Input cut-off frequency (0.[frequ[.5):')
   fl=read(%io(1),1,1);
   fh=0;
case 'hp' then
   write(%io(2),'Input cut-off frequency (0.[fcut[.5):')
   fl=read(%io(1),1,1);
   fh=0;
   flag=1;
case 'bp' then
   write(%io(2),'Input low freqency cut-off (0.[flow[.5):')
   fl=read(%io(1),1,1)
   write(%io(2),'Input high freqency cut-off (0.[flow[fhi[.5):')
   fh=read(%io(1),1,1)
case 'sb' then
   write(%io(2),'Input low freqency cut-off (0.[flow[.5):')
   fl=read(%io(1),1,1)
   write(%io(2),'Input high freqency cut-off (0.[flow[fhi[.5):')
   fh=read(%io(1),1,1)
   flag=1;
else
   error('Unknown filter type --- program termination'),
end
 
if flag=1 then
   if forder-2*int(forder/2)=0 then
      write(%io(2),'*****************************************');
      write(%io(2),'Even length hp and sb filters not allowed');
      write(%io(2),'---Filter order is being incremented by 1');
      write(%io(2),'*****************************************');
      forder=forder+1;
    end
end
 
//Query user for window type and window parameters
 
write(%io(2),'Input window type (re,tr,hm,kr,ch):')
wtype=read(%io(1),1,1,'(a2)');
if wtype='kr' then,
   write(%io(2),'Input beta value of kaiser window (beta]0):');
   fpar(1)=read(%io(1),1,1);
   fpar(2)=0;
else if wtype='ch' then,
   write(%io(2),'The Chebyshev window length is:'),
   write(%io(2),forder),
   write(%io(2),'Input two values the first giving the maximum'),
   write(%io(2),'value of the window side-lobe height the second giving'),
   write(%io(2),'the width of the window main lobe.  These two vaules'),
   write(%io(2),'indicate which of the two Chebyshev window'),
   write(%io(2),'parameters is to be calculated automatically.'),
   write(%io(2),'The parameter to be calculated automatically is indicated'),
   write(%io(2),'by a negative value.  The other parameter takes a value'),
   write(%io(2),'in its appropriate range (i.e., 0[dp or 0[df[.5)'),
   fpar=read(%io(1),1,2),
else
   fpar=[0 0];
end,
end,
 
   else,
      fl=cfreq(1);
      fh=cfreq(2);
   end,
 
//Calculate window coefficients
 
   [win_l,cwp]=window(wtype,forder,fpar);
   [dummy,forder]=size(win_l);
 
//Get forder samples of the appropriate filter type
 
   hfilt=ffilt(ftype,forder,fl,fh);
 
//Multiply window with sinc function
 
   wft=win_l.*hfilt;
 
//Calculate frequency response of the windowed filter
 
   [wfm,fr]=frmag(wft,256);
 
//end


