      SUBROUTINE GETRAN(IR,N,L,RN,Y1,Y2)
      DIMENSION IA(35,2),BUNNY(35)
C     DIMENSION IA2(35,2),IA3(35,2),IA5(35,2),IA1(35,2),IR(2) CLG
      DIMENSION IA5(35,2),IR(2)
      COMMON/NEWBLK/IA,IA5,BUNNY
      RN=0.
      CON=6.28318530717959
      Y1=0.
      Y2=0.
      IF (N.GT.1) GO TO 22
      call seed(bunny,ia5,ia)
      GO TO 25
22    DO 26 M=1,L
        DO 26 I=1,35
          ITE=IA(34,M)
          IF(I.EQ.1) ITEMP=IA(34,M)
          IF(I.EQ.2) ITEMP=IA(35,M)
          IF(I.GT.2) ITEMP=IA5(I-2,M)
          IA5(I,M)=ITEMP+IA(I,M)
          IF(IA5(I,M).EQ.2) IA5(I,M)=0
26        IA(I,M)=IA5(I,M)
25    IF(L.EQ.1) GO TO 60
      DO 28 J=1,35
        J1=36-J
        IF(IA(J1,1).EQ.1) Y1=Y1+BUNNY(J)
28      IF(IA(J1,2).EQ.1) Y2=Y2+BUNNY(J)
      RN=SQRT(-2.*ALOG(Y1))*SIN(CON*Y2)
      GO TO 62
60    DO 61 J=1,35
        J1=36-J
61      IF (IA(J1,1).EQ.1) Y1=Y1+BUNNY(J)
62    RETURN
      END
