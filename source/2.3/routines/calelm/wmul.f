      subroutine wmul(ar,ai,br,bi,cr,ci)
      double precision ar,ai,br,bi,cr,ci,t
c     c = a*b
      t = ar*bi + ai*br
      cr = ar*br - ai*bi
      ci = t
      return
      end
