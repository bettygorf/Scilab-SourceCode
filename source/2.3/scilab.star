// Main Scilab initialisation file

mode(-1);  // silent execution mode

// clean database when restarted
predef(0); //unprotect all variables 
clear  // erase all variables 

// Set stack size
newstacksize=1000000;
old=stacksize()
if old(1)<>newstacksize then stacksize(newstacksize),end

// Startup message
t=[' '
' '
'Startup execution:'];
write(%io(2),t)
clear t;

// Special variables definition
%inf=10000.3^10000.3;%nan=%inf-%inf;
%s=poly(0,'s');%z=poly(0,'z');
$=poly(0,'$')
%T=%t;%F=%f;       // boolean variables
SCI=getenv('SCI')  // path of scilab main directory

// Load scilab functions libraries
errcatch(48,'continue');
write(%io(2),'  loading initial environment')
load('SCI/macros/algebre/lib')
load('SCI/macros/arma/lib')
load('SCI/macros/auto/lib')
load('SCI/macros/calpol/lib')
load('SCI/macros/comm/lib')
load('SCI/macros/elem/lib')
load('SCI/macros/metanet/lib')
load('SCI/macros/optim/lib')
load('SCI/macros/percent/lib')
load('SCI/macros/robust/lib')
load('SCI/macros/sci2for/lib')
load('SCI/macros/signal/lib')
load('SCI/macros/tdcs/lib')
load('SCI/macros/util/lib')
load('SCI/macros/xdess/lib')
load('SCI/macros/scicos/lib')
load('SCI/macros/scicos_blocks/lib')
load('SCI/macros/sound/lib')

// Create a temporary directory
TMPDIR=getenv('TMPDIR')

// Protect variable previously defined 
clear ans
predef() 
// Define scicos palettes of blocks
scicos_pal=['Inputs/Outputs','SCI/macros/scicos/Inputs_Outputs.cosf'
      'Linear','SCI/macros/scicos/Linear.cosf';
      'Non linear','SCI/macros/scicos/Non_linear.cosf';
      'Events','SCI/macros/scicos/Events.cosf';
      'Treshold','SCI/macros/scicos/Treshold.cosf';
      'Others','SCI/macros/scicos/Others.cosf';
      'Branching','SCI/macros/scicos/Branching.cosf'];

// calling user initialization
//=============================
//
[startup,ierr]=file('open','home/.scilab','old','formatted');
if ierr==0 then
   exec(startup,-1);file('close',startup);
   clear startup ierr
end

// unix_g is really slow with gcwin32 so we try getenv first 
pwd = getenv('PWD','ndef');
home= getenv('HOME','ndef');
if pwd='ndef', pwd=unix_g('pwd');end 
if home='ndef',home=unix_g('cd; pwd');end 
if home<>pwd then rep='Yes'; else rep='No';end 
// rep=unix_g('x=`pwd`;y=`cd;pwd`;if [ ""$x"" != ""$y"" ]; then echo Yes; else echo No; fi');
if rep=='Yes' then
  [startup,ierr]=file('open','.scilab','old','formatted');
  if ierr==0 then
     exec(startup,-1);file('close',startup);
     clear startup ierr
  end;
end
clear rep 
