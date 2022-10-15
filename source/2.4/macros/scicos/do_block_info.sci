function do_block_info(scs_m)
// Copyright INRIA
while %t
  [btn,xc,yc,win,Cmenu]=getclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  kc=find(win==windows(:,2))
  if kc==[] then
    message('This window is not an active palette')
    k=[];break
  elseif windows(kc,1)<0 then //click dans une palette
    kpal=-windows(kc,1)
    palette=palettes(kpal)
    k=getobj(palette,[xc;yc])
    if k<>[] then txt=get_block_info(palette,k),break,end
  elseif win==curwin then //click dans la fenetre courante
    k=getobj(scs_m,[xc;yc])
    if k<>[] then txt=get_block_info(scs_m,k),break,end
  end
end
if %t then
  [u,ierr]=file('open',TMPDIR+'/scs_info','unknown')
  if ierr==0 then
    write(u,txt,'(a)')
    file('close',u)
    if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then 
	out_f = strsubst(TMPDIR,'/','\')+'\scs_info';
  	host(strsubst(SCI,'/','\')+'\bin\xless.exe '+ out_f);
    else 
        unix_s(SCI+'/bin/xless '+TMPDIR+'/scs_info&')
    end
  end
else
  x_message(txt)
end
