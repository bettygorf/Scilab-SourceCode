//[stk,nwrk,txt,top]=f_sin(nwrk)
//!
nam='sin'
txt=[] 
s2=stk(top)
if s2(4)<>s2(5)|(s2(4)=='1'&s2(5)=='1') then
  v=s2(1)
  it2=prod(size(v))-1
  if it2==0 then
    [stk,nwrk,txt,top]=f_gener(nam,nwrk)
  else
     error(nam+' d''un argument complexe non traduit')
  end
else
  error(nam+'d''une matrice carre non traduit')
end
//end


