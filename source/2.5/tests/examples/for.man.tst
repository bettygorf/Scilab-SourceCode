clear;lines(0);
n=5;
for i = 1:n, for j = 1:n, a(i,j) = 1/(i+j-1);end;end
for j = 2:n-1, a(j,j) = j; end; a
for  e=eye(3,3),e,end  
for v=a, write(6,v),end        
for j=1:n,v=a(:,j), write(6,v),end 
for l=list(1,2,'example'); l,end 
