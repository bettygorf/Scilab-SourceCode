//[a,b,sig]=reglin(x,y,dflag)
// Solves a linear regression 
// y=a(p,q)*x+b(p,1) + epsilon 
// x : matrix (q,n) and y matrix (p,n) 
// sig : noise standard deviation 
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
// We use armax for apropriate orders which will perform 
// nothing but a least square 
// We could directly call pinv or \
[la,lb,sig]=armax(0,0,y-ymoy'*ones(1,n2),x-xmoy'*ones(1,n2),0,dflag);
if n1=1;a=lb(1);else a=lb;end
b=ymoy'-a*xmoy';
//end
