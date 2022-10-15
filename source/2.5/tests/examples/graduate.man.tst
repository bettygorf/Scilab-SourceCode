clear;lines(0);
  y=(0:0.33:145.78)';
  xbasc();plot2d1('enn',0,y)
  [ymn,ymx,np]=graduate(mini(y),maxi(y))
  rect=[1,ymn,prod(size(y)),ymx];
  xbasc();plot2d1('enn',0,y,1,'011',' ',rect,[10,3,10,np])
