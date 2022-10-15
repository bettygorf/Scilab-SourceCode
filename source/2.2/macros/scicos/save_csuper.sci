function save_csuper(x,fpath)
// given a super block definition x save_super creates a file which contains 
// this super block  handling  macro definition
x1=x(1);nam=x1(2);
nin=0;nout=0;clkin=0;clkout=0;
bl='  '
com='/'+'/'
for k=2:size(x)
  o=x(k)
  if o(1)=='Block' then
    select o(5)
    case 'IN_f' then
      nin=nin+1
    case 'OUT_f' then
      nout=nout+1
    case 'CLKIN_f' then
      clkin=clkin+1
    case 'CLKOUT_f' then
      clkout=clkout+1
    end
  end
end
model=list('csuper',nin,nout,clkin,clkout,[],[],..
      x,[],'h',%f,[%f %f])
ppath=getparpath(x,[])

// form text of the macro
txt=[
'function [x,y,typ]='+nam+'(job,arg1,arg2)';
'x=[];y=[],typ=[]';
'select job';
'case ''plot'' then';
'  standard_draw(arg1)';
'case ''getinputs'' then';
'  [x,y,typ]=standard_inputs(arg1)';
'case ''getoutputs'' then';
'  [x,y,typ]=standard_outputs(arg1)';
'case ''getorigin'' then';
'  [x,y]=standard_origin(arg1)';
'case ''set'' then']
if size(ppath)>0 then
  t1=sci2exp(ppath,'ppath')
  txt=[txt;
       '  '+com+' paths to updatable parameters or states'
       bl(ones(size(t1,1),1))+t1;
       '  newpar=list();';
       '  for path=ppath do'
       '    np=size(path,''*'')'
       '    spath=[matrix([3*ones(1,np);8*ones(1,np);path],1,3*np)]'
       '    xx=get_tree_elt(arg1,spath)'+com+' get the block';
       '    execstr(''xxn=''+xx(5)+''(''''set'''',xx)'')'
       '    if ~and(xxn==xx) then '
       '      '+com+' parameter or states changed'
       '      arg1=change_tree_elt(arg1,spath,xxn)'+com+' Update' 
       '      newpar(size(newpar)+1)=path'+com+' Notify modification'
       '    end'
       '  end';
       '  x=arg1'
       '  y=%f';
       '  typ=newpar']
end
model(1)='csuper'
t1=sci2exp(model,'model');
txt=[
   txt;
'case ''define'' then'
   bl(ones(size(t1,1),1))+t1;
'  x=standard_define([2 2],model,'''+nam+''')';
'end']
u=file('open',fpath+'/'+nam+'.sci','unknown')
write(u,txt,'(a)')
file('close',u)
u=file('open',fpath+'/blocknames','unknown')
content=read(fpath+'/blocknames',-1,1,'(a)');
content=stripblanks(content);
fl=%f;for jj=content';if jj==nam then fl=%t;end;end
if ~fl then content=[content;nam];
write(u,content)
end
file('close',u)

