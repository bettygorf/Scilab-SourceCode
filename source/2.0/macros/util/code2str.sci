function str=code2str(c)
// code2str - returns character string associated with scilab integer codes
//!
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
str=emptystr()
na=prod(size(alpha))
nb=prod(size(alphb))

for k=1:prod(size(c))
  if c(k)>=0 then
    cc=c(k)+1
    if cc>na then error(string(c(k))+ 'incorrect code'),end
    str=str+alpha(cc)
  else
    cc=-c(k)+1
    if cc>nb then error(string(c(k))+ 'incorrect code'),end
    str=str+alphb(cc)
  end
end
