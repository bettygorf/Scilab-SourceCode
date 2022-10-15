function f=%srp(m,p)
//f=M/p  M:scalar matrix p=polynomial
//!
[mp,np]=size(p)
if mp*np<>1 then 
  f=m*invr(p),
else
  [l,c]=size(m)
  if mp==-1&l*c==1|l=-1 then
    f=tlist(['r','num','den','dt'],m,p*eye,[])
  else
    f=simp(tlist(['r','num','den','dt'],m,p*ones(l,c),[]))
  end
end

