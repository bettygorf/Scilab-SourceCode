      SUBROUTINE CARETE (NU,NT,NS,MA,NA,NAF,K,LMA)
C--------------------------------------------------------------
C   BUT: CONSTRUIRE LES ARETES D'UNE TRAINGULATION
C--------------------------------------------------------------
C IN:
C       NU(1:3,1:NT) SOMMETS DES TRIANGLE
C       NT : NB DE TRIANGLE
C       NS : NB DE SOMMET
C       LMA : NB DE MOT DU TABLEAU MA > 3*NA 
C               ET NA = NT+NS-1 + NB TROU DANS L'OUVERT 
C OUT:      
C     MA(1:3,1:NA)   TABLEAU DES ARETES DU MAILLAGE
C                   (MA(1,I),MA(2,I))  2 SOMMETS DE L'ARETE I
C                    MA(3,I) = 0 => L'ARETE I EST INTERNE 
C                              1 => L'ARETE I EST FRONTIERE
C     NA  :  NB D'ARETE                                
C     NAF : NB D'ARETE FRONTIERE
C
C  WORK
C     K(1:NS) TABLEAU DE TRAVAIL 
C--------------------------------------------------------------
      DIMENSION NU(3,NT),MA(3,1),K(NS)
      DIMENSION KA(2,3)
      DATA KA/1,2,2,3,3,1/
      NA=0
      DO 10 I=1,NS
10      K(I)=0
      DO 100 IT=1,NT
       DO 100 IS=1,3
        K1=NU(KA(1,IS),IT)
        K2=NU(KA(2,IS),IT)
        KX=MAX(K1,K2)
        KI=MIN(K1,K2)
        IP=K(KX)
        IP1=0
20       IF(IP.EQ.0) GOTO 60
         IP1=IP
         IP=MA(3,IP)
         IF(MA(1,IP1).NE.KI.AND.MA(2,IP1).NE.KI) GOTO 20
         MA(1,IP1)=-MA(1,IP1)
         GOTO 100
60      CONTINUE
        IF(LMA.LE.NA*3) GOTO 10000
        NA=NA+1
        MA(1,NA)=K1
        MA(2,NA)=K2
        MA(3,NA)=0
        IF(IP1.EQ.0) THEN
         K(KX)=NA
         ELSE
         MA(3,IP1)=NA
         END IF
100   CONTINUE
      NAF=0
      DO 200 IA=1,NA
       IF(MA(1,IA).LT.0) THEN
        MA(1,IA)=-MA(1,IA)
        MA(3,IA)=0
        ELSE
        MA(3,IA)=1
        NAF=NAF+1
        END IF
200   CONTINUE
      LMA=NA*3
      RETURN
10000 CONTINUE
C     CALL TILT CLG
      STOP
      END

