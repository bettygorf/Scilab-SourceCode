      PROGRAM MESH
C     
      PARAMETER (LFRONT0=10000,NS=10000)
      PARAMETER (IX0=10,IY0=43,IDEL=40,IWMAX=2900,IHMAX=2900)
      PARAMETER (IW=985,IH=585)
C     
      PARAMETER (NS4=4*(NS-1),NS12=12*(NS-1),NA1=10*NS)
      PARAMETER (MAXNOD=(IWMAX/IDEL+1)*(IHMAX/IDEL+1))
C     
      INTEGER ISEED(2)
      COMMON/NEWBLK/IA(35,2),IA5(35,2),BUNNY(35)
C     
      REAL CR(2,NS)
      INTEGER FRONT(LFRONT0), IC(2,NS), NU(NS12), TRI(NS4)
      INTEGER IOP, NBT, ERR
      INTEGER K(NS), MA(3,NA1)
      INTEGER OTSUP
      INTEGER NSORCV(NS), NSINKV(NS), U(NA1), C(NA1)
      INTEGER IFLAG(MAXNOD), IQUAD(MAXNOD,2)
C     
      ERR=0
      NBT=0
      IOP=0
      LFRONT=0
C     
      CALL GETRAN(ISEED,1,1,NO,RAN,NON)
      IMP=6
      LEC=5
C     
C     INPUT
C     
      WRITE(IMP,1010)
 1010 FORMAT(' INPUT NODES,NSORC,NSINK,MINCST,MAXCST,ITSUP,OTSUP')
      READ(LEC,*)NODES,NSORC,NSINK,MINCST,MAXCST,ITSUP,OTSUP
      WRITE(IMP,1020)
 1020 FORMAT(' INPUT BHICST,BCAP,MINCAP,MAXCAP')
      READ(LEC,*)BHICST,BCAP,MINCAP,MAXCAP
C     
C     INPUT CHECKING
C     
      IF(NODES.LE.3)THEN
         WRITE(IMP,3001)
 3001    FORMAT(' NODE NUMBER MUST BE GREATER THAN 3')
         STOP
      ENDIF
      IF(NSORC.LE.0.OR.NSINK.LE.0) THEN
         WRITE(IMP,3000)
 3000    FORMAT(' BAD SOURCE OR SINK NUMBER')
         STOP
      ENDIF
      NTRANS=NODES-NSORC-NSINK
      IF(NTRANS.LE.0) THEN
         WRITE(IMP,3002)
 3002    FORMAT(' TOO MUCH SOURCES AND SINKS')
         STOP
      ENDIF
      IF(ITSUP.LT.NSORC) THEN
         WRITE(IMP,3005)
 3005    FORMAT(' NOT ENOUGH SUPPLY')
         STOP
      ENDIF
      IF(OTSUP.LT.NSINK) THEN
         WRITE(IMP,3003)
 3003    FORMAT(' NOT ENOUGH DEMAND')
         STOP
      ENDIF
      IF(BHICST.GT.100..OR.BHICST.LT.0.) THEN
         WRITE(IMP,3007)
 3007    FORMAT(' BAD BHICST')
         STOP
      ENDIF
      IF(BCAP.GT.100..OR.BCAP.LT.0.) THEN
         WRITE(IMP,3008)
 3008    FORMAT(' BAD BCAP')
         STOP
      ENDIF
C     
C     COORDINATES CREATION
C     
      IWN=IW/IDEL
      IHN=IH/IDEL
      IF(NODES.GT.MAXNOD) THEN
         WRITE(IMP,3009)
 3009    FORMAT(' TOO MUCH NODES')
         STOP
      ENDIF
      KK=0
C     TRY TO HAVE THE WHOLE MESH VISIBLE
      DO 9,I=1,IWN+1
         DO 9,J=1,IHN+1
            KK=KK+1
            IQUAD(KK,1)=IX0+IDEL*(I-1)
            IQUAD(KK,2)=IY0+IDEL*(J-1)
 9    CONTINUE
      IF (KK.GE.NODES) GOTO 11
      DO 12,I=IWN+2,IWMAX/IDEL+1
         DO 12,J=1,IHN+1
            KK=KK+1
            IQUAD(KK,1)=IX0+IDEL*(I-1)
            IQUAD(KK,2)=IY0+IDEL*(J-1)
 12   CONTINUE
      IF (KK.GE.NODES) GOTO 11
      DO 13,I=1,IWMAX/IDEL+1
         DO 13,J=IHN+2,IWMAX/IDEL+1
            KK=KK+1
            IQUAD(KK,1)=IX0+IDEL*(I-1)
            IQUAD(KK,2)=IY0+IDEL*(J-1)
 13   CONTINUE
 11   OPEN(UNIT=55, FILE='MESH.DAT',STATUS='UNKNOWN')
      WRITE(55,2001)NODES
      WRITE(55,2003)
      DO 8,I=1,KK
         IFLAG(I)=0
 8    CONTINUE
      DO 1,I=1,NODES
 7       CALL GETRAN(ISEED,2,1,NO,RAN,NON)
         JNOD=(KK-1)*RAN+1
         IF (IFLAG(JNOD).EQ.1) GOTO 7
         IFLAG(JNOD)=1
         IX=IQUAD(JNOD,1)
         IY=IQUAD(JNOD,2)
         CR(1,I)=IX
         CR(2,I)=IY
         WRITE(55,2000)I, IX, IY
 1    CONTINUE
      CALL MSHPTS(CR,IC,NU,NODES,TRI,FRONT,LFRONT,NBT,IOP,ERR)
      WRITE(IMP,1000) NBT
      WRITE(55,2002)NBT
      WRITE(55,2004)
      DO 2,I=1,NBT
         WRITE(55,2000)I,NU(3*I-2), NU(3*I-1), NU(3*I)
 2    CONTINUE
C     
C     ARCS
C     
         LMA=3*NA1
         CALL CARETE (NU,NBT,NODES,MA,NA,NAF,K,LMA)
         WRITE(IMP,1002)NA 
C     
C     SOURCES CREATION
C     
         DO 4,I=1,NODES
            IFLAG(I)=0
 4       CONTINUE
         NSORCV(1)=1
         ISORC=1
         DO 10,I=2,NSORC
 40         ISORC=ISORC+1
            IF(ISORC.GT.NODES) THEN
               WRITE(IMP,3006)
 3006          FORMAT(' IMPOSSIBLE TO CREATE SOURCES')
               STOP
            ENDIF
            DO 20,J=1,I-1
               KK=NSORCV(J)
               DO 30,L=1,NA
                  IF(ISORC.EQ.MA(1,L).AND.KK.EQ.MA(2,L)) GOTO 40
                  IF(ISORC.EQ.MA(2,L).AND.KK.EQ.MA(1,L)) GOTO 40
 30            CONTINUE
 20         CONTINUE
            NSORCV(I)=ISORC
            IFLAG(ISORC)=1
 10      CONTINUE
         WRITE(IMP,1003)(NSORCV(I),I=1,NSORC)
         WRITE(55,2009)
         WRITE(55,2000)NSORC
         WRITE(55,2007)
         DO 8000,I=1,NSORC
            WRITE(55,2000) NSORCV(I)
 8000    CONTINUE
C     
C     SINKS CREATION
C     
         NSINKV(1)=NODES
         ISINK=NODES
         DO 50,I=2,NSINK
 80         ISINK=ISINK-1
            IF(ISINK.LE.1) THEN
               WRITE(IMP,3004)
 3004          FORMAT(' IMPOSSIBLE TO CREATE SINKS')
               STOP
            ENDIF
            IF(IFLAG(ISINK).EQ.1) GOTO 80
            DO 60,J=1,I-1
               KK=NSINKV(J)
               DO 70,L=1,NA
                  IF(ISINK.EQ.MA(1,L).AND.KK.EQ.MA(2,L)) GOTO 80
                  IF(ISINK.EQ.MA(2,L).AND.KK.EQ.MA(1,L)) GOTO 80
 70            CONTINUE
 60         CONTINUE
            NSINKV(I)=ISINK
 50      CONTINUE
         WRITE(IMP,1004)(NSINKV(I),I=1,NSINK)
         WRITE(55,2010)
         WRITE(55,2000)NSINK
         WRITE(55,2008)
         DO 8001,I=1,NSINK
            WRITE(55,2000) NSINKV(I)
 8001    CONTINUE
C     
C     COSTS
C     
         NAMC=NA*BHICST/100.
         DO 5,I=1,NA
            IFLAG(I)=0
 5       CONTINUE
         DO 90,I=1,NAMC
 100        CALL GETRAN(ISEED,2,1,NO,RAN,NON)
            J=NA*RAN+1
            IF(IFLAG(J).EQ.1) GOTO 100
            C(J)=MAXCST
            IFLAG(J)=1
 90      CONTINUE
         DO 110,I=1,NA
            IF(IFLAG(I).EQ.1) GOTO 110
            CALL GETRAN(ISEED,2,1,NO,RAN,NON)
            C(I)=MINCST+(MAXCST-MINCST)*RAN-1
 110     CONTINUE
         WRITE(IMP,1005)
C     
C     CAPACITIES
C     
         NOCAP=MAX(ITSUP,OTSUP)
         NANC=NA*(100.-BCAP)/100.
         DO 6,I=1,NA
            IFLAG(I)=0
 6       CONTINUE
         DO 120,I=1,NANC
 130        CALL GETRAN(ISEED,2,1,NO,RAN,NON)
            J=NA*RAN+1
            IF(IFLAG(J).EQ.1) GOTO 130
            U(J)=NOCAP
            IFLAG(J)=1
 120     CONTINUE
         DO 140,I=1,NA
            IF(IFLAG(I).EQ.1) GOTO 140
            CALL GETRAN(ISEED,2,1,NO,RAN,NON)
            U(I)=MINCAP+(MAXCAP-MINCAP)*RAN
 140     CONTINUE
         WRITE(IMP,1006)
C     
C     NODE FOR SOURCES
C     
         NODES1=NODES+1
         IRCAP=ITSUP
         DO 150,I=1,NSORC
            NA=NA+1
            MA(1,NA)=NODES1
            MA(2,NA)=NSORCV(I)
            C(NA)=0
            IF(I.EQ.NSORC) THEN
               U(NA)=IRCAP
               GOTO 170
            ENDIF
            CALL GETRAN(ISEED,2,1,NO,RAN,NON)
            ICAP=IRCAP*RAN+1
            IF(IRCAP-ICAP.LT.NSORC-I) THEN
               U(NA)=IRCAP-NSORC+I
               DO 160,J=I+1,NSORC
                  NA=NA+1
                  MA(1,NA)=NODES1
                  MA(2,NA)=NSORCV(J)
                  U(NA)=1
                  C(NA)=0
 160           CONTINUE
               GOTO 170
            ELSE
               U(NA)=ICAP
               IRCAP=IRCAP-ICAP
               GOTO 150
            ENDIF
 150     CONTINUE
 170     CONTINUE
C     
C     NODE FOR SINKS
C     
         NODES2=NODES+2
         IRCAP=OTSUP
         DO 180,I=1,NSINK
            NA=NA+1
            MA(2,NA)=NODES2
            MA(1,NA)=NSINKV(I)
            C(NA)=0
            IF(I.EQ.NSINK) THEN
               U(NA)=IRCAP
               GOTO 200
            ENDIF
            CALL GETRAN(ISEED,2,1,NO,RAN,NON)
            ICAP=IRCAP*RAN+1
            IF(IRCAP-ICAP.LT.NSINK-I) THEN
               U(NA)=IRCAP-NSINK+I
               DO 190,J=I+1,NSINK
                  NA=NA+1
                  MA(2,NA)=NODES2
                  MA(1,NA)=NSINKV(J)
                  U(NA)=1
                  C(NA)=0
 190           CONTINUE
               GOTO 200
            ELSE
               U(NA)=ICAP
               IRCAP=IRCAP-ICAP
               GOTO 180
            ENDIF
 180     CONTINUE
 200     CONTINUE
         WRITE(IMP,1007)
C     
         WRITE(55,2005)NA
         WRITE(55,2006)
         DO 3,I=1,NA
            WRITE(55,2000)I,MA(1,I),MA(2,I),U(I),C(I)
 3       CONTINUE
         CLOSE(55)
C
         OPEN(12,FILE='FOR012.DAT',STATUS='UNKNOWN',FORM='UNFORMATTED')
         WRITE(12) NODES,NA,NSORC,NSINK
         WRITE(12)(MA(1,I),I=1,NA)
         WRITE(12)(MA(2,I),I=1,NA)
         WRITE(12)(C(I),I=1,NA)
         WRITE(12)(U(I),I=1,NA)
         ENDFILE(12)
         REWIND(12)
C     
 1000    FORMAT(/'  COORDINATES CREATED'//'  TRIANGLES NUMBER = ',I7)
 1002    FORMAT(/'  ARCS COMPUTED'//'  ARCS NUMBER = ',I7)
 1003    FORMAT(/'  SOURCES CREATED :'/10I7)
 1004    FORMAT(/'  SINKS CREATED :'/10I7)
 1005    FORMAT(/'  COSTS COMPUTED')
 1006    FORMAT(/'  CAPACITIES COMPUTED')
 1007    FORMAT(/'  AUGMENTED GRAPH CREATED')
 2000    FORMAT(10I7)
 2001    FORMAT('  NODES'/I7)
 2002    FORMAT('TRIANGS'/I7)
 2003    FORMAT('   NODE      X      Y') 
 2004    FORMAT(' TRIANG   NODE   NODE   NODE')
 2005    FORMAT('  NARCS'/I7)
 2006    FORMAT('    ARC  START    END   CAPA   COST')
 2007    FORMAT('SOURCES')
 2008    FORMAT('  SINKS')
 2009    FORMAT('  NSORC')
 2010    FORMAT('  NSINK')
         END
