function c=str2code(str)
// str2code - return scilab integer codes associated with a character string
//!
if prod(size(str))<>1 then 
  error('Not implemented for vector of strings')
end
alpha=['0','1','2','3','4','5','6','7','8','9',..
       'a','b','c','d','e','f','g','h','i','j',..
       'k','l','m','n','o','p','q','r','s','t',..
       'u','v','w','x','y','z','_','#','!','0',..
       ' ','(',')',';',':','+','-','*','/','\',..
       '=','.',',','''','[',']','%','|','&','<','>','~',..
       '^']

alphb=['0','1','2','3','4','5','6','7','8','9',..
       'A','B','C','D','E','F','G','H','I','J',..
       'K','L','M','N','O','P','Q','R','S','T',..
       'U','V','W','X','Y','Z','0','0','?','0',..
       '0','0','0','0','0','0','0','0','0','$',..
       '0','0','0','""','{','}','0','0','0','`','0','@',..
       '0']
c=[]
for k=1:length(str)
  l=find(alpha==part(str,k))
  if l<>[] then 
    c=[c,l(1)-1]
  else
    l=find(alphb==part(str,k))
    c=[c,-l(1)+1]
  end
end
