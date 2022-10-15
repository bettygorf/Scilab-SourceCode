function [x,y,typ]=standard_outputs(o)
//get position of inputs ports and clock inputs port for a standard block
//  the output ports are located on the right (or left if tilded) vertical 
//    side of the block, regularly located from bottom to top
//  the clock output ports are located on the bottom horizontal side 
//     of the block, regularly located from left to right 
//!
graphics=o(2)
model=o(3)
orig=graphics(1);sz=graphics(2);orient=graphics(3);
out=model(3);clkout=model(5);

if orient then
  xo=orig(1)+sz(1)
  dx=sz(1)/7
else
  xo=orig(1)
  dx=-sz(1)/7
end

// output port location
if out==0 then
  x=[];y=[],typ=[]
else
  y=orig(2)+sz(2)-(sz(2)/(out+1))*(1:out)
  x=(xo+dx)*ones(y)
  typ=ones(x)
end

// clock output  port location
if clkout<>0 then
  x=[x,orig(1)+(sz(1)/(clkout+1))*(1:clkout)]
  y=[y,(orig(2)-sz(2)/7)*ones(1,clkout)]
  typ=[typ,-ones(1,clkout)]
end
