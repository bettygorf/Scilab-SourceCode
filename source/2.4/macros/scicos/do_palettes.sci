function [palettes,windows]=do_palettes(palettes,windows)
kpal=x_choose(scicos_pal(:,1),'Choose a Palette')
if kpal==0 then return,end

lastwin=curwin
winpal=find(windows(:,1)==-kpal) 

// Copyright INRIA

if winpal==[] then  //selected palettes isnt loaded yet
  curwin=get_new_window(windows)
  if or(curwin==winsid()) then
    xdel(curwin);xset('window',curwin)
  end
  windows=[windows;[-kpal curwin]]
  palettes=add_palette(palettes,scicos_pal(kpal,2),kpal)
//palettes=do_version(palettes,scicos_ver)
else //selected palettes is already loaded 
  curwin=windows(winpal,2)
end
//
xset('window',curwin),xselect();
xset('alufunction',3)
if pixmap then xset('pixmap',1),end,xbasc();
wsiz=palettes(kpal)(1)(1)
xset('wdim',wsiz(1),wsiz(2))
Xshift=wsiz(3);Yshift=wsiz(4);
xsetech([-1 -1 8 8]/6,[Xshift,Yshift,Xshift+wsiz(1),Yshift+wsiz(2)])

fname=scicos_pal(kpal,2)
lf=length(fname)
if part(fname,lf-3:lf)=='.cos' then
  graph=part(fname,1:lf-4)+'.pal'
elseif part(fname,lf-4:lf)=='.cosf' then
  graph=part(fname,1:lf-5)+'.pal'
else
  graph=fname+'.pal'
end

if part(graph,1:4)=='SCI/' then 
  graph=getenv('SCI')+'/'+part(graph,5:length(graph))
end

//Check if the graph file exists
[u,ierr]=file('open',graph,'old')
file('close',u)
options=default_options()
//[#Color3D,With3D]=set3D(palettes(kpal))
if ierr<>0 then
  drawobjs(palettes(kpal))
  if pixmap then xset('wshow'),end
  xsave(graph)
else
  xload(graph)
end
xinfo('Palette: may be used to copy  blocks or regions')  
if pixmap then xset('wshow'),end
xset('window',lastwin)

