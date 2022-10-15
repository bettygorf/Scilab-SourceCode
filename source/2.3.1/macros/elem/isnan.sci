function r=isnan(x)
if x==[] then
  r=[]
else
  r=~(x==x)
end
