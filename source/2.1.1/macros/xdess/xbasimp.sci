function xbasimp(win_num,filen,flag)
// xbasimp(win_num,[filen,flag])
// This function will send the recorded graphics of the
// window win_num in the Postscript file filen
// and will print the Postscript file with the 
// command Blpr.
// -filen is optionnal.
// -win_num can be a number which gives the 
// number of the window to save, or a vector
// in which case several files are generated
// one for each window (with names filenxx), and the files are printed 
// on a unique page with the command Blpr.
// -if flag =0 the files are created but not printed 
// -caution : this function will work only if the selected 
// driver is 'Rec'
//!
[lhs,rhs]=argn(0);
n=prod(size(win_num))
win_num=matrix(win_num,1,n);
if rhs<2,filen=TMPDIR+'/scilab.ps';end
if rhs<3,flag=1;end
fname=' ';
for i=1:n,
  fnamel=filen+'.'+string(win_num(i));
  fname=fname+fnamel+' ';
  // don't break next line
  driver('Pos');xinit(fnamel);xtape('replay',win_num(i));driver('Pos');xend();
end
driver('Rec');
// Blpr 'titre' filename1 filename2 ....  lpr
//if flag=1,host('$SCI/bin/Blpr ''  '' '+fname+ ' | lpr');
//  if rhs=1,host('rm -f '+fname);end
// end



