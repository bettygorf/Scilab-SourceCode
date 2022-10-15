function []=xs2fig(win_num,filen)
//[]=xs2fig(win_num,filen)
// This function will send the recorded graphics of the
// window win_num in file filen for Xfig 
// -caution : this function will work only if the selected 
// driver is "Rec"
//!
driver("Fig");
xinit(filen);
xtape('replay',win_num);
xend();
driver('Rec');
//end


