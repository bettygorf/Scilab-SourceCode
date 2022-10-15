//[]=hlp()
//% Processus ARMAX 
//armac  : Renvoit une liste Scilab qui decrit un systeme ARMAX
//armap  : Impression d'une liste representant un processus ARMAX
//armax  : Identification : calcule les coefficients d'un ARX n-dimensionnel
//          A(z^-1)y= B(z^-1)u + sig*e(t)
//armax1 : Identification : calcule les coefficients d'un ARMAX 
//          monodimensionnel
//          A(z^-1)y= B(z^-1)u + D(z^-1)sig*e(t)
//epred  : Utilisee par armax1 pour calculer l'erreur de prediction
// 
//arsimul :
//        Simule un ARMAX multidimensionnel
//        Le modele est donne par :
//          A(z^-1) z(k)= B(z^-1)u(k) + D(z^-1)*sig*e(k)
//        Methode : on contruit une representation d'etat
//        et l'on utilise La version modifie de ode avec
//        l'option 'discret' qui simule un syst\`eme discret
//        Auteur : J-Ph. Chancelier ENPC Cergrene
//arspec  
//        Estimation de la puissance spectrale d'un processus
//        ARMA z test de la macro mese 
//narsimul 
//        Simule un ARMAX multidimensionnel
//        Le modele est donne par :
//          A(z^-1) z(k)= B(z^-1)u(k) + D(z^-1)*sig*e(k)
//        On utilise le simulateur de syst\`eme dynamique de Scilab rtitr
// 
//gbruit  
//        genere une macro <b>=bruit(t)
//        bruit(t) fonction contante par morceau sur [k*0.1,(k+1)*0.1]
//        prenant des valeurs aleatoires tirees selon une loi normale
//        d'ecart type sig
// 
//odedi   
//        Tests simples de ode et arsimul
//        Test de l'option discrete de ode
//        x_{n+1}=n*x_{n}, x_{1}=1;
//        remarque sur la syntaxe a utiliser pour l'option discrete
//        utilizer y=ode('discret',y1,1,2:n,macro);y=<y1,y>
//        on a alors dans y=<y1,y2,....,y_n>;
// 
//prbs_a    
//        Tirage de PRBS
//%Exemple tests 
//exar1  
//        Exemple de processus ARMAX ( K.J. Astrom)
//        On simule le processus armax caract\'eris\'e par
//           a=<1,-2.851,2.717,-0.865>
//           b=<0,1,1,1>
//           d=<1,0.7,0.2>
//        exite par un PRBS
//        Et on l'identifie avec armax ( comme le bruit est colore
//        armax doit donner des estimateurs biaises)
//exar2      6
//        Exemple de processus ARMAX ( K.J. Astrom)
//        On simule une version bidimensionnelle
//        de l'exemple exar1();
//exar3      
//        Estimation de la puissance spectrale d'un processus
//        ARMA.  Exemple tire de Sawaragi et all
//        ou ils utilisent m=18
//        test de mese et de arsimul
//!
//end

