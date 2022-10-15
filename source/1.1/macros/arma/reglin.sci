//[a,b,sig]=reglin(x,y,dflag)
// Solves a linear regression 
// y=a*x+b 
// x and y can be multidimentional 
// x=[ x(1),.....,x(n)]
// y=[ y(1),.....,y(n)]
// sig : noise ``ecart type''
// dflag is optional if 1 a display of the result is done 
//!
[lhs,rhs]=argn(0);
if rhs <=2;dflag=0;end
[n1,n2]=size(x)
[p1,p2]=size(y)
if n2<>p2 then 
	write(%io(2),"[n1,n2]=size(x),[p1,p2]=size(y), n2 must be equal to p2");
	return;
end;
xmoy=[];for i=1:n1;xmoy=[xmoy,sum(x(i,:))/n2];end
ymoy=[];for i=1:p1;ymoy=[ymoy,sum(y(i,:))/n2];end
[la,lb,sig]=armax(0,0,y-ymoy'*ones(1,n2),x-xmoy'*ones(1,n2),0,dflag);
if n1=1;a=lb(1);else a=lb;end
b=ymoy'-a*xmoy';
//end
