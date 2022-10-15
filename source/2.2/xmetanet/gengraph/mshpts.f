      SUBROUTINE MSHPTS(CR,C,NU,NBS,TRI,FRONT,LFRONT,NBT,IOP,ERR)
C-----------------------------------------------------------------------
C BUT DU SOUS-PROGRAMME MSHPTS:
C
C     CONSTRUIRE UNE TRIANGULATION  2D A PARTIR D'UN ENSEMBLE DE
C     POINTS ET D'UNE FRONTIERE DE DOMAINE DECRITE PAR SES COMPOSANTES
C     CONNEXES
C-----------------------------------------------------------------------
C     ENTREES :
C     ---------
C        CR             TABLEAU DES COORDONNEES DES POINTS C(1:2,1:NBS)
C        NBS            NOMBRE DE POINTS
C        FRONT          TABLEAU DEFINISANT LA FRONTIERE
C                       PAR COMPOSANTES CONNEXES DE LA FRONTIERE (I1,I2)
C                       FRONT(I1)=FRONT(I2)
C                       FRONT(I+1) EST LE POINT FRONTIERE SUIVANT DE
C                       FRONT(I) POUR I=I1,I2-1 TELLE QUE LA NORMALE A
C                       LA FRONTIERE SOIT INTERNE ( LA  COMPOSANTE
C                       CONNEXE EXTERIEURE TOURNE DANS LE SENS TRIGO )
C        LFRONT         EST LA LONGUEUR DU TABLEAU FRONT
C        IOP            OPTION DE TRACE ET D'IMPRESSION
C                                 -----      ----------
C                       (IOP < 10           ==> PAS DE GRAPHIQUE)
C                       IMPRE = MOD(IOP,10)
C                       IMPRE = 0 => PAS IMPRESSION
C                       IMPRE > 4 => LE RESULTAT EST IMPRIME
C                       IMPRE > 5 => DEBUG
C
C                       SI IOP > 9  ==> GRAPHIQUE
C                       UN TRACE EST FAIT A LA FIN
C                       SI IOP > 29  LES  POINTS SONT TRACES EN PLUS
C                       SI IOP > 49  ON  TRACE  TOUS LES MOUVEMENTS
C                                    DE TRIANGLE
C                       SI IOP > 99 UN (CR) EST ATTENDU APRES CHAQUE
C                                  TRIANGLE TRAITE
C----------------------------------------------------------------------
C        LE GRAPHIQUE UTILISE FORTRAN-3D : ROUTINES  (INIT ET FERMETURE
C                                                    A L EXTERIEUR)
C
C   CLEAN   : EFFACEMENT DE L ECRAN
C   DEBFAC  : DEBUT DE DESCRIPTION DE FACETTE POLYGONALE
C   FENTR2  : FENETRE D AFFICHAGE EN CM (XMIN,XMAX,YMIN,YMAX)
C   FINFAC  : FIN DE DESCRIPTION DE FACETTE
C   LIGH3   : CARACTERISTIQUES GRAPHIQUES ,COULEUR EN PARTICULIER
C   LIN2TO  : TRACE DU POINT COURANT AU POINT DONNE ( COORD  EN CM)
C   MASQU2  : DEFINITION DU MASQUE RECTANGULAIRE SUR OBJET A AFFICHER
C   MOV2TO  : POSITIONNEMENT DE LA "PLUME" AU POINT DONNE
C   SZSCRN  : RETOURNE LES DIMENSIONS DE L ECRAN ( EN CM)
C   TXT2D   : AFFICHAGE DE TEXTE
C----------------------------------------------------------------------
C        TABLEAUX DE TRAVAIL
C             C(2,NBS) TABLEAU D'ENTIERS (COPIE DE COORDONNEES)
C             TRI(4*NBS-4) TABLEAU D'ENTIERS
C             NU (6*(2*NBS-2)) TABLEAU D ENTIERS CONTIENDRA LE TABLEAU
C                              DES CONNECTIVITES ( AU DEBUT) A LA SORTIE
C                              DU SP
C
C     SORTIES :
C     ---------
C           NBT          NOMBRE DE TRIANGLES GENERES
C           NU(1:3,NBT)  SOMMETS DES TRIANGLES (TABLEAU DES CONNECTIONS)
C                        (!! NU A DIMENSIONNER EN ENTREE NU(1:6*(2*NBS-2))
C           ERR          SI ERR = 0 ALORS PAS DE PROBLEME  (OK)
C                        SINON NBT = 0 ET PAS DE TRIANGULATION
C           C(1:2,NBS)   COORDONNEES DES SOMMETS ( EN ENTIER)
C                        LE TABLEAU CR N EST PAS MODIFIE
C-----------------------------------------------------------------------
C HECHT-MARROCCO  INRIA-ROCQUENCOURT  (39 63 55 14)
C-----------------------------------
      INTEGER NBS,NBT,LFRONT
      INTEGER C(2,NBS),TRI(4*NBS-4),FRONT(LFRONT),NU(6*(NBS+NBS-2))
      INTEGER IOP,ERR
      REAL CR(2,NBS)
      INTEGER I,J,K,TETE,IMPRE,I1,I2
      CHARACTER*3 CH3
C
      IMPRE=MOD(IOP,10)
      ERR = 0
      NBT = 0
      IF(NBS.LT.3) THEN
        ERR = 1
        PRINT *,'FATAL ERROR MSHPTS : LE NOMBRE DE POINTS ',NBS
     &         ,' EST < ',3
        RETURN
      ENDIF
C-------------------------
C PREPARATION DES DONNEES
C-------------------------
      CALL MSHTRI (CR,C,NBS,TRI,TRI(NBS+1),IOP,ERR)
      IF(ERR.NE.0) RETURN
      IF(IOP.GE.50) THEN
C---------------------------------
C GRAPHIQUE: EFFACEMENT DE L ECRAN
C---------------------------------
        CALL CLEAN
      ENDIF
C--------------------------------
C MAILLAGE DE L ENVELOPPE CONVEXE
C--------------------------------
      CALL MSHCXI (C,NU,TRI,NBS,TETE,IOP,ERR)
      IF(ERR.NE.0) RETURN
C
      DO 10 I=1,NBS
      TRI(I)=0
10    CONTINUE
      IF(IMPRE.GT.4)  PRINT *,'FRONTIERE CONVEXE TETE =',TETE
      I=TETE
20    CONTINUE
      IF(IMPRE.GT.4) THEN
        PRINT *,I,' S = ',NU(6*(I-1)+1),' T = ',NU(6*(I-1)+2)/8
     &         ,' A= ',MOD(6*(I-1)+2,8),' PRECEDENT =',NU(6*(I-1)+3)
      ENDIF
      J=NU(6*(I-1)+4)
      TRI(NU(6*(I-1)+1))=NU(6*(J-1)+1)
      I=J
      IF(I.NE.TETE) GOTO 20
C ----------------------------
C TRAITEMENT FRONTIERE
C-----------------------------
      IF(IMPRE.GE.4)  PRINT *,' LES ELEMENTS '
      K=0
      IF(LFRONT.GT.0) THEN
      CALL MSHFRT(C,NU,NBS,FRONT,LFRONT,TRI,IOP,ERR)
      IF(ERR.NE.0) RETURN
      DO 30 I=1,NBS
      TRI(I)=0
30    CONTINUE
      K  = 0
      I2 = 0
      DO 40 I=1,LFRONT
      I1=I2
      I2=FRONT(I)
      IF(I1.EQ.K) THEN
      K = -I2
      ELSEIF(I1.EQ.-K) THEN
      K=-K
      TRI(I1)=I2
      ELSE
      TRI(I1)=I2
      ENDIF
40    CONTINUE
      ENDIF
      IF(IOP.GE.10)THEN
C-----------------------------------------------------------------
C GRAPHIQUE: EFFACEMENT DE L ECRAN ET CHOIX DE LA COULEUR DE TRACE
C-----------------------------------------------------------------
        CALL CLEAN
        CALL LIGH3(-1,-1,215)
      ENDIF
C------------------------------------------
C     CONSTRUCTION DU TABLEAU NU(1:3,1:NBT)
C------------------------------------------
      NBT=0
      K = 0
      DO 200 J=1,6*(NBS+NBS-2),6
      IF(NU(J+5).NE.0) THEN
      NBT=NBT + 1
      DO 190 I=0,2
      K=K+1
      NU(K)=NU(J+I)
190   CONTINUE
C-------------------------------------------------
C  GRAPHIQUE :EFFACEMENT ET TRACE NOUVEAU TRIANGLE
C-------------------------------------------------
      IF(IOP.GE.10) CALL MSHDRW (C,NU,6,(J+5)/6,IOP)
C
      IF(IMPRE.GT.4) PRINT '(7I12)',(J+5)/6,(NU(J+I),I=0,5)
      ENDIF
200   CONTINUE
      IF(IOP.GE.30) THEN
C------------------------------------------------------------
C GRAPHIQUE: ON INSCRIT LE NUMERO DU NOEUD ( <999  FORMAT I3)
C------------------------------------------------------------
       DO 210 I=1,NBS
        WRITE (CH3,'(I3)') I
        CALL TXT2D(CH3,3,FLOAT(C(1,I)),FLOAT(C(2,I)))
210    CONTINUE
      ENDIF
      END
C**********************************************************************
      INTEGER FUNCTION MSHLCL(C,NU,TETE,S,NBS)
      INTEGER NBS,C(2,NBS),NU(6,NBS+NBS-2),TETE,S
      INTEGER X,Y,PT,PPT,DET
      LOGICAL INIT
C
      X=C(1,S)
      Y=C(2,S)
      INIT=.TRUE.
      PT=TETE
10    CONTINUE
      PPT=PT
      PT=NU(4,PT)
      IF(PT.NE.TETE) THEN
      DET=X*C(2,NU(1,PT)) -Y*C(1,NU(1,PT))
      IF(DET.LT.0) THEN
      INIT=.FALSE.
      GOTO 10
      ELSEIF(INIT.AND.DET.EQ.0) THEN
      GOTO 10
      ENDIF
      ENDIF
      MSHLCL=PPT
      END
C**********************************************************************
      SUBROUTINE MSHDRW (C,NU,I6,T,IOP)
      INTEGER I6,C(2,*),NU(I6,*),T,I1,I2,I3,IOP
      REAL X,Y
      CHARACTER*3 CH3
C----------------------------------
C EFFACEMENT DU TRIANGLE  (FACETTE)
C 0 EST LA COULEUR DU FOND !
C---------------------------
      CALL LIGH3 (-1,-1,0)
      CALL DEBFAC(0)
      CALL MOV2TO(FLOAT(C(1,NU(1,T))),FLOAT(C(2,NU(1,T))))
      CALL LIN2TO(FLOAT(C(1,NU(2,T))),FLOAT(C(2,NU(2,T))))
      CALL LIN2TO(FLOAT(C(1,NU(3,T))),FLOAT(C(2,NU(3,T))))
      CALL FINFAC
C-------------------------------------------------------
C SI IOP>89 ON ECRIT AU BARYCENTRE LE NUMERO DU TRIANGLE
C AVEC LA COULEUR 5
C------------------
      I1=NU(1,T)
      I2=NU(2,T)
      I3=NU(3,T)
      X = (C(1,I1)+C(1,I2)+C(1,I3))/3
      Y = (C(2,I1)+C(2,I2)+C(2,I3))/3
      CALL LIGH3 (-1,-1,5)
      WRITE (CH3,'(I3)') T
      IF(IOP.GE.90) CALL TXT2D(CH3,3,X,Y)
C-------------------------------------------------
C ON TRACE LE CONTOUR DU TRIANGLE AVEC COULEUR 215
C-------------------------------------------------
      CALL LIGH3 (-1,-1,215)
      CALL MOV2TO(FLOAT(C(1,NU(1,T))),FLOAT(C(2,NU(1,T))))
      CALL LIN2TO(FLOAT(C(1,NU(2,T))),FLOAT(C(2,NU(2,T))))
      CALL LIN2TO(FLOAT(C(1,NU(3,T))),FLOAT(C(2,NU(3,T))))
      CALL LIN2TO(FLOAT(C(1,NU(1,T))),FLOAT(C(2,NU(1,T))))
C
C SI IOP >99 ON PEUT SUIVRE PAS A PAS LE COMPORTEMENT DE L ALGORITHME
C APRES CHAQUE MODIF ON ATTEND UN <RETOUR_CHARIOT>
C
      IF(IOP.GE.100) PAUSE
      END
C**********************************************************************
      SUBROUTINE MSHTRI (CR,C,NBS,TRI,NU,IOP,ERR)
      INTEGER NBS,C(1:2,1:NBS),TRI(1:NBS),NU(1:NBS),IOP,ERR
      REAL CR(1:2,1:NBS)
      INTEGER III,IC,XX,IP,I,J,JC,K,TRIK,TRI3,DET,IERR
      REAL AA1,AA2,XMIN,XMAX,YMIN,YMAX,XX1,XX2,YY1,YY2,DXX
      REAL PRECIS
      PARAMETER (PRECIS=2.**15-1.)
C
      ERR = 0
      IERR = 0
      III=1
      XMIN=CR(1,1)
      YMIN=CR(2,1)
      XMAX=CR(1,1)
      YMAX=CR(2,1)
      DO 10 IC=1,NBS
       XMIN=MIN(CR(1,IC),XMIN)
       YMIN=MIN(CR(2,IC),YMIN)
       XMAX=MAX(CR(1,IC),XMAX)
       YMAX=MAX(CR(2,IC),YMAX)
       TRI(IC)=IC
       IF(CR(1,IC).LT.CR(1,III)) THEN
        III=IC
       ENDIF
10    CONTINUE
      AA1 = PRECIS/(XMAX-XMIN)
      AA2 = PRECIS/(YMAX-YMIN)
      AA1 = MIN(AA1,AA2)
      AA2 = AA1*(CR(2,III)-YMIN)
      DO 20 IC=1,NBS
       C(1,IC) = NINT(AA1*(CR(1,IC)-CR(1,III)))
       C(2,IC) = NINT(AA1*(CR(2,IC)-YMIN)-AA2)
       NU(IC)= C(1,IC)**2 + C(2,IC)**2
20    CONTINUE
      IF(IOP.GE.10) THEN
C GRAPHIQUE FENTR2 : TAILLE DU DESSIN EN CM
C LA TAILLE DE L ECRAN EST RENVOYEE PAR LA ROUTINE SZSCRN
C--------------------------------------------------------
       CALL SZSCRN (XX1,XX2,YY1,YY2)
       DXX = MIN(XX2-XX1,YY2-YY1)
C ON PREND UNE ENVELOPPE CARREE POUR EVITER LES DEFORMATIONS
C-----------------------------------------------------------
       CALL FENTR2(XX1,XX1+DXX,YY1,YY1+DXX)
       CALL MASQU2(-.01*PRECIS      ,    1.01*PRECIS
     &            ,-.01*PRECIS-AA2  ,    1.01*PRECIS-AA2 )
      ENDIF
C----------------------------------------------------------
      CALL MSHTR1 (NU,TRI,NBS)
      IP = 1
      XX=NU(IP)
      DO 30 JC=1,NBS
      IF(NU(JC).GT.XX)THEN
      CALL MSHTR1 (NU(IP),TRI(IP),JC-IP)
      DO 25 I=IP,JC-2
      IF(NU(I).EQ.NU(I+1)) THEN
      IERR=IERR+1
      PRINT *,' ERROR LES POINTS ',TRI(I),TRI(I+1),' SONT EGAUX'
      ENDIF
25    CONTINUE
      XX=NU(JC)
      IP=JC
      ENDIF
      IC=TRI(JC)
      NU(JC)=C(2,IC)
30    CONTINUE
      CALL MSHTR1 (NU(IP),TRI(IP),NBS-IP)
      DO 35 I=IP,JC-2
      IF(NU(I).EQ.NU(I+1)) THEN
      IERR=IERR+1
      PRINT *,' ERROR LES POINTS ',TRI(I),TRI(I+1),' SONT EGAUX'
      ENDIF
35    CONTINUE
      IF(IERR.NE.0) THEN
      ERR = 2
      PRINT *,' FATAL ERROR MSHTRI:IL Y A DES POINTS CONFONDUS'
      RETURN
      ENDIF
      K=2
50    CONTINUE
      IF(K.LE.NBS) THEN
      K=K+1
      DET = C(1,TRI(2))*C(2,TRI(K)) - C(2,TRI(2))*C(1,TRI(K))
      IF(DET.EQ.0) GOTO 50
      ELSE
      PRINT *,'FATAL ERROR MSHTRI TOUS LES POINTS SONT ALIGNES'
      PRINT *,'TRI =',(TRI(K),K=1,NBS)
      ERR = 3
      STOP 'FATAL ERROR'
      ENDIF
      TRIK = TRI(K)
      DO 60 J=K-1,3,-1
      TRI(J+1)=TRI(J)
60    CONTINUE
      TRI(3)=TRIK
      IF(DET.LT.0) THEN
      TRI3=TRI(3)
      TRI(3)=TRI(2)
      TRI(2)=TRI3
      ENDIF
      END
C**********************************************************************
      SUBROUTINE MSHTR1 (CRITER,RECORD,N)
      INTEGER RECORD(N)
      INTEGER CRITER(N)
C
      INTEGER I,L,R,J,N
      INTEGER REC
      INTEGER CRIT
C
      IF(N.LE.1) RETURN
      L=N/2+1
      R=N
2     IF(L.LE.1)GOTO 20
      L=L-1
      REC=RECORD(L)
      CRIT=CRITER(L)
      GOTO 3
20    CONTINUE
      REC=RECORD(R)
      CRIT=CRITER(R)
      RECORD(R)=RECORD(1)
      CRITER(R)=CRITER(1)
      R=R-1
      IF(R.EQ.1)GOTO 999
3     J=L
4     I=J
      J=2*J
      IF(J-R)5,6,8
5     IF(CRITER(J).LT.CRITER(J+1))J=J+1
6     IF(CRIT.GE.CRITER(J))GOTO 8
      RECORD(I)=RECORD(J)
      CRITER(I)=CRITER(J)
      GOTO 4
8     RECORD(I)=REC
      CRITER(I)=CRIT
      GOTO 2
999   RECORD(1)=REC
      CRITER(1)=CRIT
      RETURN
      END
C**********************************************************************
      SUBROUTINE MSHCVX(DIRECT,C,NU,PFOLD,NBS,IOP,ERR)
      INTEGER NBS,C(2,NBS),NU(6,NBS+NBS-2),PFOLD,IOP,ERR
      LOGICAL DIRECT
      INTEGER PP,PS,I1,I2,I3,I4,I5,I6
      INTEGER PF,PSF,PPF,S1,S2,S3,T,T4,T5,A4,A5,DET,TT4,TT5
      IF(DIRECT) THEN
      PP=3
      PS=4
      I1=1
      I2=3
      I3=2
      I4=6
      I5=5
      I6=4
      ELSE
      PP=4
      PS=3
      I1=1
      I2=2
      I3=3
      I4=4
      I5=5
      I6=6
      ENDIF
10    CONTINUE
      PPF=PFOLD
      PF =NU(PS,PFOLD)
      PSF=NU(PS,PF)
      S1=NU(1,PPF)
      S2=NU(1,PF)
      S3=NU(1,PSF)
      DET =   ( C(1,S2) - C(1,S1) ) * ( C(2,S3) - C(2,S1) )
     &      - ( C(2,S2) - C(2,S1) ) * ( C(1,S3) - C(1,S1) )
      IF(((.NOT.DIRECT).AND.DET.GT.0).OR.(DIRECT.AND.DET.LT.0)) THEN
      IF(DIRECT) THEN
      TT4 = NU(2,PPF)
      TT5 = NU(2,PF)
      ELSE
      TT4 = NU(2,PF)
      TT5 = NU(2,PSF)
      ENDIF
      T4 = TT4/(2**3)
      T5 = TT5/(2**3)
      A4 = TT4 -8 * T4
      A5 = TT5 -8 * T5
      NU(PS,PPF) = PSF
      NU(PP,PSF) = PPF
      T = PF
      IF(DIRECT) THEN
      NU(2,PPF) = (2**3) * T + I6
      ELSE
      NU(2,PSF) = (2**3) * T + I6
      ENDIF
      NU(I1,T ) = S1
      NU(I2,T ) = S2
      NU(I3,T ) = S3
      NU(I4,T ) = (2**3) * T4 + A4
      NU(I5,T ) = (2**3) * T5 + A5
      IF(DIRECT) THEN
      NU(I6,T ) = -PPF
      ELSE
      NU(I6,T ) = -PSF
      ENDIF
      NU(A4,T4) = (2**3) * T + I4
      NU(A5,T5) = (2**3) * T + I5
C------------------------------------------
C GRAPHIQUE EFFACEMENT ET TRACE DE TRIANGLE
C------------------------------------------
      IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T,IOP)
      CALL MSHOPT (C,NU,T5,A5,NBS,IOP,ERR)
      IF(ERR.NE.0) RETURN
      GOTO 10
      ENDIF
      END
C**********************************************************************
      SUBROUTINE MSHCXI (C,NU,TRI,NBS,TETE,IOP,ERR)
      INTEGER NBS,C(2,NBS),NU(6,2*NBS-2),TRI(NBS),TETE,IOP
      INTEGER MSHLCL,ERR
      INTEGER I,J,S,T,PF,PPF,PSF,NPF,PP,PS,TAF,IAF,FREE,TTAF
      PARAMETER (PP=3,PS=4)
      DO 10 I=1,NBS+NBS-2
      NU(1,I)=I+1
      DO 10 J=2,6
      NU(J,I)=0
10    CONTINUE
      NU(1,NBS+NBS-2)=0
      FREE = 1
      T=FREE
      FREE = NU(1,FREE)
      TETE=FREE
      PF  =FREE
      DO 20 I=1,3
      NU(I  ,T) = TRI(I)
      NU(3+I,T) = -PF
      PPF       = PF
      FREE      = NU(1,PF)
      PF        = FREE
      IF(I.EQ.3) PF=TETE
      NU(1,PPF) = TRI(I)
      NU(2,PPF) = I + 3 + (2**3) * T
      NU(PS,PPF) = PF
      NU(PP,PF ) = PPF
20    CONTINUE
      IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T,IOP)
      DO 30 I=4,NBS
      S=TRI(I)
      PF=MSHLCL(C,NU,TETE,S,NBS)
      T=FREE
      FREE = NU(1,FREE)
      NPF  = FREE
      FREE = NU(1,FREE)
      PPF  = NU(PP,PF)
      PSF  = NU(PS,PF)
      TTAF  = NU(2,PF)
      TAF  = TTAF / (2**3)
      IAF  = TTAF - (2**3) * TAF
      NU(1,T) = S
      NU(2,T) = NU(1,PSF)
      NU(3,T) = NU(1,PF )
      NU(4,T) = -NPF
      NU(5,T) = (2**3) * TAF + IAF
      NU(6,T) = -PF
      NU(IAF,TAF) = (2**3) * T + 5
      NU(PS,NPF) = PSF
      NU(PS,PF ) = NPF
      NU(PP,NPF) = PF
      NU(PP,PSF) = NPF
      NU(1,NPF)  = S
      NU(2,NPF)  = (2**3) * T + 4
      NU(2,PF )  = (2**3) * T + 6
C-------------------------------------------
C GRAPHIQUE: EFFACEMENT ET TRACE DE TRIANGLE
C-------------------------------------------
      IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T,IOP)
      CALL MSHOPT (C,NU,T,5,NBS,IOP,ERR)
      IF(ERR.NE.0) RETURN
      CALL MSHCVX (.TRUE. ,C,NU,NPF,NBS,IOP,ERR)
      IF(ERR.NE.0) RETURN
      CALL MSHCVX (.FALSE.,C,NU,NPF,NBS,IOP,ERR)
      IF(ERR.NE.0) RETURN
30    CONTINUE
      END
C**********************************************************************
      SUBROUTINE MSHOPT (C,NU,T,A,NBS,IOP,ERR)
      INTEGER NBS,C(2,NBS),NU(6,NBS+NBS-2),T,A,IOP,ERR
      INTEGER VIDE
      PARAMETER (VIDE=-2**30)
      INTEGER MXPILE
      PARAMETER (MXPILE=256)
      INTEGER PILE(2,MXPILE)
      INTEGER T1,T2,I,S1,S2,S3,S4,SIN1,COS1,SIN2,COS2,SGN
      INTEGER TT1,TT,I11,I12,I13,I21,I22,I23,A1,A2,AA,MOD3(1:3)
      REAL REEL1,REEL2
      REAL*8 REEL8
      DATA MOD3/2,3,1/
      I=1
      PILE(1,I) = T 
      PILE(2,I) = A
10    CONTINUE
      IF(I.GT.0) THEN
      T1=PILE(1,I)
      A1=PILE(2,I)
      I=I-1
      IF(T1.LE.0) GOTO 10
      TT1 = NU(A1,T1)
      IF(TT1.LE.0) GOTO 10
      T2 = TT1/(2**3)
      A2 = TT1-T2*(2**3)
      I11 =   A1 -3
      I12 =   MOD3(I11) 
      I13 =   MOD3(I12)
      I21 =   A2 -3
      I22 =   MOD3(I21)
      I23 =   MOD3(I22)
      S1 = NU(I13,T1)
      S2 = NU(I11,T1)
      S3 = NU(I12,T1)
      S4 = NU(I23,T2)
        SIN1 =   (C(2,S3)-C(2,S1)) * (C(1,S2)-C(1,S1))
     &         - (C(1,S3)-C(1,S1)) * (C(2,S2)-C(2,S1))
        COS1 =   (C(1,S3)-C(1,S1)) * (C(1,S3)-C(1,S2))
     &         + (C(2,S3)-C(2,S1)) * (C(2,S3)-C(2,S2))
        IF(SIN1.EQ.0.AND.COS1.EQ.0) THEN
          PRINT *,'FATAL ERROR MSHOPT:'
     &           ,'3 POINTS CONFONDUS ',S1,S2,S3
          ERR = 12
          RETURN
        END IF
        SIN2  =   (C(1,S4)-C(1,S1)) * (C(2,S2)-C(2,S1))
     &          - (C(2,S4)-C(2,S1)) * (C(1,S2)-C(1,S1))
        COS2  =   (C(1,S4)-C(1,S2)) * (C(1,S4)-C(1,S1))
     &          + (C(2,S4)-C(2,S2)) * (C(2,S4)-C(2,S1))
        REEL1=FLOAT(COS2)*FLOAT(SIN1)
        REEL2=FLOAT(COS1)*FLOAT(SIN2)
        IF(ABS(REEL1)+ABS(REEL2).GE.2**30) THEN
        REEL8=DBLE(COS2)*DBLE(SIN1)
     &       +DBLE(COS1)*DBLE(SIN2)
        REEL8=MIN(MAX(REEL8,-1.D0),1.D0)
        SGN=REEL8
        ELSE
        SGN = COS2*SIN1 + COS1*SIN2
        ENDIF
        IF(MIN(MAX(SGN,-1),+1)*SIN1.GE.0) GOTO 10
        NU(I12,T1) = S4
        NU(I22,T2) = S1
        TT1 = NU(I22+3,T2)
        NU(A1 ,T1) = TT1
        IF(TT1.GT.0) THEN
         TT=TT1/(2**3)
         AA = TT1-(2**3)*TT
         NU(AA,TT)=  A1 +  (2**3) * T1
        ELSEIF(TT1.NE.VIDE) THEN
         NU(2,-TT1)= A1 +  (2**3) * T1
        ENDIF
        TT1 = NU(I12+3,T1)
        NU(A2 ,T2) = TT1
        IF(TT1.GT.0) THEN
         TT=TT1/(2**3)
         AA=TT1-(2**3)*TT
         NU(AA,TT)= A2 +  (2**3) * T2
        ELSEIF(TT1.NE.VIDE) THEN
         NU(2,-TT1)= A2 +  (2**3) * T2
        ENDIF
        NU(I12+3,T1) =   I22+3 + (2**3)*T2
        NU(I22+3,T2) =   I12+3 + (2**3)*T1
        IF(I+4.GT.MXPILE) THEN
          PRINT *,' FATAL ERROR MSHOPT LA PILE EST TROP PETITE ',MXPILE
          ERR =13
          RETURN
        ENDIF
C GRAPHIQUE : EFFACEMENT ET TRACE DE TRIANGLE
C--------------------------------------------
        IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T1,IOP)
        IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T2,IOP)
C
        I=I+1
        PILE(1,I)=T1
        PILE(2,I)=A1
        I=I+1
        PILE(1,I)=T2
        PILE(2,I)=A2
        I=I+1
        PILE(1,I)=T1
        PILE(2,I)=I13+3
        I=I+1
        PILE(1,I)=T2
        PILE(2,I)=I23+3
        GOTO 10
      ENDIF
      END
C**********************************************************************
      SUBROUTINE MSHFRT (C,NU,NBS,FRT,LFRT,W,IOP,ERR)
      INTEGER NBS,C(2,NBS),NU(6,NBS+NBS-2)
      INTEGER LFRT,FRT(LFRT),ERR,W(4*NBS-4),IOP
      INTEGER I,J,IFRT,SINIT,LNU,IS,IE,TINTER,NBAC,NBAF,NBACPP
      INTEGER S0,S1,S2,TA,IS1,IT,S2T,S3T,DET2,DET3
      INTEGER P3(1:3),IMPRE
      INTEGER VIDE
      PARAMETER (VIDE=-2**30)
      LOGICAL FIN
      DATA P3/2,3,1/
      IMPRE=MOD(IOP,10)
      IF(LFRT.EQ.0) RETURN
      TINTER =0
      IFRT=0
      LNU = NBS+NBS-2
      IF(IOP.GE.70) THEN
C GRAPHIQUE
C----------
         PAUSE
         CALL CLEAN
         CALL LIGH3 (-1,-1,30)
      ENDIF
C       INITE DU TABLEAU W
      DO 10 I=1,NBS
       W(I)=-1
10    CONTINUE
      NBAF = 0
      S1 = 0
      SINIT= 0
      FIN =.TRUE.
      DO 20 I=1,LFRT
      S0 = S1
      S1 = FRT(I)
      IF(S1.LE.0.OR.S1.GT.NBS) THEN
      ERR=5
      PRINT *,' FATAL ERROR MSHFRT '
      PRINT *,' LE TABLEAU DES LA FRONTIERE EST MAUVAIS EN ',I,S1
      RETURN
      ENDIF
      IF(S0.EQ.SINIT) THEN
      IF(FIN) THEN
      SINIT=S1
C GRAPHIQUE
C----------
      IF(IOP.GE.50) CALL MOV2TO(FLOAT(C(1,S1)),FLOAT(C(2,S1)))
      ELSE
      NBAF = NBAF + 1
      IF(W(S0).NE.-1) THEN
      PRINT *,'FATAL ERROR MSHFRT : LA FRONTIERE EST CROISEE '
     &       ,' EN ',S0                    
      ERR=6
      ENDIF
      W(S0)=I
C GRAPHIQUE
C----------
      IF(IOP.GE.50) CALL LIN2TO(FLOAT(C(1,S1)),FLOAT(C(2,S1)))
      ENDIF
      FIN=.NOT.FIN
      ELSE
      NBAF = NBAF + 1
      IF(W(S0).NE.-1) THEN
      PRINT *,'FATAL ERROR MSHFRT : LA FRONTIERE EST CROISEE '
     &       ,' EN ',S0                    
      ERR=6
      ENDIF
      W(S0)=I
C GRAPHIQUE
C----------
      IF(IOP.GE.50) CALL LIN2TO(FLOAT(C(1,S1)),FLOAT(C(2,S1)))
      ENDIF
20    CONTINUE
      IF(SINIT.NE.S1) THEN
      PRINT *,'WARNING MSHFRT:LA FRONTIERE N''EST PAS FERMEE'
     &         ,' ON LA FERME AVEC L''ARETE ',S1,SINIT
      IF(W(S1).NE.-1) THEN
      PRINT *,'FATAL ERROR MSHFRT : LA FRONTIERE EST CROISEE '
     &           ,' EN ',S1
      ERR=6
      ENDIF
      W(S1)=SINIT
C GRAPHIQUE
C----------
      IF(IOP.GE.50) CALL LIN2TO(FLOAT(C(1,SINIT)),FLOAT(C(2,SINIT)))
      NBAF = NBAF + 1
      ENDIF
      NBAC = 0
      IF(IMPRE.GE.9)PRINT '(8(I5,I6,'';''))',(I,W(I),I=1,NBS)
      NBACPP = 1
30    CONTINUE
      IF(ERR.NE.0) RETURN
      IF(NBAC.LT.NBAF) THEN
      IF(NBACPP.EQ.0) THEN
      ERR = 7
      PRINT *,' FATAL ERROR MSHFRT :L''ALGORITHME BOUCLE :'
     &           ,NBAF,NBAC
      PRINT *,' LA FRONTIERE EST CERTAINEMENT MAL ORIENTEE '
      IF(IMPRE.GE.9) THEN
      PRINT *,' DUMP '
      PRINT *,' LNU = ',LNU,' NBS =',NBS
      PRINT *,' W = '
      PRINT '(8(I5,I6,'';''))',(I,W(I),I=1,NBS)
      PRINT *,' I , NU(1:6,I) = '
      PRINT '(10(I5,6(I12)/))',(I,(NU(J,I),J=1,6),I=1,LNU)
      ENDIF
      DO 40 I=1,NBS
      IF(W(I).GT.0) THEN
      PRINT *,' W(',I,')=',W(I),' SUIVANT = ',FRT(W(I))
      IF(IOP.GE.10) THEN
C GRAPHIQUE : MARQUAGE DES SOMMETS
C---------------------------------
      CALL TXT2D('O',1,FLOAT(C(1,I)),FLOAT(C(2,I)))
      CALL TXT2D('X',1,FLOAT(C(1,FRT(W(I))))
     &          ,FLOAT(C(2,FRT(W(I)))))
      ENDIF
      ENDIF
40    CONTINUE
      RETURN
      ENDIF
C     ON S'OCCUPE DES ARETES DU MAILLAGE ET FRONTIERE DE OMEGA
C---------------------------------------------------------------------
      NBACPP = 0
      DO 60 IE=1,LNU
      IF(NU(5,IE).NE.0) THEN
      DO 50 IS=1,3
      S1  =NU(    IS ,IE)
      S2T =NU( P3(IS),IE)
      IF(W(S1).GT.0) THEN
      S2   = FRT(W(S1))
      IF(S2.EQ.S2T) THEN
C GRAPHIQUE
C----------
      IF(IOP.GE.70) CALL MSHDRW(C,NU,6,IE,IOP)
      TINTER = IE
      NBACPP = NBACPP + 1 
      W(S1) = 0
      IF(NU(IS+3,IE).GT.0) THEN
      TA = NU(IS+3,IE) /(2**3)
      I  = NU(IS+3,IE)-(2**3) * TA
      NU(I,TA)=VIDE
      ENDIF
      NU(IS+3,IE)=VIDE
      ELSE
      IT   = IE
      IS1  = IS
      S3T  = NU(P3(P3(IS)),IT)
      DET2 =  (C(1,S2T)-C(1,S1))*(C(2,S2)-C(2,S1))
     &      - (C(2,S2T)-C(2,S1))*(C(1,S2)-C(1,S1))
      DET3 =  (C(1,S3T)-C(1,S1))*(C(2,S2)-C(2,S1))
     &      - (C(2,S3T)-C(2,S1))*(C(1,S2)-C(1,S1))
      IF(DET2.GE.0.AND.DET3.LE.0) THEN
      IF(DET2.EQ.0) THEN
      IF(W(S2T).EQ.-1) THEN
      PRINT *,' FATAL ERROR MSHFRT: LE POINT ',S2T
     &       ,' QUI NE DOIT PAS ETRE FRONTIERE , L''EST'
      ERR = 10
      ENDIF
      GOTO 50
      ENDIF
      IF(DET3.EQ.0) THEN
      IF(W(S3T).EQ.-1) THEN
      PRINT *,' FATAL ERROR MSHFRT: LE POINT ',S3T
     &      ,' QUI NE DOIT PAS ETRE FRONTIERE , L''EST'
      ERR = 10
      ENDIF
      GOTO 50
      ENDIF
      CALL MSHFR1 (C,NU,NBS,IT,IS1,S2,IOP,ERR)
      IF(ERR.NE.0) RETURN
      TINTER=IT
      W(S1) = 0
      NBACPP = NBACPP + 1
      ENDIF
      ENDIF
      ENDIF
50    CONTINUE
      ENDIF
60    CONTINUE
      NBAC = NBAC + NBACPP
      GOTO 30
      ENDIF
      IF(IOP.GE.80) CALL CLEAN
      I=2
      W(1)=TINTER
      W(2)=3
C-------------------------------------------
C GRAPHIQUE: EFFACEMENT ET TRACE DE TRIANGLE
C-------------------------------------------
      IF(IOP.GE.80) CALL MSHDRW(C,NU,6,TINTER,IOP)
      NU(1,TINTER) = -NU(1,TINTER)
70    CONTINUE
      IF(I.GT.0) THEN
      W(I)=W(I)+1
      IF(W(I).LE.6) THEN
      TA=NU(W(I),W(I-1))
      IF(TA.GT.0) THEN
      TA = TA / (2**3)
      IF(NU(1,TA).GT.0) THEN
      W(I+1)=TA
      W(I+2)=3
      I=I+2
C-------------------------------------------
C GRAPHIQUE: EFFACEMENT ET TRACE DE TRIANGLE
C-------------------------------------------
      IF(IOP.GE.80) CALL MSHDRW(C,NU,6,TA,IOP)
      NU(1,TA)=-NU(1,TA)
      ENDIF
      ENDIF
      ELSE
      I=I-2
      ENDIF
      GOTO  70
      ENDIF
      DO 90 IE=1,LNU
      IF(NU(1,IE).LT.0) THEN
      NU(1,IE)=-NU(1,IE)
      ELSE
      DO 80 I=1,6
      NU(I,IE)=0
80    CONTINUE
      ENDIF
90    CONTINUE
      END
C**********************************************************************
      SUBROUTINE MSHFR1 (C,NU,NBS,IT1,IS1,S2,IOP,ERR)
      INTEGER NBS,C(2,NBS),NU(6,NBS+NBS-2),IS1,S2,ERR,IT1,IOP
      INTEGER LSTMX
      PARAMETER (LSTMX=256)
      INTEGER LST(3,LSTMX)
      INTEGER S1,S3,X,Y,DET,NBAC,S2T,S3T,T,TA
      INTEGER L1,L2,L3,LA,P3(1:5)
      LOGICAL DIRECT
      DATA P3 /2,3,1,2,3/
      DIRECT = .TRUE.
      T = IT1
      S1 = NU(IS1,T)
      X = C(1,S2)-C(1,S1)
      Y = C(2,S2)-C(2,S1)
      NBAC = 0
      L1 = IS1
      L2 = P3(L1)
      L3 = P3(L2)
      S2T = NU(L2,T)
      S3T = NU(L3,T)
      LA = L2 + 3
20    CONTINUE
      NBAC = NBAC + 1
      IF(NBAC.GT.LSTMX) THEN
        PRINT *,' FATAL ERROR MSHFR1 : LST TROP PETIT ',NBAC,LSTMX
        ERR =8
        RETURN
      ENDIF
      LST(2,NBAC) = T
      LST(3,NBAC) = LA
C-------------------------------------------
C GRAPHIQUE: EFFACEMENT ET TRACE DE TRIANGLE
C-------------------------------------------
      IF(IOP.GE.70) CALL MSHDRW (C,NU,6,T,IOP)
      TA = NU(LA,T)
      IF(TA.LE.0) THEN
        PRINT *,' FATAL ERROR MSHFR1:LA FRONTIERE EST CROISEE EN ',T
        ERR =9
        RETURN
      ENDIF
      T  = TA/8
      LA = TA-8*T 
      S3 = NU(P3(LA-2),T)
      IF(S3.NE.S2) THEN
        DET = X*(C(2,S3)-C(2,S1))-Y*(C(1,S3)-C(1,S1))
        IF(DET.GT.0) THEN
          LA = 3+P3(LA-3)
        ELSEIF(DET.LT.0) THEN
          LA = 3+P3(LA-2)
        ELSE
          PRINT *,' FATAL ERROR MSHFR1: LE POINT ',S3
     &           ,' QUI NE DOIT PAS ETRE FRONTIERE , L''EST'
          ERR = 10
          RETURN
        ENDIF
        GOTO 20
      ENDIF
C-------------------------------------------
C GRAPHIQUE: EFFACEMENT ET TRACE DE TRIANGLE
C-------------------------------------------
      IF(IOP.GE.70) CALL MSHDRW (C,NU,6,T,IOP)
      CALL MSHFR2 (C,NU,NBS,LST,NBAC,IT1,S1,S2,IOP)
      RETURN
      END
C**********************************************************************
      SUBROUTINE MSHFR2 (C,NU,NBS,LST,NBAC,T,SS1,SS2,IOP)
      INTEGER NBS,NBAC,C(2,NBS),NU(6,NBS+NBS-2),LST(3,NBAC)
      INTEGER T,SS1,SS2,IOP
      INTEGER PTLST,TTLST,PSLST,PPLST,S1,S2,S3,S4,X41,Y41,X,Y
      INTEGER I,T1,A1,TT1,T2,A2,TT,I11,I12,I13,I21,I22,I23,AAS,AA
      INTEGER DET1,DET4,DET2,DET3
      INTEGER MOD3(3)
      INTEGER VIDE
      PARAMETER (VIDE=-2**30)
      DATA MOD3/2,3,1/
      X = C(1,SS1)-C(1,SS2)
      Y = C(2,SS1)-C(2,SS2)
      DO 10 I=1,NBAC-1
      LST(1,I)=I+1
10    CONTINUE
      LST(1,NBAC)=0
      TTLST = 1
20    CONTINUE
      PTLST  = TTLST
      PPLST  = 0
30    CONTINUE
      IF(PTLST.GT.0) THEN
      T1=LST(2,PTLST)
      A1=LST(3,PTLST)
      TT1 = NU(A1,T1)
      T2 = TT1/(2**3)
      A2 = TT1-T2*(2**3)
      I11 =   A1 -3
      I12 =   MOD3(I11) 
      I13 =   MOD3(I12)
      I21 =   A2 -3
      I22 =   MOD3(I21)
      I23 =   MOD3(I22)
      S1 = NU(I13,T1)
      S2 = NU(I11,T1)
      S3 = NU(I12,T1)
      S4 = NU(I23,T2)
      X41 = C(1,S4)-C(1,S1)
      Y41 = C(2,S4)-C(2,S1)
      DET2 = (C(1,S2)-C(1,S1))*Y41-(C(2,S2)-C(2,S1))*X41
      DET3 = (C(1,S3)-C(1,S1))*Y41-(C(2,S3)-C(2,S1))*X41
      IF(DET2.GT.0.AND.DET3.LT.0) THEN
      NU(I12,T1) = S4
      NU(I22,T2) = S1
      PSLST=LST(1,PTLST)
      IF(PSLST.GT.0) THEN
      AAS=LST(3,PSLST)
      IF(AAS.EQ.I22+3) THEN
      LST(2,PSLST) = T1
      LST(3,PSLST) = I11 + 3
      ENDIF
      ENDIF
      TT1 = NU(I22+3,T2)
      NU(A1 ,T1) = TT1
      IF(TT1.GT.0) THEN
      TT=TT1/(2**3)
      AA = TT1-(2**3)*TT
      NU(AA,TT)=  A1 +  (2**3) * T1
      ELSEIF(TT1.NE.VIDE) THEN
      NU(2,-TT1)= A1 +  (2**3) * T1
      ENDIF
      TT1 = NU(I12+3,T1)
      NU(A2 ,T2) = TT1
      IF(TT1.GT.0) THEN
      TT=TT1/(2**3)
      AA=TT1-(2**3)*TT
      NU(AA,TT)= A2 +  (2**3) * T2
      ELSEIF(TT1.NE.VIDE) THEN
      NU(2,-TT1)= A2 +  (2**3) * T2
      ENDIF
      NU(I12+3,T1) =   I22+3 + (2**3)*T2
      NU(I22+3,T2) =   I12+3 + (2**3)*T1
      DET1 = (C(1,S1)-C(1,SS1))*Y-(C(2,S1)-C(2,SS1))*X
      DET4 = (C(1,S4)-C(1,SS1))*Y-(C(2,S4)-C(2,SS1))*X
C-------------------------------------------
C GRAPHIQUE: EFFACEMENT ET TRACE DE TRIANGLE
C-------------------------------------------
      IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T1,IOP)
      IF(IOP.GE.50) CALL MSHDRW (C,NU,6,T2,IOP)
      IF(DET1.LT.0.AND.DET4.GT.0) THEN
      LST(2,PTLST) = T2
      LST(3,PTLST) = I22+3
      ELSEIF(DET1.GT.0.AND.DET4.LT.0) THEN
      LST(2,PTLST) = T1
      LST(3,PTLST) = I12+3
      ELSE
      IF(PPLST.EQ.0) THEN
      TTLST = LST(1,PTLST)
      PTLST = TTLST
      ELSE
      PTLST        = LST(1,PTLST)
      LST(1,PPLST) = PTLST
      ENDIF
      GOTO 30
      ENDIF
      ENDIF
      PPLST = PTLST
      PTLST = LST(1,PTLST)
      GOTO 30
      ENDIF
      IF(TTLST.NE.0) GOTO 20
      NU(I12+3,T1) =  VIDE
      NU(I22+3,T2) =  VIDE
      T = T2      
      DO 40 I=1,NBAC
      CALL MSHOPT (C,NU,LST(2,I),4,NBS,IOP,IERR)
      CALL MSHOPT (C,NU,LST(2,I),5,NBS,IOP,IERR)
      CALL MSHOPT (C,NU,LST(2,I),6,NBS,IOP,IERR)
40    CONTINUE
      END 

      SUBROUTINE CLEAN ()
      END

      SUBROUTINE DEBFAC (N)
      N=0
      END

      SUBROUTINE FENTR2 (A,B,C,D)
      A=0.
      B=0.
      C=0.
      D=0.
      END

      SUBROUTINE FINFAC ()
      END

      SUBROUTINE LIGH3 (I,J,K)
      I=0
      J=0
      K=0
      END

      SUBROUTINE LIN2TO (A,B)
      A=0.
      B=0.
      END

      SUBROUTINE MASQU2 (A,B,C,D)
      A=0.
      B=0.
      C=0.
      D=0.
      END

      SUBROUTINE MOV2TO (A,B)
      A=0.
      B=0.
      END

      SUBROUTINE SZSCRN (A,B,C,D)
      A=0.
      B=0.
      C=0.
      D=0.      
      END

      SUBROUTINE TXT2D (CHAR,I,A,B)
      CHARACTER*3 CHAR
      I=0
      A=0.
      B=0.
      END
