function palettes=add_palette(palettes,path,kpal)
path=stripblanks(path(:))
n=size(path,1)
for k=size(palettes)+1:max(kpal), palettes(k)=list(),end
for k=1:n
  pk=path(k)
  lp=length(pk)
  if pk==emptystr()
  elseif part(pk,lp-4:lp)=='.cosf' then
    exec(pk,-1);
    palettes(kpal(k))=scs_m
  elseif part(pk,lp-3:lp)=='.cos' then
    load(pk)
    palettes(kpal(k))=scs_m
  else
    message('Unknown palette file type '+pk)
  end
end
