      SUBROUTINE REGBN(U,X,V,PARAM)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION U(2),X(6),V(2),PARAM(4)
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
      U(1)=PARAM(1)*( DDOT+(D-V(1))/PARAM(2) )
      U(2)=-M*G*B + PARAM(3)*( RDOT+(R-V(2))/PARAM(4) )
C
C
      RETURN
      END
