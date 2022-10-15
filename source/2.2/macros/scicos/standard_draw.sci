function standard_draw(o)
//
graphics=o(2);label=graphics(4)
model=o(3);nin=model(2);nout=model(3);clkin=model(4);clkout=model(5)

[orig,sz,orient]=graphics(1:3)
thick=xget('thickness');xset('thickness',2)
// draw box
xrect(orig(1),orig(2)+sz(2),sz(1),sz(2))
// draw input/output ports
//------------------------
if orient then  //standard orientation
  // set port shape
  out=[0  -1/14
       1/7 0
       0   1/14]
  in= [-1/7  -1/14
        0    0
       -1/7   1/14]
  dy=sz(2)/(nout+1)
  for k=1:nout
    xfpoly(sz(1)*out(:,1)+ones(3,1)*(orig(1)+sz(1)),..
        sz(2)*out(:,2)+ones(3,1)*(orig(2)+sz(2)-dy*k),1)
  end
  dy=sz(2)/(nin+1)
  for k=1:nin
    xfpoly(sz(1)*in(:,1)+ones(3,1)*orig(1),..
      sz(2)*in(:,2)+ones(3,1)*(orig(2)+sz(2)-dy*k),1)
  end
else //tilded orientation
  out=[0  -1/14
       -1/7 0
       0   1/14]
  in= [1/7  -1/14
       0    0
       1/7   1/14]
  dy=sz(2)/(nout+1)
  for k=1:nout
    xfpoly(sz(1)*out(:,1)+ones(3,1)*orig(1),..
        sz(2)*out(:,2)+ones(3,1)*(orig(2)+sz(2)-dy*k),1)
  end
  dy=sz(2)/(nin+1)
  for k=1:nin
    xfpoly(sz(1)*in(:,1)+ones(3,1)*(orig(1)+sz(1)),..
        sz(2)*in(:,2)+ones(3,1)*(orig(2)+sz(2)-dy*k),1)
  end
end
// draw input/output clock ports
//------------------------
// set port shape
out= [-1/14  0
     0      -1/7
     1/14   0]
 
in= [-1/14  1/7
     0      0
     1/14   1/7]
 
dx=sz(1)/(clkout+1)
pat=xget('pattern')
xset('pattern',10)
for k=1:clkout
  xfpoly(sz(1)*out(:,1)+ones(3,1)*(orig(1)+k*dx),..
      sz(2)*out(:,2)+ones(3,1)*orig(2),1)
end
dx=sz(1)/(clkin+1)
for k=1:clkin
  xfpoly(sz(1)*in(:,1)+ones(3,1)*(orig(1)+k*dx),..
      sz(2)*in(:,2)+ones(3,1)*(orig(2)+sz(2)),1)
end
xset('pattern',pat)
//Draw text legend
xstring(orig(1),orig(2)-(2*sz(2)/5),label)
xset('thickness',thick)

