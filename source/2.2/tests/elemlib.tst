t=toeplitz(1:5,1:2:7);t1=[1 3 5 7;2 1 3 5;3 2 1 3;4 3 2 1;5 4 3 2];
if norm(t-t1)>10*%eps then pause,end
t=toeplitz(1:5);t1=[1 2 3 4 5;2 1 2 3 4;3 2 1 2 3;4 3 2 1 2;5 4 3 2 1];
if norm(t-t1)>10*%eps then pause,end
if toeplitz([])<>[] then pause,end
 
 s=poly(0,'s');
t=toeplitz([s s+1 s**2 1-s]);
t1=[s 1+s s*s 1-s;1+s s 1+s s*s;s*s 1+s s 1+s;1-s s*s 1+s s]
if norm(coeff(t-t1))>10*%eps then pause,end
 
t=toeplitz(['1','2','3','4']);
t1=['1','2','3','4';'2','1','2','3';'3','2','1','2';'4','3','2','1']
if t<>t1 then pause,end
