clear;lines(0);
 s=poly(0,'s')
 sysdiag(rand(2,2),1/(s+1),[1/(s-1);1/((s-2)*(s-3))])
 sysdiag(tf2ss(1/s),1/(s+1),[1/(s-1);1/((s-2)*(s-3))])

 s=poly(0,'s')
 sysdiag(rand(2,2),1/(s+1),[1/(s-1);1/((s-2)*(s-3))])
 sysdiag(tf2ss(1/s),1/(s+1),[1/(s-1);1/((s-2)*(s-3))])
