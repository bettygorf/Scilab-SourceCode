function []=xbasr(win_num)
// This function is used to redraw the content of the graphic 
// window win_num. It works only with the driver "Rec"
//!
// Copyright INRIA
cw=xget("window");
xclear(win_num);xset("window",win_num);xtape('replay',win_num);
xset("window",cw);


