function [x,y,typ]=standard_inputs(o)
//get position of inputs ports and clock inputs port for a standard block
//  the input ports are located on the left (or rigth if tilded) vertical 
//    side of the block, regularly located from top to bottom 
//  the clock input ports are located on the top horizontal side 
//    side of the block, regularly located from left to right 
graphics=o(2)
model=o(3)
orig=graphics(1);sz=graphics(2);orient=graphics(3);
inp=model(2);clkinp=model(4);
if orient then
  xo=orig(1)
  dx=-sz(1)/7
else
  xo=orig(1)+sz(1)
  dx=sz(1)/7
end

if inp==0 then
  x=[];y=[],typ=[]
else
  y=orig(2)+sz(2)-(sz(2)/(inp+1))*(1:inp)
  x=(xo+dx)*ones(y)
  typ=ones(x)
end
if clkinp<>0 then
  x=[x,orig(1)+(sz(1)/(clkinp+1))*(1:clkinp)]
  y=[y,(orig(2)+sz(2)/7+sz(2))*ones(1,clkinp)]
  typ=[typ,-ones(1,clkinp)]
end

