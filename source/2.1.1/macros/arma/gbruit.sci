//<>=gbruit(pas,Tmax,sig)
// genere une macro <b>=bruit(t)
// bruit(t) fonction contante par morceau sur [k*0.1,(k+1)*0.1]
// prenant des valeurs aleatoires tirees selon une loi normale
// d'ecart type sig
//!
rand('normal');
dua_g=sig*rand(0:pas:Tmax);
[nn1,nn2]=size(dua_g);
deff('[b]=bruit(t)','b=dua_g(mini(maxi((t/'+string(Tmax)+...
   ')*'+string(nn2)+',1),'+...
   string(nn2)+'))');
[dua_g,bruit]=resume(dua_g,bruit);
//end


