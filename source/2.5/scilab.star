// Main Scilab initialisation file
// Copyright INRIA

mode(-1);  // silent execution mode

// clean database when restarted
predef(0); //unprotect all variables 
clear  // erase all variables 
clear %helps scicos_pal // explicitly clear %helps scicos_pal variables
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
ieee(2);%inf=1/0;ieee(0);%nan=%inf-%inf;

%s=poly(0,'s');%z=poly(0,'z');
$=poly(0,'$')

%T=%t;%F=%f;       // boolean variables
SCI=getenv('SCI')  // path of scilab main directory
if getenv('WIN32','NO')=='OK' then
  WSCI=getenv('WSCI')  // path of scilab main directory for Windows
end

// Load scilab functions libraries
errcatch(48,'continue');
write(%io(2),'  loading initial environment')
load('SCI/macros/mtlb/lib')
load('SCI/macros/int/lib')
load('SCI/macros/algebre/lib')
load('SCI/macros/arma/lib')
load('SCI/macros/auto/lib')
load('SCI/macros/calpol/lib')
load('SCI/macros/comm/lib')
load('SCI/macros/elem/lib')
load('SCI/macros/metanet/lib')
load('SCI/macros/optim/lib')
load('SCI/macros/robust/lib')
load('SCI/macros/sci2for/lib')
load('SCI/macros/signal/lib')
load('SCI/macros/tdcs/lib')
load('SCI/macros/util/lib')
load('SCI/macros/xdess/lib')
load('SCI/macros/sound/lib')
load('SCI/macros/fraclab/lib')
load('SCI/macros/percent/lib')

// Create a temporary directory
TMPDIR=getenv('TMPDIR')

PWD = getcwd()
home= getenv('HOME','ndef');
if home=='ndef',home=unix_g('cd; pwd');end 

// use MSDOS syntax?
MSDOS = %f
if getenv('WIN32','NO')=='OK' & (getenv('COMPILER','NO')=='VC++' | getenv('COMPILER','NO')=='ABSOFT') then
  MSDOS = %t
end


// Protect variable previously defined 
clear ans
predef('all') 

//Scilab Help Chapters 

%helps =['/man/programming'	,'Scilab Programming';
	'/man/graphics'		,'Graphic Library';
	'/man/elementary'	,'Utilities and Elementary Functions';
	'/man/linear'		,'Linear Algebra';
	'/man/polynomials'	,'Polynomial calculations';
	'/man/dcd'		,'Cumulative Distribution Functions; Inverses, grand';
	'/man/control'		,'General System and Control macros';
	'/man/robust'		,'Robust control toolbox';
	'/man/nonlinear'	,'Non-linear tools (optimization and simulation)';
	'/man/signal'		,'Signal Processing toolbox';
	'/man/fraclab'		,'Fractal Signal Analysis';
	'/man/arma'		,'Arma modelisation and simulation toolbox';
	'/man/metanet'		,'Metanet: graph and network toolbox';
	'/man/scicos'		,'Scicos: Bloc diagram editor and simulator';
	'/man/sound'		,'wav file handling';
	'/man/translation'	,'Language or data translations';
	'/man/pvm'		,'PVM parallel toolbox';
	'/man/comm'		,'GECI communication toolbox';
	'/man/tdcs'		,'TdCs';
	'/man/tksci'		,'TCL/Tk interface']

%helps=[ SCI+%helps(:,1),%helps(:,2)];
clear %c_a_c

// Define scicos palettes of blocks
scicos_pal=['Inputs_Outputs','SCI/macros/scicos/Inputs_Outputs.cosf'
      'Linear','SCI/macros/scicos/Linear.cosf';
      'Non_linear','SCI/macros/scicos/Non_linear.cosf';
      'Events','SCI/macros/scicos/Events.cosf';
      'Treshold','SCI/macros/scicos/Treshold.cosf';
      'Others','SCI/macros/scicos/Others.cosf';
      'Branching','SCI/macros/scicos/Branching.cosf'];
// define graphics mode for Scicos (with or without scroll bar) 
MODE_X = 1 // one meens with

// calling user initialization
//=============================
// Home dir
[startup,ierr]=file('open','home/.scilab','old','formatted');
if ierr==0 then
   exec(startup,-1);file('close',startup);
   clear startup ierr
end
// working dir
if  home<>PWD then
  [startup,ierr]=file('open','.scilab','old','formatted');
  if ierr==0 then
     exec(startup,-1);file('close',startup);
     clear startup ierr
  end;
end
