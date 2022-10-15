// test de gsort : a Finir pour ind ds le cas 'l' 
// a faire ensuite marcher pour vecteur complexes 

N=3,P=2

a=int(10*rand(N,P));

[a1,ind]=gsort(a,'g');
uu=maxi(abs(a(ind)-matrix(a1,N*P,1)))

[a1,ind]=gsort(a,'r');   
uu=0.0;for i=1:N,uu=uu+maxi(abs(a(i,ind(i,:))-a1(i,:)));end
     

[a1,ind]=gsort(a,'c')   ;                      
uu=0.0;for i=1:P,uu=uu+maxi(abs(a(ind(:,i),i)-a1(:,i)));end
uu

[a1,ind]=gsort(a,'lc');                   
uu=0.0;uu=uu+maxi(abs(a(:,ind(:,1)')-a1));
uu

[a1,ind]=gsort(a,'lr') ;        
uu=0.0;uu=uu+maxi(abs(a(ind(:,1)',:)-a1));
uu


// String sorts 
N=3,P=2

a=string(int(10*rand(N,P)));

[a1,ind]=gsort(a,'g');
[a1,ind]=gsort(a,'r');   
[a1,ind]=gsort(a,'c')   ;                      
[a1,ind]=gsort(a,'lc');                   
[a1,ind]=gsort(a,'lr') ;        


