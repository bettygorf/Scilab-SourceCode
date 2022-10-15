function do_export(scs_m,fname)
[lhs,rhs]=argn(0)
wpar=scs_m(1)(1)
winc=xget('window');
if rhs==1 then
  fname= xgetfile('*')  
end
// remove blanks and apostrophe
ff=str2code(fname);ff(find(ff==40|ff==53))=[];fname=code2str(ff)
//
if fname<>emptystr() then 
  disablemenus()
//  wdm12=round(xget('wdim').*wech)
dr=driver()
driver('Pos')
xinit(fname)

  options=scs_m(1)(7)
  set_background()
  

  rwi=600;rhi=400;
//  xset('wdim',rwi,rhi),
//  xset('alufunction',3);xbasc();xselect();xset('alufunction',6);xclear()
//  wdm=round(xget('wdim').*wech)
wdm=[rwi,rhi]
  aa=scs_m(1)(1)(1)/scs_m(1)(1)(2)
  rr=rwi/rhi	
  if aa>rr then 
    scs_m(1)(1)(6)=scs_m(1)(1)(6)*aa/rr
  else
    scs_m(1)(1)(5)=scs_m(1)(1)(5)/(aa/rr)
  end
  scs_m(1)(1)(1)=wdm(1);scs_m(1)(1)(2)=wdm(2);
  scs_m(1)(1)(3)=-(scs_m(1)(1)(5)-wpar(5))/2+scs_m(1)(1)(3)//(scs_m(1)(1)(5)/wpar(5))
  scs_m(1)(1)(4)=-(scs_m(1)(1)(6)-wpar(6))/2+scs_m(1)(1)(4)//(scs_m(1)(1)(6)/wpar(6))
  wdm=scs_m(1)(1)
  xsetech([-1 -1 8 8]/6,[wdm(3),wdm(4),wdm(3)+wdm(5),wdm(4)+wdm(6)])
  drawobjs(scs_m),
  if pixmap then xset('wshow'),end
//  xbasimp(winc,fname)
xend()
driver(dr)
if getenv('WIN32','NO')=='OK' then
  rep=unix_g(''"'+SCI+'/bin/BEpsf'" -landscape '+fname)
else
  rep=unix_g(SCI+'/bin/BEpsf -landscape '+fname)
end
  if rep<>[] then x_message(['Problem generating ps file.';..
	'perhaps directory not writable'] );end
//  xset('wdim',wdm12(1),wdm12(2)),
  enablemenus()
end

