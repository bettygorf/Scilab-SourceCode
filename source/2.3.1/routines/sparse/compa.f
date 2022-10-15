      logical function dless(a,b)
      double precision a,b
      dless=a.lt.b
      end
      logical function dlessoreq(a,b)
      double precision a,b
      dlessoreq=a.le.b
      end
      logical function dgreat(a,b)
      double precision a,b
      dgreat=a.gt.b
      end
      logical function dgreatoreq(a,b)
      double precision a,b
      dgreatoreq=a.ge.b
      end
      logical function dequal(a,b)
      double precision a,b
      dequal=a.eq.b
      end
      logical function dnequal(a,b)
      double precision a,b
      dnequal=a.ne.b
      end

      logical function wequal(ar,ai,br,bi)
      double precision ar,ai,br,bi
      wequal=ar.eq.br.and.ai.eq.bi
      end
      logical function wnequal(ar,ai,br,bi)
      double precision ar,ai,br,bi
      wnequal=ar.ne.br.or.ai.ne.bi
      end
      logical function lequal(a,b)
      integer a,b
      lequal=a.eq.b
      end
      logical function lnequal(a,b)
      integer a,b
      lnequal=a.ne.b
      end
