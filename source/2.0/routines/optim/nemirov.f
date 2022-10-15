C-------------------------------------------------------------------
C     GENERALIZED LINER-FRACTIONAL PROBLEM ON THE CONE OF POSITIVE
C     SEMIDEFINITE MATRICES BY PROJECTIVE
C     METHOD version 1.1 of November 25, 1991
C     Authors: A.S. Nemirovskii & Yu.E. Nesterov
C     to contact, please use e-mail
C     root@cemi.msk.su
C     Subject: Attn. Nesterov & Nemirovskii
C-------------------------------------------------------------------
C     This code implements the Projective polynomial time potential
C     reduction method as applied to the following problem:
C
C     (P)         minimize t subject to
C                   Ax + b    >= 0,
C                   t*(A*x+b) >= Q*x+p,
C                   t         >= tmin
C
C     where x belongs to R^n, A and Q are linear mappings from R^n in-
C     to the space
C                  S[m] = S^m(1) x ... x S^m(k),
C     S^i being the space of symmetric i*i matrices and >= means "po-
C     sitive semidefinite"
C     The description of the prototype of the method can be found in
C     Yu.E.Nesterov, A.S. Nemirovsky
C     Self-concordance and polynomial time interior point methods in
C     convex programming (extended version) - USSR Acad. Sci. Centr.
C     Econ. & Math. Inst., Moscow, 1990
C     (to appear in Lecture Notes in Mathematics under the title
C     Interior point polynomial methods in convex programming: theo-
C     ry and applications)
C*******************************************************************
C     ALL REALS ARE *8, ALL INTEGERS ARE *4 !!!
C*******************************************************************
      subroutine prfr(n,k,m,A,b,Q,p,ipin,rpin,xin,
     1                ipout,rpout,xout,war,iwar)
      end
