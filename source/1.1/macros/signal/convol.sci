function [y,y1]=convol(h,x,y0)
   [lhs,rhs]=argn(0),
   n=prod(size(x)),
   m=prod(size(h)),
   m1=n+m-1;
   x(m1)=0;h(m1)=0;
   if norm(imag(x))==0&norm(imag(h))==0 then
     y=real(fft(fft(matrix(x,1,m1),-1).*fft(matrix(h,1,m1),-1),1)),
   else
     y=fft(fft(matrix(x,1,m1),-1).*fft(matrix(h,1,m1),-1),1),
   end
   if lhs+rhs=5 then,
      y0(n)=0;//update carried from left to right
      y1=y(n+1:n+m-1);
      y=y(1:n)+y0;
   elseif lhs+rhs=4 then,
      if rhs=2 then,
         y1=y(n+1:n+m-1);
         y=y(1:n);//initial update
      else,
         y0(n+m-1)=0;//final update
         y=y(1:n+m-1)+y0;
      end,
   else,
      y=y(1:n+m-1);//no update
   end,



