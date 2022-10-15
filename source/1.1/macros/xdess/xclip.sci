//[]=xclip(x,y,w,h)
// fixe une zone de clipping en cordonnees reelles
// (x,y,w,h) (Upper-Left,wide,Height)
//!
[lhs,rhs]=argn(0)
if rhs<=0, xset('clipping-p',-1,-1,200000,200000);return;end;
if rhs=1,xset('clipping',x(1),x(2),x(3),x(4));
else xset('clipping',x,y,w,h);end
//end

