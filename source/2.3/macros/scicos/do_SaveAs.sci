function [scs_m,edited]=do_SaveAs()
//
if pal_mode then scs_m=do_purge(scs_m),end
fname=xgetfile('*.cos')
if fname==emptystr() then return,end

[path,name,ext]=splitfilepath(fname)
select ext
case 'cos' then
  ok=%t
else
  message('Only *.cos binary files allowed');
  return
end


// open the selected file
errcatch(240,'continue','nomessage')
u=file('open',fname,'unknown','unformatted')
errcatch(-1)
if iserror(240)==1 then
  message('Directory write access denied')
  errclear(240)
  return
end

// set initial state in cpr if necessary
if cpr<>list() then
  cpr;cpr(1)=state0
end

drawtitle(scs_m(1))  //erase the old title
scs_m;
scs_m(1)(2)=[name,path] // Change the title

// save
save(u,scicos_ver,scs_m,cpr)
file('close',u)

drawtitle(scs_m(1))  // draw the new title

edited=%f
if pal_mode then update_scicos_pal(path,scs_m(1)(2)(1),fname),end


    
