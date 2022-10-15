clear;lines(0);
s=poly(0,'s');
H=[1/s,(s+2)/s/(s+1)^2;1/(s^2*(s+2)),2/(s+2)];
[N,D]=lcmdiag(H);
N/D-H
