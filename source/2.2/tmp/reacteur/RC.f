      SUBROUTINE RC(xdot,t,x,u)
      IMPLICIT NONE
      DOUBLE PRECISION xdot(2), t, x(2), u(1)

      DOUBLE PRECISION g, Da, B, xin, q, qprime, gamma
      PARAMETER(g=0.0254d0, Da=0.000391d0,
     % B=19.1d0, xin=1.d0, q=1.d0, qprime=1.d0)
	
      gamma = Da*exp(x(2)/(1+g*x(2)))

      xdot(1) = -x(1)*gamma + q*(xin-x(1))
      xdot(2) = B*x(1)*gamma + qprime*(u(1)-x(2))

      RETURN
      END
