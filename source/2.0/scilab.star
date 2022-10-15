mode(-1);
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
//
SCI=getenv('SCI')
TMPDIR='/tmp/.scilab_'+string(getpid())
host('umask 000;if test ! -d '+TMPDIR+'; then mkdir '+TMPDIR+'; fi ')
predef()
//
// calling user initialization
//=============================
//
errcatch(48,'continue','nomessage');
startup=file('open','home/.scilab','old','formatted');
if iserror(48)=0 then
   errcatch(48,'kill'); errclear(48);
   exec(startup,-1);file('close',startup);clear startup
else
   errcatch(48,'kill'); errclear(48);
end;
errcatch(48,'continue','nomessage');
startup=file('open','.scilab','old','formatted');
if iserror(48)=0 then
   errcatch(48,'kill'); errclear(48);
   exec(startup,-1);file('close',startup);clear startup
else
   errcatch(48,'kill'); errclear(48);
end;

