function [palettes,windows]=do_palettes(palettes,windows)
kpal=x_choose(scicos_pal(:,1),'Choose a Palette')
if kpal==0 then return,end

lastwin=curwin
winpal=find(windows(:,1)==-kpal) 


if winpal==[] then  //selected palettes isnt loaded yet
  curwin=get_new_window(windows)
  windows=[windows;[-kpal curwin]]
  palettes=add_palette(palettes,scicos_pal(kpal,2),kpal)
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

if part(graph,1:4)='SCI/' then 
  graph=getenv('SCI')+'/'+part(graph,5:length(graph))
end

//Check if the graph file exists
errcatch(240,'continue','nomessage')
u=file('open',graph,'old')
errcatch(-1)
if iserror(240)==1 then
  errclear(240)
  drawobjs(palettes(kpal))
  if pixmap then xset('wshow'),end
  xsave(graph)
else
  xload(graph)
end
  
if pixmap then xset('wshow'),end
xset('window',lastwin)

