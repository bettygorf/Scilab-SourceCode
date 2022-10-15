C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      SUBROUTINE boudif(u,xi,x,z,v)
      IMPLICIT NONE
      DOUBLE PRECISION u(4), xi(10), x(12), z(1), v(4)


C Coefficients physiques
      DOUBLE PRECISION T, rho, Mach, rho0, g, k, R, T0, nu, pcin,
     % Tn, tau, son, dson 

      PARAMETER(rho0=1.2247D0, g=9.81D0, k=0.0065D0, R=287.053D0, 
     % T0=288.15D0, nu=1.4D0)


C Coefficients geometriques et massiques
      DOUBLE PRECISION S, a, b, m

      PARAMETER(S=48.91D0, a=4.89D0, b=11.7D0, m=17870.D0)


C Coefficients aerodynamiques. (cf dossier aerodynamique)
      DOUBLE PRECISION Cx0, Cz0, Cz0p, Cza, Cyb, dCx0, dCz0, dCz0p, dCza, dCyb

      DOUBLE PRECISION Mach_sat, dM, breaks(11)

      INTEGER index(31)

      DOUBLE PRECISION tab_Cx0(4,11), tab_Cz0p(4,11), tab_Cza(4,11), 
     % tab_Cyb(4,11)
     
C Variables forces et derivees
      DOUBLE PRECISION Cx, Cy, Cz, fX, fY, fZ, XV, Xalpha, Xbeta, XFn, Xz, 
     % YV, Yalpha, Ybeta, YFn, Yz, ZV, Zalpha, Zbeta, ZFn, Zz
      
      DOUBLE PRECISION C5, C6, C7, C8, C9, S5, S6, S7, S8, S9 
      

C Variables diverses
      DOUBLE PRECISION Vdot, adot, bdot, d, As(4), invBs(4,4), T1T2(4,4), aux(4)
      INTEGER i,j


C Donnees aerodynamiques
      DATA breaks /0. D0, 0.2 D0, 0.4 D0, 0.6 D0, 0.8 D0, 0.9 D0, 1. D0, 1.2 D0, 1.4 D0, 1.6 D0, 2./

      DATA index /1, 1, 2, 2, 3, 3, 4, 4, 5, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 
     % 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11/

      DATA tab_Cx0 / 
     % -0.02727785481696 D0,  0.01286671289018 D0, -0.00008222838536 D0,  0.01735000000000 D0,
     % -0.02727785481696 D0, -0.00350000000000 D0,  0.00179111419268 D0,  0.01763000000000 D0,
     %  0.17138927408480 D0, -0.01986671289018 D0, -0.00288222838536 D0,  0.01763000000000 D0,
     % -0.53702924152225 D0,  0.08296685156071 D0,  0.00973779934875 D0,  0.01763000000000 D0,
     %  6.64440383449039 D0, -0.23925069335265 D0, -0.02151896900964 D0,  0.01860000000000 D0,
     %-10.33700530539903 D0,  1.75407045699447 D0,  0.12996300735454 D0,  0.02070000000000 D0,
     %  2.69348218333952 D0, -1.34703113462524 D0,  0.17066693959147 D0,  0.04090000000000 D0,
     % -0.49709957044522 D0,  0.26905817537847 D0, -0.04492765225789 D0,  0.04270000000000 D0,
     %  0.05741609844136 D0, -0.02920156688866 D0,  0.00304366944008 D0,  0.04050000000000 D0,
     % -0.00220132105025 D0,  0.00524809217616 D0, -0.00174702550242 D0,  0.04040000000000 D0,
     % -0.00220132105025 D0,  0.00260650691586 D0,  0.00139481413438 D0,  0.04040000000000 D0/

      DATA tab_Cz0p / 
     % -0.11100595601041 D0,  0.05285357360624 D0, -0.00063047648083 D0, -0.10110000000000 D0,
     % -0.11100595601041 D0, -0.01375000000000 D0,  0.00719023824042 D0, -0.10000000000000 D0,
     %  0.69252978005203 D0, -0.08035357360624 D0, -0.01163047648083 D0, -0.10000000000000 D0,
     % -0.15911316419772 D0,  0.33516429442498 D0,  0.03933166768291 D0, -0.10000000000000 D0,
     %  2.17265546601886 D0,  0.23969639590634 D0,  0.15430380574918 D0, -0.08000000000000 D0,
     % -5.65720524822116 D0,  0.89149303571200 D0,  0.26742274891101 D0, -0.06000000000000 D0,
     %  0.87821272860231 D0, -0.80566853875435 D0,  0.27600519860678 D0, -0.03000000000000 D0,
     % -0.08437825546809 D0, -0.27874090159296 D0,  0.05912331053732 D0,                 0 D0,
     %  0.70930029327005 D0, -0.32936785487381 D0, -0.06249844075604 D0,                 0 D0,
     % -0.02722113076329 D0,  0.09621232108821 D0, -0.10912954751316 D0, -0.02000000000000 D0,
     % -0.02722113076329 D0,  0.06354696417226 D0, -0.04522583340897 D0, -0.05000000000000 D0/
  
C Pas de tableau pour Cz0, qui est constant

      DATA tab_Cza / 
     % -2.18506997638370 D0,  1.82979198583023 D0, -0.00005559811070 D0,  3.03300000000000 D0,
     % -2.18506997638370 D0,  0.51875000000001 D0,  0.46965279905535 D0,  3.08870000000000 D0,
     %  9.71284988191838 D0, -0.79229198583021 D0,  0.41494440188931 D0,  3.18590000000000 D0,
     %-13.55382955128981 D0,  5.03541794332082 D0,  1.26356959338743 D0,  3.31490000000000 D0,
     % 32.84107541843301 D0, -3.09687978745308 D0,  1.65127722456098 D0,  3.66060000000000 D0,   
     %-97.06778134310333 D0,  6.75544283807684 D0,  2.01713352962335 D0,  3.82760000000000 D0,
     % 44.36974140063025 D0,-22.36489156485415 D0,  0.45618865694562 D0,  3.99980000000000 D0,
     % -3.71229135460975 D0,  4.25695327552400 D0, -3.16539900092041 D0,  3.55140000000000 D0,
     % -1.95807598219124 D0,  2.02957846275816 D0, -1.90809265326398 D0,  3.05890000000000 D0,
     % -0.18070477096063 D0,  0.85473287344342 D0, -1.33123038602367 D0,  2.74280000000000 D0,
     % -0.18070477096063 D0,  0.63788714829066 D0, -0.73418237733003 D0,  2.33550000000000 D0/

      DATA tab_Cyb / 
     %  0.32090534703370 D0, -0.18379320822022 D0, -0.00157757223730 D0, -0.57700000000000 D0,
     %  0.32090534703370 D0,  0.00875000000000 D0, -0.03658621388135 D0, -0.58210000000000 D0,
     % -1.72952673516844 D0,  0.20129320822022 D0,  0.00542242776269 D0, -0.58650000000000 D0,
     %  2.28470159364004 D0, -0.83642283288085 D0, -0.12160349716943 D0, -0.59120000000000 D0,
     % -6.84313732453499 D0,  0.53439812330318 D0, -0.18200843908497 D0, -0.63070000000000 D0,
     % 23.42772415661137 D0, -1.51854307405732 D0, -0.28042293416038 D0, -0.65040000000000 D0,
     %-25.22887525779279 D0,  5.50977417292609 D0,  0.11870017572649 D0, -0.67020000000000 D0,
     % 30.67163455970305 D0, -9.62755098174958 D0, -0.70485518603821 D0, -0.62790000000000 D0,
     %-16.72016298101941 D0,  8.77542975407225 D0, -0.87527943157367 D0, -0.90860000000000 D0,
     %  0.49183938426793 D0, -1.25666803453941 D0,  0.62847291233290 D0, -0.86640000000000 D0,
     %  0.49183938426793 D0, -0.66646077341790 D0, -0.14077861085003 D0, -0.78460000000000 D0/
     

C Environnement physique (l'altitude est egale a -x(3))
      T = T0 + k*x(3)
      Tn = T/T0
      tau= g/(k*R) - 1.D0
      rho = rho0*Tn**tau
      son=Sqrt(nu*R*T)
      dson=(2*(nu*R*T)**(3/2))
      Mach = x(4)/son
      pcin = rho*S*x(4)**2/2.D0

C Coefficients aerodynamiques caclules par interpolation par splines cubiques
      Mach_sat = MIN(3.D0,Mach)
      Mach_sat = MAX(0.D0,Mach_sat)
      i = 10*Mach_sat+1
      i = index(i)
      dM = Mach_sat-breaks(i)

      Cx0 = ((tab_Cx0(1,i)*dM+tab_Cx0(2,i))*dM + tab_Cx0(3,i))*dM + tab_Cx0(4,i)
      Cz0 = -0.1D0
      Cz0p = ((tab_Cz0p(1,i)*dM+tab_Cz0p(2,i))*dM + tab_Cz0p(3,i))*dM + tab_Cz0p(4,i)
      Cza = ((tab_Cza(1,i)*dM+tab_Cza(2,i))*dM + tab_Cza(3,i))*dM + tab_Cza(4,i)
      Cyb = ((tab_Cyb(1,i)*dM+tab_Cyb(2,i))*dM + tab_Cyb(3,i))*dM + tab_Cyb(4,i)

      dCx0= ( 3*tab_Cx0(1,i)*dM+2*tab_Cx0(2,i) )*dM + tab_Cx0(3,i)
      dCz0 = 0.D0
      dCz0p= ( 3*tab_Cz0p(1,i)*dM+2*tab_Cz0p(2,i) )*dM + tab_Cz0p(3,i) 
      dCza= ( 3*tab_Cza(1,i)*dM+2*tab_Cza(2,i) )*dM + tab_Cza(3,i) 
      dCyb= ( 3*tab_Cyb(1,i)*dM+2*tab_Cyb(2,i) )*dM + tab_Cyb(3,i) 

      Cx = Cx0 + (Cz0 - Cz0p + Cza*x(5))**2
      Cy = Cyb*x(6)
      Cz = Cz0 + Cza*x(5)


C Forces et derivees partielles      
      C5=cos(x(5))
      C6=cos(x(6))
      C7=cos(x(7))
      C8=cos(x(8))
      C9=cos(x(9))
      S5=sin(x(5))
      S6=sin(x(6))
      S7=sin(x(7))
      S8=sin(x(8))
      S9=sin(x(9))

      fX = -pcin*Cx + C6*g*m*C5*z(1)
      fY = pcin*Cy + g*m*S6*C5*z(1)
      fZ = -pcin*Cz - g*m*S5*z(1)

      XV = -(rho0*S*Tn**tau*x(4)*Cx) - rho0*S*Tn**tau*x(4)**2*(dCx0/son 
     % + 2*(Cz0 - Cz0p + Cza*x(5))*(-(dCz0p/son) + dCza*x(5)/son))/2
     
      Xalpha = -(Cza*rho0*S*Tn**tau*x(4)**2*(Cz0 - Cz0p + Cza*x(5))) - 
     % C6*g*m*S5*z(1)
     
      Xbeta = -(C5*g*m*S6*z(1))
      
      XFn = C5*C6*g*m
      
      Xz = -(k*tau*rho0*S*Tn**(-2 + g/(k*R))*x(4)**2*Cx)/(2*T0) - 
     % rho0*S*Tn**tau*x(4)**2*(-(dCx0*k*nu*R*x(4))/dson + 
     % 2*(Cz0 - Cz0p + Cza*x(5))*(dCz0p*k*nu*R*x(4)/dson - 
     % dCza*k*nu*R*x(4)*x(5)/dson))/2
     
      YV = Cyb*rho0*S*Tn**tau*x(4)*x(6) + 
     % dCyb*rho0*S*Tn**tau*x(4)**2*x(6)/(2*son)
     
      Yalpha = -(g*m*S5*S6*z(1))
      
      Ybeta = Cyb*rho0*S*Tn**tau*x(4)**2/2 + C5*C6*g*m*z(1)
      
      YFn = C5*g*m*S6
      
      Yz = Cyb*k*tau*rho0*S*Tn**(-2 + g/(k*R))*x(4)**2*x(6)/(2*T0) - 
     % dCyb*k*nu*R*rho0*S*Tn**tau*x(4)**3*x(6)/
     % (4*(nu*R*(T0 + k*x(3)))**(3/2))
     
      ZV = -(dCza*rho0*S*Tn**tau*x(4)**2*x(5))/(2*son) - 
     % rho0*S*Tn**tau*x(4)*Cz
     
      Zalpha = -(Cza*rho0*S*Tn**tau*x(4)**2)/2 - C5*g*m*z(1)
      
      Zbeta = 0
      
      ZFn = -(g*m*S5)
      
      Zz = dCza*k*nu*R*rho0*S*Tn**tau*x(4)**3*x(5)/
     % (4*(nu*R*(T0 + k*x(3)))**(3/2)) - 
     % k*tau*rho0*S*Tn**(-2 + g/(k*R))*x(4)**2*Cz/(2*T0)


C Changement de coordonnes
      xi(1) = x(1)
      xi(4) = x(2)
      xi(7) = x(3)
      xi(2) = C7*C8*x(4)
      xi(5) = C7*S8*x(4)
      xi(8) = -S7*x(4)
      xi(3) = (C7*C8*fX + C8*C9*fZ*S7 - C9*fY*S8 + C8*fY*S7*S9 + fZ*S8*S9)/m
      xi(6) = (C8*C9*fY + C7*fX*S8 + C9*fZ*S7*S8 - C8*fZ*S9 + fY*S7*S8*S9)/m
      xi(9) = g + (C7*C9*fZ - fX*S7 + C7*fY*S9)/m
      xi(10) = x(6)


C Bouclage
      Vdot = fX/m - g*S7
      adot = (C7*C9*g + fZ/m)/(C6*x(4))
      bdot = fY/(m*x(4)) + C7*g*S9/x(4)

C As
      As(1) = (-(bdot*fY) - adot*C6*fZ + adot*Xalpha + bdot*Xbeta + Vdot*XV - S7*Xz*x(4))/m
      As(2) = (bdot*fX + adot*fZ*S6 + adot*Yalpha + bdot*Ybeta + Vdot*YV - S7*Yz*x(4))/m
      As(3) = (adot*C6*fX - adot*fY*S6 + adot*Zalpha + bdot*Zbeta + 
     % Vdot*ZV - S7*Zz*x(4))/m
      As(4) = bdot

C Inverse de Bs
      d = fY*(XFn*Yalpha - Xalpha*YFn) + fZ*(XFn*Zalpha - Xalpha*ZFn)
      invBs(1, 1) = (m*YFn*Zalpha - m*Yalpha*ZFn)/d
      invBs(1, 2) = (-(m*XFn*Zalpha) + m*Xalpha*ZFn)/d
      invBs(1, 3) = (m*XFn*Yalpha - m*Xalpha*YFn)/d
      invBs(1, 4) = (XFn*Ybeta*Zalpha - Xbeta*YFn*Zalpha - 
     % XFn*Yalpha*Zbeta + Xalpha*YFn*Zbeta + Xbeta*Yalpha*ZFn - 
     % Xalpha*Ybeta*ZFn)/d
      invBs(2, 1) = (-(fY*m*YFn) - fZ*m*ZFn)/d
      invBs(2, 2) = fY*m*XFn/d
      invBs(2, 3) = fZ*m*XFn/d
      invBs(2, 4) = (-(fY*XFn*Ybeta) + fY*Xbeta*YFn - fZ*XFn*Zbeta + 
     % fZ*Xbeta*ZFn)/d
      invBs(3, 1) = 0
      invBs(3, 2) = 0
      invBs(3, 3) = 0
      invBs(3, 4) = (fY*XFn*Yalpha - fY*Xalpha*YFn + fZ*XFn*Zalpha - 
     % fZ*Xalpha*ZFn)/d
      invBs(4, 1) = (fY*m*Yalpha + fZ*m*Zalpha)/d
      invBs(4, 2) = -(fY*m*Xalpha/d)
      invBs(4, 3) = -(fZ*m*Xalpha/d)
      invBs(4, 4) = (-(fY*Xbeta*Yalpha) + fY*Xalpha*Ybeta - 
     % fZ*Xbeta*Zalpha + fZ*Xalpha*Zbeta)/d

C T1T2
      T1T2(1, 1) = C5*C6
      T1T2(1, 2) = 0
      T1T2(1, 3) = S5
      T1T2(1, 4) = 0
      T1T2(2, 1) = S6
      T1T2(2, 2) = 1
      T1T2(2, 3) = 0
      T1T2(2, 4) = 0
      T1T2(3, 1) = C6*S5
      T1T2(3, 2) = 0
      T1T2(3, 3) = -C5
      T1T2(3, 4) = 0
      T1T2(4, 1) = 0
      T1T2(4, 2) = 0
      T1T2(4, 3) = 0
      T1T2(4, 4) = 1

      u(1) = C7*C8*v(1) + C7*S8*v(2) - S7*v(3) - As(1)
      u(2) = -(C9*S8*v(1)) + C8*S7*S9*v(1) + C8*C9*v(2) + S7*S8*S9*v(2) + C7*S9*v(3) - As(2)
      u(3) = C8*C9*S7*v(1) + S8*S9*v(1) + C9*S7*S8*v(2) - C8*S9*v(2) + C7*C9*v(3) - As(3)
      u(4) = v(4) - As(4)

      DO 300 i=1,4
      aux(i) = 0
         DO 300 j=1,4
         aux(i) = aux(i) + invBs(i,j)*u(j)
300   CONTINUE

      DO 400 i=1,4
      u(i) = 0
         DO 400 j=1,4
         u(i) = u(i) + T1T2(i,j)*aux(j)
400   CONTINUE
   
   
      RETURN
      END
      
      
