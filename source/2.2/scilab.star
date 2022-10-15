mode(-1);
predef(0);clear
stacksize(1000000);
//return
t=[' '
' '
'Startup execution:'];
write(%io(2),t)
clear t;
//
%inf=10000.3^10000.3;%nan=%inf-%inf;%s=poly(0,'s');%z=poly(0,'z');
//
errcatch(48,'continue');
write(%io(2),'  loading initial environment')
load('SCI/macros/algebre/lib')
load('SCI/macros/arma/lib')
load('SCI/macros/auto/lib')
load('SCI/macros/calpol/lib')
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
//
SCI=getenv('SCI')
TMPDIR='/tmp/.scilab_'+string(getpid())
%T=%t;%F=%f;
host('umask 000;if test ! -d '+TMPDIR+'; then mkdir '+TMPDIR+'; fi ')
predef()
//
// calling user initialization
//=============================
//
errcatch(240,'continue','nomessage');
startup=file('open','home/.scilab','old','formatted');
if iserror(240)=0 then
   errcatch(240,'kill'); errclear(240);
   exec(startup,-1);file('close',startup);clear startup
else
   errcatch(240,'kill'); errclear(240);
end;
if unix_g('cd;pwd')<>unix_g('pwd') then
  errcatch(240,'continue','nomessage');
  startup=file('open','.scilab','old','formatted');
  if iserror(240)=0 then
     errcatch(240,'kill'); errclear(240);
     exec(startup,-1);file('close',startup);clear startup
  else
     errcatch(240,'kill'); errclear(240);
  end;
end

