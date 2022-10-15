C seed.for
      subroutine seed(bunny,ia5,ia)
      DIMENSION IA(35,2),BUNNY(35)
      DIMENSION IA2(35,2),IA3(35,2),IA5(35,2),IA1(35,2),IR(2)
      L=1
      IR(2)=0
      WRITE(6,1000)
1000  FORMAT(' ','input SEED(1)')
      READ(5,*)IR(1)
      DO 75 I=1,35
75    BUNNY(I)=.5**I
      DO 2 M=1,L
        DO 1 I=2,34,2
1       IA2(I,M)=1
        DO 9 I=1,33,2
9       IA2(I,M)=0
2       IA2(35,M)=1
      N1=35
      DO 21 MI=1,L
18      DO 17 I=1,35
          IGE=IA2(34,MI)
          IF(I.EQ.1)ITEMP=IA2(34,MI)
          IF(I.EQ.2)ITEMP=IA2(35,MI)
          IF(I.GT.2)ITEMP=IA3(I-2,MI)
          IA3(I,MI)=ITEMP+IA2(I,MI)
          IF(IA3(I,MI).EQ.2) IA3(I,MI)=0
          IA1(I,MI)=IA2(I,MI)
17        IA2(I,MI)=IA3(I,MI)
        MAX=35+IR(MI)-1
        N1=N1+35
        IF(N1.GE.MAX) GO TO 3
        GO TO 18
3       N2=N1-MAX
        N3=35-N2
        IZ=0
        N4=N3+1
        IF(N2.EQ.0) GO TO 33
        DO 19 I=N4,35
          IZ=IZ+1
19        IA(IZ,MI)=IA1(I,MI)
33      CONTINUE
        IF(N3.EQ.0) GO TO 21
        DO 49 I=1,N3
          IZ=IZ+1
49        IA(IZ,MI)=IA3(I,MI)
21      N1=35
        END
