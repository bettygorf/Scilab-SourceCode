      subroutine gcheck(topg)
c     checks if a scilab variable is a metanet graph
c!      
      include '../stack.h'
c     
      integer topg
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1


c     checking variable g (number 1)
c     
      il1 = iadr(lstk(top-rhs+1))
      if (istk(il1) .ne. 15) then
         err = 1
         call error(56)
         return
      endif
      n1=istk(il1+1)
      if(n1.ne.27) then 
         buf='Metanet Graph structure has incorrect # of elements')
         call error(7000)
         return
      endif
      l1=sadr(il1+n1+3)
c     
c     --   subvariable name(g) --
      il1e2=iadr(l1+istk(il1+3)-1)
      if(istk(il1e2).ne.10) then
         buf='Incorrect 1st element in Metanet Graph structure'
         call error(7001)
         return
      endif
      if(istk(il1e2+1)*istk(il1e2+2).ne.1) then
         buf='Incorrect 1st element in Metanet Graph structure'
         call error(7001)
         return
      endif
c     
c     --   subvariable direct(g) --
      il1e2=iadr(l1+istk(il1+3)-1)
      if(istk(il1e2).ne.1) then
         buf='Incorrect 2nd element in Metanet Graph structure'
         call error(7002)
         return
      endif
      if(istk(il1e2+1)*istk(il1e2+2).ne.1) then
         buf='Incorrect 2nd element in Metanet Graph structure'
         call error(7002)
         return
      endif
      l1e2 = sadr(il1e2+4)
c     
c     --   subvariable m(g) --
      il1e3=iadr(l1+istk(il1+4)-1)
      if(istk(il1e3).ne.1) then
         buf='Incorrect 3rd element in Metanet Graph structure'
         call error(7003)
         return
      endif
      if(istk(il1e3+1)*istk(il1e3+2).ne.1) then
         buf='Incorrect 3rd element in Metanet Graph structure'
         call error(7003)
         return
      endif
      mg=stk(sadr(il1e3+4))
c     
c     --   subvariable n(g) --
      il1e4=iadr(l1+istk(il1+5)-1)
      if(istk(il1e4).ne.1) then
         buf='Incorrect 4th element in Metanet Graph structure'
         call error(7004)
         return
      endif
      if(istk(il1e4+1)*istk(il1e4+2).ne.1) then
         buf='Incorrect 4th element in Metanet Graph structure'
         call error(7004)
         return
      endif
      ng=stk(sadr(il1e4+4))
c     
c     --   subvariable ma(g) --
      il1e5=iadr(l1+istk(il1+6)-1)
      if(istk(il1e5).ne.1) then
         buf='Incorrect 5th element in Metanet Graph structure'
         call error(7005)
         return
      endif
      if(istk(il1e5+1)*istk(il1e5+2).ne.1) then
         buf='Incorrect 5th element in Metanet Graph structure'
         call error(7005)
         return
      endif
      mag=stk(sadr(il1e5+4))

c     
c     --   subvariable mm(g) --
      il1e6=iadr(l1+istk(il1+7)-1)
      if(istk(il1e6).ne.1) then
         buf='Incorrect 6th element in Metanet Graph structure'
         call error(7006)
         return
      endif
      if(istk(il1e6+1)*istk(il1e6+2).ne.1) then
         buf='Incorrect 6th element in Metanet Graph structure'
         call error(7006)
         return
      endif
      mmg=stk(sadr(il1e6+4))
c     
c     --   subvariable la1(g) --
      il1e7=iadr(l1+istk(il1+8)-1)
      if(istk(il1e7).ne.1) then
         buf='Incorrect 7th element in Metanet Graph structure'
         call error(7007)
         return
      endif
      m1e7=il1e7+1)*istk(il1e7+2)
      l1e7 = sadr(il1e7+4)
c     
c     --   subvariable lp1(g) --
      il1e8=iadr(l1+istk(il1+9)-1)
      if(istk(il1e8).ne.1) then
         buf='Incorrect 8th element in Metanet Graph structure'
         call error(7008)
         return
      endif
      m1e8=istk(il1e8+1)*istk(il1e8+2)
      l1e8 = sadr(il1e8+4)
c     
c     --   subvariable ls1(g) --
      il1e9=iadr(l1+istk(il1+10)-1)
      if(istk(il1e9).ne.1) then
         buf='Incorrect 9th element in Metanet Graph structure'
         call error(7009)
         return
      endif
      m1e9 = istk(il1e9+1)*istk(il1e9+2)
      l1e9 = sadr(il1e9+4)
c     
c     --   subvariable la2(g) --
      il1e10=iadr(l1+istk(il1+11)-1)
      if(istk(il1e10).ne.1) then
         buf='Incorrect 10th element in Metanet Graph structure'
         call error(7010)
         return
      endif
      m1e10 = istk(il1e10+2)
      l1e10 = sadr(il1e10+4)
c     
c     --   subvariable lp2(g) --
      il1e11=iadr(l1+istk(il1+12)-1)
      if(istk(il1e11).ne.1) then
         buf='Incorrect 11th element in Metanet Graph structure'
         call error(7011)
         return
      endif
      m1e11 = istk(il1e11+2)
      l1e11 = sadr(il1e11+4)
c     
c     --   subvariable ls2(g) --
      il1e12=iadr(l1+istk(il1+13)-1)
      if(istk(il1e12).ne.1) then
         buf='Incorrect 12th element in Metanet Graph structure'
         call error(7012)
         return
      endif
      m1e12 = istk(il1e12+2)
      l1e12 = sadr(il1e12+4)
c     
c     --   subvariable he(g) --
      il1e13=iadr(l1+istk(il1+14)-1)
      if(istk(il1e13).ne.1) then
         buf='Incorrect 13th element in Metanet Graph structure'
         call error(7013)
         return
      endif
      m1e13 = istk(il1e13+2)
      l1e13 = sadr(il1e13+4)
c     
c     --   subvariable ta(g) --
      il1e14=iadr(l1+istk(il1+15)-1)
      if(istk(il1e14).ne.1) then
         buf='Incorrect 14th element in Metanet Graph structure'
         call error(7014)
         return
      endif
      m1e14 = istk(il1e14+2)
      l1e14 = sadr(il1e14+4)
c     
c     --   subvariable ntype(g) --
      il1e15=iadr(l1+istk(il1+16)-1)
      if(istk(il1e15).ne.1) then
         buf='Incorrect 15th element in Metanet Graph structure'
         call error(7015)
         return
      endif
      m1e15 = istk(il1e15+2)
      l1e15 = sadr(il1e15+4)
c     
c     --   subvariable xnode(g) --
      il1e16=iadr(l1+istk(il1+17)-1)
      if(istk(il1e16).ne.1) then
         buf='Incorrect 16th element in Metanet Graph structure'
         call error(7016)
         return
      endif
      m1e16 = istk(il1e16+2)
      l1e16 = sadr(il1e16+4)
c     
c     --   subvariable ynode(g) --
      il1e17=iadr(l1+istk(il1+18)-1)
      if(istk(il1e17).ne.1) then
         buf='Incorrect 17th element in Metanet Graph structure'
         call error(7017)
         return
      endif
      m1e17 = istk(il1e17+2)
      l1e17 = sadr(il1e17+4)
c     
c     --   subvariable ncolor(g) --
      il1e18=iadr(l1+istk(il1+19)-1)
      if(istk(il1e18).ne.1) then
         buf='Incorrect 18th element in Metanet Graph structure'
         call error(7018)
         return
      endif
      m1e18 = istk(il1e18+2)
      l1e18 = sadr(il1e18+4)
c     
c     --   subvariable demand(g) --
      il1e19=iadr(l1+istk(il1+20)-1)
      if(istk(il1e19).ne.1) then
         buf='Incorrect 19th element in Metanet Graph structure'
         call error(7019)
         return
      endif
      m1e19 = istk(il1e19+2)
      l1e19 = sadr(il1e19+4)
c     
c     --   subvariable acolor(g) --
      il1e20=iadr(l1+istk(il1+21)-1)
      if(istk(il1e20).ne.1) then
         buf='Incorrect 20th element in Metanet Graph structure'
         call error(7020)
         return
      endif
      m1e20 = istk(il1e20+2)
      l1e20 = sadr(il1e20+4)
c     
c     --   subvariable length(g) --
      il1e21=iadr(l1+istk(il1+22)-1)
      if(istk(il1e21).ne.1) then
         buf='Incorrect 21th element in Metanet Graph structure'
         call error(7021)
         return
      endif
      m1e21 = istk(il1e21+2)
      l1e21 = sadr(il1e21+4)
c     
c     --   subvariable cost(g) --
      il1e22=iadr(l1+istk(il1+23)-1)
      if(istk(il1e22).ne.1) then
         buf='Incorrect 22th element in Metanet Graph structure'
         call error(7022)
         return
      endif
      m1e22 = istk(il1e22+2)
      l1e22 = sadr(il1e22+4)
c     
c     --   subvariable mincap(g) --
      il1e23=iadr(l1+istk(il1+24)-1)
      if(istk(il1e23).ne.1) then
         buf='Incorrect 23th element in Metanet Graph structure'
         call error(7023)
         return
      endif
      m1e23 = istk(il1e23+2)
      l1e23 = sadr(il1e23+4)
c     
c     --   subvariable maxcap(g) --
      il1e24=iadr(l1+istk(il1+25)-1)
      if(istk(il1e24).ne.1) then
         buf='Incorrect 24th element in Metanet Graph structure'
         call error(7024)
         return
      endif
      m1e24 = istk(il1e24+2)
      l1e24 = sadr(il1e24+4)
c     
c     --   subvariable qweight(g) --
      il1e25=iadr(l1+istk(il1+26)-1)
      if(istk(il1e25).ne.1) then
         buf='Incorrect 25th element in Metanet Graph structure'
         call error(7025)
         return
      endif
      m1e25 = istk(il1e25+2)
      l1e25 = sadr(il1e25+4)
c     
c     --   subvariable qorig(g) --
      il1e26=iadr(l1+istk(il1+27)-1)
      if(istk(il1e26).ne.1) then
         buf='Incorrect 26th element in Metanet Graph structure'
         call error(7026)
         return
      endif
      m1e26 = istk(il1e26+2)
      l1e26 = sadr(il1e26+4)
c     
c     --   subvariable weight(g) --

      il1e27=iadr(l1+istk(il1+28)-1)
      if(istk(il1e27).ne.1) then
         buf='Incorrect 27th element in Metanet Graph structure'
         call error(7027)
         return
      endif
      m1e27 = istk(il1e27+2)
      l1e27 = sadr(il1e27+4)
c     
c     cross variable size checking
c     
      if (m1e8 .ne. m1e11) then
         call error(42)
         return
      endif
      if (m1e7 .ne. m1e9 .or.m1e7 .ne. mg ) then
         call error(42)
         return
      endif
      if (m1e10 .ne. m1e12 .or.m1e10 .ne. mmg ) then
         call error(42)
         return
      endif
      if (mag .ne. m1e13 .or. mag .ne. m1e14 .or.
     &     mag .ne. m1e20 .or. mag .ne. m1e21 .or.
     &     mag .ne. m1e22 .or. mag .ne. m1e23 .or.
     &     mag .ne. m1e24 .or. mag .ne. m1e25 .or.   
     &     mag .ne. m1e26 .or. mag .ne. m1e27) then
         call error(42)
         return
      endif
      if (ng .ne. m1e15 .or. ng .ne. m1e16 .or.
     &     ng .ne. m1e17 .or. ng .ne. m1e18 .or.
     &     ng .ne. m1e19)then
         call error(42)
         return
      endif
