//<>=odedi()
//<>=odedi()
// Tests simples de ode et arsimul
// Test de l'option discrete de ode
// x_{n+1}=n*x_{n}, x_{1}=1;
deff('[xnp1]=ttt(n,xn)','xnp1=(xn**2);');
// remarque sur la syntaxe a utiliser pour l'option discrete
// utilizer y=ode('discret',y1,1,2:n,macro);y=<y1,y>
// on a alors dans y=<y1,y2,....,y_n>;
//!
write(%io(2),"Test de ode et arsimul")
ero_n=0
y=ode('discret',2,1,2:4,ttt);y=[2,y];
if y=[2,4,16,256] then 
  v=1;
else 
   write(%io(2),"[1]probleme avec ode option discrete");ero_n=ero_n+1
end
// autre test
y=arsimul([1],[1],[0],0,1:10);
if y=(1:10) then
  v=1; 
else 
  write(%io(2),"[2]probleme avec ode option discrete");ero_n=ero_n+1
end
y=arsimul([1],[0,1],[0],0,1:10);
if y=[0,1:9] then 
   v=1; 
else 
 write(%io(2),"[3]probleme avec ode option discrete");ero_n=ero_n+1
end
y=arsimul([1],[0,1],[0],0,1:10,[-5]);
if y=[-5,1:9] then 
 v=1;
else 
   write(%io(2),"[4]probleme avec ode option discrete");ero_n=ero_n+1
end
if ero_n=0,write(%io(2),"Pas d''erreur detectees");end

//end


