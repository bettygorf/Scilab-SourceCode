function f=newest(f1,f2)
// given to files names f1 and f2 newest returns 
// the name of the newest file if both exits 
// or name of existing file 
// or []
//!
f=unix_g('ls -t -1 '+f1+' '+f2+ ' 2>/dev/null |sed -n -e ''1p'' ')

