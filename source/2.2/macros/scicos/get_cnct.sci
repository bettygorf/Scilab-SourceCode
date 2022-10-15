function x=old2new(x)
nx=size(x)
for k=1:nx
  o=x(k)
  if o(1)=='Block' then
    graphics=o(2)
    [ip,op,cip,cop]=get_cnct(x,k)
    graphics(5)=ip
    graphics(6)=op
    graphics(7)=cip
    graphics(8)=cop
    o(2)=graphics
    x(k)=o
  end
end

function [ip,op,cip,cop]=get_cnct(x,k)
//old version of get_connected only use to translate old structures to 
//new style
//look at connected links
nx=size(x)
o=x(k)
graphics=o(2)
[ip,op,cip,cop]=graphics(5:8)
ip=0*ones(ip)
op=0*ones(op)
cip=0*ones(cip)
cop=0*ones(cop)
for i=1:nx
  oi=x(i)
  if oi(1)=='Link' then
    [ct,from,to]=oi(7:9)
    if from(1)==k then
      if ct(2)<>-1 then
	op=[op;i]
      else
	cop=[cop;i]
      end
    elseif to(1)==k then 
      if ct(2)<>-1 then
	ip=[ip;i]
      else
	cip=[cip;i]
      end
    end
  end
end
end
