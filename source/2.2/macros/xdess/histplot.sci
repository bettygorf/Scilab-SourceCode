function histplot(n,data,style,strf,leg,rect,nax)
// histplot(n,data,[style,strf,leg,rect,nax])
// dessine l'histogramme des elements de data repartis en n classes
// equidistantes de valeurs,
//
// histplot(xi,data,[style,strf,leg,rect,nax])
// genere l'histogramme des elements de data repartis dans les classes
// definies par les intervalles ]xi(k) xi(k+1)] .
// xi est suppose strictement  croissant
//
// [style,strf,leg,rect,nax] ont le meme sens que pour plot2d
// Exemple : taper histplot() pour voir un exemple 
//! 
[lhs,rhs]=argn(0)
if rhs<=0, s_mat=['rand(''normal'');';
         'histplot([-6:0.2:6],rand(1,2000),[-1,1],''011'','' '',';
         '[-6,0,6,1.1],[2,12,2,11]);';
         'titre= ''macro histplot : Histogram plot'';';
         'xtitle(titre,''Classes'',''N(C)/Nmax'');'];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs<2 , write(%io(2),'histplot : Wrong number of arguments');
  return;
end;
  p=prod(size(data))
  data=matrix(data,p,1);
//
  q=prod(size(n))
  if q=1 then 
     dmin=mini(data)
     dmax=maxi(data)
     x=(0:n)';
     x=(1/n)*( dmax*x + dmin*(n*ones(x)-x));
   else
     x=matrix(n,q,1)
   end,
   n=prod(size(x));
   deff('[y]=f_hist(k)','y=prod(size(find(data>x(k)&data<=x(k+1))))');
   comp(f_hist);
   y=feval((1:n-1)',f_hist);
   y=[y;y(n-1)]/maxi(y);
   nx=maxi(min(15,prod(size(x))-1),1);
   if rhs <= 5 then 
     rect=[mini(x),mini(y),maxi(x),maxi(y)];
     if rect(2)=rect(4) then rect(2)=0.0;rect(4)=1.1; end
     if q=1 then 
  	rect(1)= rect(1)-abs(x(2)-x(1));rect(3)=rect(3)+abs(x(2)-x(1));nx=nx+2;
     end
   end
  select rhs
   case 7 then plot2d2("gnn",x,y,style,strf,leg,rect,nax);
               plot2d3("gnn",x,y,style,"000");
   case 6 then plot2d2("gnn",x,y,style,strf,leg,rect,[1,nx,2,10]);
               plot2d3("gnn",x,y,style,"000");
   case 5 then plot2d2("gnn",x,y,style,strf,leg,rect,[1,nx,2,10]);
               plot2d3("gnn",x,y,style,"000");
   case 4 then plot2d2("gnn",x,y,style,strf,' ',rect,[1,nx,2,10]);
               plot2d3("gnn",x,y,style,"000");
   case 3 then plot2d2("gnn",x,y,style,"011",' ',rect,[1,nx,2,10]);
               plot2d3("gnn",x,y,style,"000");
   case 2 then plot2d2("gnn",x,y,[-1],"011",' ',rect,[1,nx,2,10]);
               plot2d3("gnn",x,y,[-1,1],"000");
  end
//end



