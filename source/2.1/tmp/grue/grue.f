      SUBROUTINE GRUE(XDOT,T,X,U)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION T, X(6), U(2),XDOT(6)
      DOUBLE PRECISION D,R,TH,DDOT,RDOT,THDOT
      DOUBLE PRECISION M,J,CR,G,MC,B,CD
      DATA M/500/,J/50/,CR/20/,G/10/,MC/5000/,B/0.4/,CD/500/
C
C
      D=X(1)
      R=X(2)
      TH=X(3)
      PD=X(4)
      PR=X(5)
      PTH=X(6)
C
C
      A11=MC+M
      A12=M*SIN(TH)
      A13=M*R*COS(TH)
      A21=M*SIN(TH)
      A22=(J/B/B+M)
      A31=M*R*COS(TH)
      A33=M*R*R
C
C
      DDOT= (PD-A12*PR/A22-A13*PTH/A33) /
     $      (A11-A12*A21/A22-A13*A31/A33)
      RDOT=(PR-A21*DDOT)/A22
      THDOT=(PTH-A31*DDOT)/A33
C
C
      XDOT(1)=DDOT
      XDOT(2)=RDOT
      XDOT(3)=THDOT
      XDOT(4)= - CD*DDOT+U(1)
      XDOT(5)= M*(THDOT*(R*THDOT+DDOT*COS(TH))+G*COS(TH))
     $       - CR*RDOT/B/B+ U(2)/B
      XDOT(6)= M*(RDOT*DDOT*COS(TH)-SIN(TH)*(R*DDOT*THDOT+G*R))
C
C
      RETURN
      END
