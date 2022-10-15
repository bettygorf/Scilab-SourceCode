      subroutine matdes                                                       
c ================================== ( Inria    ) =============
c     Graphique
c =============================================================
      external plot3d,plot3d1,plot2d1,plot2d2,plot2d3,plot2d4
      external fac3d,fac3d1,champ1,champ
C     fun=7
      include '../stack.h'
      goto (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
     $     21,22,23,24,25,26,27,28,29,30,
     $     31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,
     $     48,49,50,51,52,53) fin
      return
 1    call scichamp('champ',champ)
      return
 2    call scicontour('contour')
      return
 3    call sciparam3d('param3d')
      return
 4    call sciplot3d('plot3d',plot3d,fac3d)
      return
 5    call sciplot3d('plot3d1',plot3d1,fac3d1)
      return
 6    call sciplot2d('plot2d')
      return
 7    call sciplot2d1('plot2d1',plot2d1)
      return
 8    call sciplot2d1('plot2d2',plot2d2)
      return
 9    call sciplot2d1('plot2d3',plot2d3)
      return
 10   call sciplot2d1('plot2d4',plot2d4)
      return
 11   call scigrayplot('grayplot')
      return
 12   call  scidriver('xsetdr')
      return
 13   call  scixarc('xfarc','xfarc'//char(0))
      return
 14   call  scixarc('xarc','xarc'//char(0))
      return
 15   call  scixarcs('xarcs','xarcs'//char(0))
      return
 16   call  scixarcs('xrects','xrects'//char(0))
      return
 17   call  sciarrows('xarrows')
      return
 18   call  scixsegs('xsegs')
      return
 19   call  scixaxis('xaxis')
      return
 20   call  scixchange('xchange')
      return
 21   call  scixclea('xclea','xclea'//char(0))
      return
 22   call  scixclea('xrect','xrect'//char(0))
      return
 23   call  scixclea('xfrect','xfrect'//char(0))
      return
 24   call  scixclear('xclear')
      return
 25   call  scixclick('xclick')
      return
 26   call  scixend('xend')
      return
 27   call  scixfpoly('xfpoly')
      return
 28   call  scixfpolys ('xfpolys')
      return
 29   call  scixget('xget')
      return
 30   call  scixinit('xinit')
      return
 31   call  scixlfont('xlfont')
      return
 32   call  scixnumb('xnumb')
      return
 33   call  scixpause('xpause')
      return
 34   call  scixpoly('xpoly')
      return
 35   call  scixpolys ('xpolys')
      return
 36   call  scixselect('xselect')
      return
 37   call  scixset('xset')
      return
 38   call  scixstring('xstring')
      return
 39   call  scixstringl('xstringl')
      return
 40   call  scixtape('xtape')
      return
 41   call  scixsetech('xsetech')
      return
 42   call  scixgetech('xgetech')
      return
 43   call scigeom3d('geom3d')
      return
 44   call scifec('scifec')
      return
 45   call  scixgetmouse('xgetmouse')
      return
 46   call  scixinfo('xinfo')
      return
 47   call  scixtitle('xtitle')
      return
 48   call  scixgrid('xgrid')
      return
 49   call  scixfarcs('xfarcs','xfarcs'//char(0))
      return
 50   call  scixsave('xsave') 
      return
 51   call  scixload('xload')
      return
 52   call scichamp('champ1',champ1)
      return
 53   call scidelw('xdel')
      end
     
      subroutine scichamp(fname,func)
cc    interface de la macro champ
cc    <>=champ(fx,fy,arfact,rect,flag)
cc    <>=champ(fx,fy,[arfact=1.0,rect=[xmin,ymin,xmax,ymax],flag])
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,getscalar,matsize
      integer m1,n1,lr1,m2,n2,lr2,lr3,m4,n4,lr4
      integer topk,lr5,m6,n6,lr6,m7,n7,lr7,nlr7
      double precision rect(4),arfact
      character*(4) strf
      external func
      strf='021'//char(0)
      topk=top
      rect(1)=0.0d00
      rect(2)=0.0d00
      rect(3)=10.0d00
      rect(4)=10.0d00
      if (rhs.le.0) then
         buf=fname // '(1:10,1:10,rand(10,10),rand(10,10),1.0);$'
         call demo(fname,buf,1)
         return
      endif
      buf='0'//char(0)
      arfact=1.0d0
      if (.not.checkrhs(fname,4,7)) return
      if (rhs.eq.7) then
         if(.not.getsmat(fname,topk,top,m7,n7,1,1,lr7,nlr7))return
         if (nlr7.ne.3) then
            buf=fname//' : strf has a wrong size, 3 expected'
            call error(999)
            return
         endif
         call cvstr(nlr7,istk(lr7),strf,1)
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getrmat(fname,topk,top,m6,n6,lr6))return
         if (m6*n6.ne.4) then
            buf= fname//' : rect has a wrong size'
            call error(999)
            return
         endif
         call dcopy(4,stk(lr6),1,rect,1)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getscalar(fname,topk,top,lr5))return
         arfact=stk(lr5)
         top=top-1
      endif
      if (rhs.ge.4) then
         if (.not.getrmat(fname,topk,top,m4,n4,lr4)) return
         top=top-1
         if (.not.getrmat(fname,topk,top,m3,n3,lr3)) return
         if (.not.matsize(fname,topk,top,m4,n4)) return
         top=top-1
         if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
         if (m2*n2.ne.n3) then 
            buf=fname//' second and third arguments'
     $           //' have incompatible length'
            call error(999)
            return
         endif
         top=top-1
         if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
         if (m1*n1.ne.m3) then 
            buf=fname//' first and third arguments'
     $           //' have incompatible length'
            call error(999)
            return
         endif
      endif
      call sciwin()
      call func(stk(lr1),stk(lr2),stk(lr3),stk(lr4),
     $     m3,n3,strf,rect,arfact)
      call objvide(fname,top)
      return
      end
     
      subroutine scicontour(fname)
cc    interface de la macro contour
cc	<>=contour(x,y,z,nz)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getrvect,getscalar,getsmat
      integer m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,nz,m4,n4,lr4,flag
      integer lr5,lr6,lr7,lr,m,n,lr10,nlr7
      integer topk, iflag(3)
      double precision ebox(6),zlev,alpha,theta
      if (rhs.le.0) then
         buf='  contour(1:5,1:10,rand(5,10),5);$'
         call demo(fname,buf,1)
         return
      endif
      if (.not.checkrhs(fname,4,10)) return
      topk=top
      iflag(1)=2
      iflag(2)=2
      iflag(3)=3
      alpha=35.0
      theta=45.0
      buf='X@Y@Z'//char(0)
      if (rhs.ge.10) then
         if(.not.getscalar(fname,topk,top,lr10))return
         zlev=stk(lr10)
         top=top-1
      endif
      if (rhs.ge.9) then
         if(.not.getrvect(fname,topk,top,m,n,lr))return
         if (m*n.ne.6) then
            buf= fname//' : ebox has a wrong size, 6 expected'
            call error(999)
            return
         endif
         call dcopy(6,stk(lr),1,ebox,1)
         top=top-1
      endif
      if (rhs.ge.8) then
         if(.not.getrvect(fname,topk,top,m,n,lr))return
         if (m*n.ne.3) then
            buf= fname//' : flag has a wrong size, 3 expected'
            call error(999)
            return
         endif
         iflag(1)=int(stk(lr))
         iflag(2)=int(stk(lr+1))
         iflag(3)=int(stk(lr+2))
         top=top-1
      endif
      if (rhs.ge.7) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr7,nlr7))return
         if (nlr7.eq.0) then
            buf=fname//' : legend is an empty string'
            call error(999)
            return
         endif
         call cvstr(nlr7,istk(lr7),buf,1)
         buf(nlr7+1:nlr7+1)=char(0)
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getscalar(fname,topk,top,lr6))return
         alpha=stk(lr6)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getscalar(fname,topk,top,lr5))return
         theta=stk(lr5)
         top=top-1
      endif
      if(.not.getrmat(fname,topk,top,m4,n4,lr4))return
      top=top-1
      if(.not.getrmat(fname,topk,top,m3,n3,lr3))return
      top=top-1
      if(.not.getrvect(fname,topk,top,m2,n2,lr2))return
      top=top-1
      if(.not.getrvect(fname,topk,top,m1,n1,lr1))return
      if(m3.eq.1.or.n3.eq.1) then
         buf=fname// ' : third argument is a vector, I expect a matrix'
         call error(999)
         return
      endif
      if (m1*n1.ne.m3) then
         buf=fname//' : first and third arguments '
     $        //'have incompatible sizes'
         call error(999)
         return
      endif
      if (m2*n2.ne.n3) then
         buf=fname//' : second and third arguments '
     $     //'have incompatible sizes'
         call error(999)
         return
      endif
      call sciwin()
      if (m4*n4.eq.1) then
         flag=0
         nz=int(stk(lr4))
      else
         flag=1
         nz=m4*n4
      endif
      call contour(stk(lr1),stk(lr2),stk(lr3),m3,n3,flag,nz,stk(lr4),
     $     theta,alpha, buf,iflag,ebox,zlev)
      call objvide(fname,top)
      return
      end

      subroutine sciparam3d(fname)
cc	<>=param3d(x,y,z,[teta,alpha,leg,flag,ebox])
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,getscalar,matsize,getrvect
      integer m1,n1,lr1,m2,n2,lr2,m3,n3,lr3
      integer topk, iflag(3),m,n,lr,lr6,nlr6,lr5,lr4
      double precision ebox(6),alpha,theta
      iflag(1)=1
      iflag(2)=2
      iflag(3)=4
      alpha=35.0
      theta=45.0
      if (rhs.lt.0) then
         buf='  t=0:0.1:5*%pi;'
     $   //'  param3d(sin(t),cos(t),t/10,35,45,''X@Y@Z'',[2,4]);$'
         call demo(fname,buf,1)
         return
      endif
      buf='X@Y@Z'//char(0)
      if (.not.checkrhs(fname,3,8)) return
      topk=top
      if (rhs.ge.8) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.6) then
            buf= fname//' : ebox has a wrong size, 6 expected'
            call error(999)
            return
         endif
         call dcopy(6,stk(lr),1,ebox,1)
         top=top-1
      endif
      if (rhs.ge.7) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.2) then
            buf= fname//' : flag has a wrong size, 2 expected'
            call error(999)
            return
         endif
         iflag(2)=int(stk(lr))
         iflag(3)=int(stk(lr+1))
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr6,nlr6))return
         if (nlr6.le.0) then
            buf=fname//' : legend is an empty string'
            call error(999)
            return
         endif
         call cvstr(nlr6,istk(lr6),buf,1)
         buf(nlr6+1:nlr6+1)=char(0)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getscalar(fname,topk,top,lr5))return
         alpha=(stk(lr5))
         top=top-1
      endif
      if (rhs.ge.4) then
         if(.not.getscalar(fname,topk,top,lr4))return
         theta=(stk(lr4))
         top=top-1
      endif
      if (rhs.ge.3) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         top=top-1
         if (.not.getrvect(fname,topk,top,m2,n2,lr2)) return
         if (.not.matsize(fname,topk,top,m3,n3)) return
         top=top-1
         if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
         if (.not.matsize(fname,topk,top,m3,n3)) return
      endif
      call sciwin()
      call param3d(stk(lr1),stk(lr2),stk(lr3),m1*n1,theta,alpha,
     $     buf,iflag,ebox)
      call objvide(fname,top)
      return
      end

      subroutine scigeom3d(fname)
cc	<>=geom3d(x,y,z)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,checklhs,matsize
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3
      if (rhs.lt.0) then
         buf='  t=0:0.1:5*%pi,'
     $   //' [x,y]= geom3d(sin(t),cos(t),t/10);$'
         call demo(fname,buf,1)
         return
      endif
      if (.not.checkrhs(fname,3,3)) return
      if (.not.checklhs(fname,2,3)) return
      topk=top
      if (.not.getrmat(fname,topk,top,m3,n3,lr3)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      if (.not.matsize(fname,topk,top,m3,n3)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m3,n3)) return
      call sciwin()
      call geom3d(stk(lr1),stk(lr2),stk(lr3),m1*n1)
      top=top+(lhs-1)
      return
      end


      subroutine sciplot3d(fname,func,func1)
cc    func doit valoir plot3d ou plot3d1
cc    comme param3d sauf pour flag
cc    <>=plot3d(x,y,z,teta,alpha,leg,flag,ebox)
      character*(*) fname
      external func,func1
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,getscalar,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3
      integer iflag(3),m,n,lr,lr6,nlr6,lr5,lr4
      double precision ebox(6),alpha,theta
      iflag(1)=2
      iflag(2)=2
      iflag(3)=4
      alpha=35.0
      theta=45.0
      if (rhs.lt.0) then
         buf='t=-%pi:0.3:%pi;'// fname//
     $       '(t,t,sin(t)''*cos(t),35,45,'//
     $       '''X@Y@Z'',[2,2,4]);$'
         call demo(fname,buf,1)
         return
      endif
      buf='X@Y@Z'//char(0)
      if (.not.checkrhs(fname,3,8)) return
      topk=top
      if (rhs.ge.8) then
         if(.not.getrvect(fname,topk,top,m,n,lr))return
         if (m*n.ne.6) then
            buf= fname//' : ebox has a wrong size, 6 expected'
            call error(999)
            return
         endif
         call dcopy(6,stk(lr),1,ebox,1)
         top=top-1
      endif
      if (rhs.ge.7) then
         if(.not.getrvect(fname,topk,top,m,n,lr))return
         if (m*n.ne.3) then
            buf= fname//' : flag has a wrong size, 3 expected'
            call error(999)
            return
         endif
         iflag(1)=int(stk(lr))
         iflag(2)=int(stk(lr+1))
         iflag(3)=int(stk(lr+2))
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr6,nlr6))return
         if (nlr6.eq.0) then
            buf=fname//' : legend is an empty string'
            call error(999)
            return
         endif
         call cvstr(nlr6,istk(lr6),buf,1)
         buf(nlr6+1:nlr6+1)=char(0)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getscalar(fname,topk,top,lr5))return
         alpha=stk(lr5)
         top=top-1
      endif
      if (rhs.ge.4) then
         if(.not.getscalar(fname,topk,top,lr4))return
         theta=stk(lr4)
         top=top-1
      endif
      if (rhs.ge.3) then
         if (.not.getrmat(fname,topk,top,m3,n3,lr3)) return
         top=top-1
         if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
         top=top-1
         if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
         if (m1*n1.eq.m3*n3.and.m1*n1.eq.m2*n2.and.m1*n1.ne.1) then 
            if (.not.( m1.eq.m2.and.m2.eq.m3.and.n1
     $           .eq.n2.and.n2.eq.n3)) then 
               buf=fname//' The three first arguments'
     $              //' have incompatible length'
               call error(999)
               return
            endif
         else
            if (m2*n2.ne.n3) then
               buf=fname//' second and third arguments'
     $              //' have incompatible length'
               call error(999)
               return
            endif
            if (m1*n1.ne.m3) then
               buf=fname//' first and third arguments'
     $              //' have incompatible length'
               call error(999)
               return
            endif
         endif
      endif
      call sciwin()
      if ( m1*n1.eq.m3*n3.and.m1*n1.eq.m2*n2.and.m1*n1.ne.1) then 
         call func1(stk(lr1),stk(lr2),stk(lr3),m3,n3,theta,alpha,
     $        buf,iflag,ebox)
      else
         call func(stk(lr1),stk(lr2),stk(lr3),m3,n3,theta,alpha,
     $        buf,iflag,ebox)
      endif
      call objvide(fname,top)
      return
      end

cc	<>=plot2d(x,y,style,strf,leg,rect,nax)
cc	<>=plot2d(x,y,[style,strf,leg,rect,nax])
      subroutine sciplot2d(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,matsize,getrvect,cremat
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,iadr
      integer nax(4),m,n,lr,lc,lr5,nlr5,lr4,nlr4,i,il1
      double precision rect(4)
      character*(4) strf
      data nax / 2,10,2,10/
      data rect / 0.0d00,0.0d00,10.0d00,10.0d00/
      iadr(l)=l+l-1
      if (rhs.lt.0) then
         buf='  x=0:0.1:2*%pi,'
     $        //'  plot2d([x;x;x]'',[sin(x);sin(2*x);sin(3*x)]'''
     $        //',[-1,-2,3],''111'',''L1@L2@L3'',[0,-2,2*%pi,2]);$'
         call demo(fname,buf,1)
         return
      endif
      buf='X@Y@Z'//char(0)
      strf='021'//char(0)
      if (.not.checkrhs(fname,2,7)) return
      topk=top
      if (rhs.ge.7) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : nax has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call entier(4,stk(lr),nax)
         do 10 i=1,4
            nax(i)=max(nax(i),1)
 10      continue
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : rect has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call dcopy(4,stk(lr),1,rect,1)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr5,nlr5))return
         if (nlr5.eq.0) then
            buf=fname//' : legend is an empty string'
            call error(999)
            return
         endif
         call cvstr(nlr5,istk(lr5),buf,1)
         buf(nlr5+1:nlr5+1)=char(0)
         top=top-1
      endif
      if (rhs.ge.4) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr4,nlr4))return
         if (nlr4.ne.3) then
            buf=fname//' : strf has a wrong size, 3 expected'
            call error(999)
            return
         endif
         call cvstr(nlr4,istk(lr4),strf,1)
         top=top-1
      endif
      if (rhs.ge.3) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         il1=iadr(lr3)        
         top=top-1
      endif
      if (rhs.ge.2) then
         if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
         top=top-1
         if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
         if (.not.matsize(fname,topk,top,m2,n2)) return
      endif
      if (rhs.eq.2) then
         if (.not.cremat(fname,top+2,0,1,max(n1,2),lr3,lc)) return
         il1=iadr(lr3)
         do 12 i=1,n1
            istk(il1+i-1) = -i
 12      continue
         if (n1.eq.1) istk(il1+1)=1
      else
         if (m3*n3.lt.n1) then
            buf=fname // ' style is too small'
            call error(999)
            return
         endif
         call entier(m3*n3,stk(lr3),istk(il1))
      endif
      call sciwin()
      call plot2d(stk(lr1),stk(lr2),n1,m1,istk(il1),strf,buf,rect,nax)
      call objvide(fname,top)
      return
      end

cc	<>=plot2d1(str,x,y,style,strf,leg,rect,nax)
      subroutine sciplot2d1(fname,func)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,getrvect,cremat
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,iadr
      integer nax(4),m,n,lr,lc,lr5,nlr5,lr4,nlr4,i,il1,nlr
      double precision rect(4)
      character*(4) strf,str
      external func
      data nax / 2,10,2,10/
      data rect / 0.0d00,0.0d00,10.0d00,10.0d00/
      iadr(l)=l+l-1
      if (rhs.lt.0) then
         buf='  x=0:0.1:2*%pi;'// fname
     $        //'(''gnn'',[x;x;x]'',[sin(x);sin(2*x);sin(3*x)]'''
     $        //',[-1,-2,3],''111'',''L1@L2@L3'',[0,-2,2*%pi,2])$;'
         call demo(fname,buf,1)
         return
      endif
      buf='X@Y@Z'//char(0)
      strf='021'//char(0)
      if (.not.checkrhs(fname,3,8)) return
      topk=top
      if (rhs.ge.8) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : nax has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call entier(4,stk(lr),nax)
         do 10 i=1,4
            nax(i)=max(nax(i),1)
 10      continue
         top=top-1
      endif
      if (rhs.ge.7) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : rect has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call dcopy(4,stk(lr),1,rect,1)
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr5,nlr5))return
         if (nlr5.eq.0) then
            buf=fname//' : legend is an empty string'
            call error(999)
            return
         endif
         call cvstr(nlr5,istk(lr5),buf,1)
         buf(nlr5+1:nlr5+1)=char(0)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr4,nlr4))return
         if (nlr4.ne.3) then
            buf=fname//' : strf has a wrong size, 3 expected'
            call error(999)
            return
         endif
         call cvstr(nlr4,istk(lr4),strf,1)
         top=top-1
      endif
      if (rhs.ge.4) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         il1=iadr(lr3)
         top=top-1
      endif
      if (rhs.ge.3) then
         if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
         top=top-1
         if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
         top=top-1
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr))return
         if (nlr.ne.3) then
            buf=fname//' : str has a wrong size, 3 expected'
            call error(999)
            return
         endif
         call cvstr(nlr,istk(lr),str,1)
      endif
      if (rhs.eq.3) then
         if (.not.cremat(fname,top+3,0,1,max(n2,2),lr3,lc)) return
         il1=iadr(lr3)
         do 12 i=1,n2
            istk(il1+i-1) = -i
 12      continue
         if (n2.eq.1) istk(il1+1)=1
      else
         if (m3*n3.lt.n2) then
            buf=fname // ' style is too small'
            call error(999)
            return
         endif
         call entier(m3*n3,stk(lr3),istk(il1))
      endif
C     verification de la taille de x suivant ce que l'on a donne pour
C     premier argument
      if (str(1:1).eq.'o') then
         if (m1.ne.m2.or.n1.ne.1) then
            write(buf,*) fname,': x has a wrong size, (',
     $           m2,',1) expected'
            call error(999)
            return
         endif
      elseif (str(1:1).eq.'g') then
         if (m1.ne.m2.or.n1.ne.n2) then
            write(buf,*)fname,': x has a wrong size, (',m2,',',
     $           n2,') expected'
            call error(999)
            return
         endif
      endif
      call sciwin()
      call func(str,stk(lr1),stk(lr2),n2,m2,istk(il1),
     $     strf,buf,rect,nax)
      call objvide(fname,top)
      return
      end

      subroutine scigrayplot(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,lr4,nax(4)
      integer i,nlr4,m,n,lr
      double precision rect(4)
      character*(4) strf
      data nax / 2,10,2,10/
      data rect / 0.0d00,0.0d00,10.0d00,10.0d00/
      if (rhs.lt.0) then
         buf ='t=-%pi:0.1:%pi;m=sin(t)''*cos(t);'
     $        //'grayplot(t,t,m);$'
         call demo(fname,buf,1)
         return
      endif
      buf='X@Y@Z'//char(0)
      strf='021'//char(0)
      if (.not.checkrhs(fname,3,6)) return
      topk=top
      if (rhs.ge.6) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : nax has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call entier(4,stk(lr),nax)
         do 10 i=1,4
            nax(i)=max(nax(i),1)
 10      continue
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : rect has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call dcopy(4,stk(lr),1,rect,1)
         top=top-1
      endif
      if (rhs.ge.4) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr4,nlr4))return
         if (nlr4.ne.3) then
            buf=fname//' : strf has a wrong size, 3 expected'
            call error(999)
            return
         endif
         call cvstr(nlr4,istk(lr4),strf,1)
         top=top-1
      endif
      if (.not.getrmat(fname,topk,top,m3,n3,lr3)) return
      top=top-1
      if (.not.getrvect(fname,topk,top,m2,n2,lr2)) return
      if (m2*n2.ne.n3) then
         buf=fname//' second and third arguments '//
     $        'have incompatible length'
         call error(999)
         return
      endif
      top=top-1
      if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
      if (m1*n1.ne.m3) then
         buf=fname//' first and third arguments '//
     $        'have incompatible length'
         call error(999)
         return
      endif
      call sciwin()
      call xgray(stk(lr1),stk(lr2),stk(lr3),m3,n3,strf,rect,nax)
      call objvide(fname,top)
      return
      end

      subroutine demo(fname,chaine,flag)
      character*(*) chaine,fname
c      implicit undefined (a-z)
      include '../stack.h'
      integer lr,flag,nchar,i,nlr,m1,n1
      logical cresmat
C     fait executer la chaine chaine par scilab
C     en appellant execstr 517
C     Attention : placement de top faire attention
C     au cas particulier ou rhs.lt.0.
      if (top.eq.0.or.rhs.lt.0)  top=top+1
c      if (top.eq.1) lstk(top)=1
      nchar=0
      do 10 i=1,bsiz
         if (buf(i:i).eq.'$') goto 20
         nchar=nchar+1
 10   continue
      call basout(i,wte,'internal Bug missing a $ in a '//
     $   'string transmited to demo')
      return
 20   if (.not.cresmat(fname,top,1,1,nchar)) return
      call getsimat(fname,top,top,m1,n1,1,1,lr,nlr)
      call cvstr(nchar,istk(lr),chaine,0)
      rhs=1
      fun=5
      fin=17
      buf(nchar+1:nchar+9+len(fname))= " Demo of "//fname 
      if (flag.eq.1) call basout(io,wte,buf(nchar+1:nchar+9+len(fname)))
      call basout(io,wte,buf(1:nchar))
      return
      end

      subroutine scidriver(fname)
C     OK
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getsmat,cresmat
      integer topk,m,n,lr,nlr,v,drl,m1,n1
      double precision dv 
      drl=3
cc    <>=driver(dr_name)
      if (.not.checkrhs(fname,-1,1)) return
      if ( rhs.le.0) then 
         call  dr1('xgetdr'//char(0),buf,v,v,v,v,v,v,dv,dv,dv,dv)
         top = top+1
         if (.not.cresmat(fname,top,1,1,drl)) return
         call getsimat(fname,top,top,m1,n1,1,1,lr,nlr)
         call cvstr(drl,istk(lr),buf,0)
      else
         topk=top
         if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
         call  cvstr(nlr,istk(lr),buf,1)
         buf(nlr+1:nlr+1)=char(0)
         call  dr1('xsetdr'//char(0),buf,v,v,v,v,v,v,dv,dv,dv,dv)
         call  objvide(fname,top)
      endif
      return
      end

     
      subroutine scixarc(fname,ffname)
      character*(*) fname,ffname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar
      integer topk, lr,lrx,lry,lrw,lrh,a1,a2,v
cc    xarc ou xfarc
      call sciwin()
      if (.not.checkrhs(fname,6,6)) return
      topk=top
      if (.not.getscalar(fname,topk,top,lr)) return
      a2=int(stk(lr))
      top=top-1
      if (.not.getscalar(fname,topk,top,lr)) return
      a1=int(stk(lr))
      top=top-1
      if (.not.getscalar(fname,topk,top,lrh)) return
      top=top-1
      if (.not.getscalar(fname,topk,top,lrw)) return
      top=top-1
      if (.not.getscalar(fname,topk,top,lry)) return
      top=top-1
      if (.not.getscalar(fname,topk,top,lrx)) return
      call  dr1(ffname,'v'//char(0),v,v,v,v,a1,a2,
     $     stk(lrx),stk(lry),stk(lrw),stk(lrh))
      call  objvide(fname,top)
      return
      end
     
      subroutine scixarcs(fname,ffname)
      character*(*) fname,ffname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getrvect,cremat
      integer topk, m,n,lr1,lr,lc,il1,i,verb,iwp,na,v,iadr
      double precision dv
      iadr(l)=l+l-1
      verb=0
      call sciwin()
C     xarcs ou xrects
      if (.not.checkrhs(fname,1,2)) return
      topk=top
      if (rhs.eq.2) then
         if (.not.getrvect(fname,topk,top,m,n,lr)) return
         top=top-1
         il1=iadr(lr)
         call  entier(m*n,stk(lr),istk(il1))
      endif
      if (.not.getrmat(fname,topk,top,m,n,lr1)) return
      if (fname.eq.'xarcs') then
         if (m.ne.6) then 
            buf= fname //' arcs has a wrong size (6,n) expected'
            call  error(999)
            return
         endif
      else
         if (m.ne.4) then 
            buf= fname //' rects has a wrong size (4,n) expected'
            call  error(999)
            return
         endif
      endif
      if (rhs.ne.2) then
         if (.not.cremat(fname,top+1,0,1,n,lr,lc)) return
         il1=iadr(lr)
         call  dr1('xget'//char(0),'white'//char(0),verb,iwp,na,
     $        v,v,v, dv,dv,dv,dv)
         do 10 i=0,n-1
            istk(il1+i)=iwp+1
 10      continue
      endif
      call  dr1(ffname,'v'//char(0),v,istk(il1),n,v,v,v,
     $     stk(lr1),dv,dv,dv)
      call  objvide(fname,top)
      return
      end

      subroutine scixfarcs(fname,ffname)
      character*(*) fname,ffname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getrvect,cremat
      integer topk, m,n,lr1,lr,lc,il1,i,verb,iwp,na,v,iadr
      double precision dv
      iadr(l)=l+l-1
      verb=0
      call sciwin()
C     xarcs ou xrects
      if (.not.checkrhs(fname,1,2)) return
      topk=top
      if (rhs.eq.2) then
         if (.not.getrvect(fname,topk,top,m,n,lr)) return
         top=top-1
         il1=iadr(lr)
         call  entier(m*n,stk(lr),istk(il1))
      endif
      if (.not.getrmat(fname,topk,top,m,n,lr1)) return
      if (m.ne.6) then 
         buf= fname //' arcs has a wrong size (6,n) expected'
         call  error(999)
         return
      endif
      if (rhs.ne.2) then
         if (.not.cremat(fname,top+1,0,1,n,lr,lc)) return
         il1=iadr(lr)
         call  dr1('xget'//char(0),'white'//char(0),verb,iwp,na,
     $        v,v,v, dv,dv,dv,dv)
         do 10 i=0,n-1
            istk(il1+i)=i
 10      continue
      endif
      call  dr1(ffname,'v'//char(0),v,istk(il1),n,v,v,v,
     $     stk(lr1),dv,dv,dv)
      call  objvide(fname,top)
      return
      end

      subroutine sciarrows(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,getrmat,matsize,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,lr,v,mn2
      integer m3,n3,lr3,iadr,dstyle
      double precision arsize,dv
      data dstyle / -1/
      iadr(l)=l+l-1
      call sciwin()
      if (.not.checkrhs(fname,2,4)) return
      topk=top
      if (rhs.eq.4) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         il3=iadr(lr3)
         call entier(m3*n3,stk(lr3),istk(il3))
         if ( m3*n3.eq.1) dstyle=istk(il3)
         top=top-1
      else 
         m3=1
         n3=1
      endif
      if (rhs.ge.3) then
         if (.not.getscalar(fname,topk,top,lr)) return
         arsize=stk(lr)
         top=top-1
      else
         arsize=-1.0
      endif
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      if (m3*n3.ne.1.and.m2*n2/2.ne.m3*n3) then 
         buf=fname// ' : style wrong size '
         call error (999)
         return
      endif
      mn2=m2*n2
      if (rhs.eq.4.and.m3*n3.ne.1) then
         call  dr1('xarrow'//char(0),'v'//char(0),
     $        istk(il3),1,mn2,v,v,v,stk(lr1),stk(lr2),arsize,dv)
      else
         call  dr1('xarrow'//char(0),'v'//char(0),
     $        dstyle,0,mn2,v,v,v,stk(lr1),stk(lr2),arsize,dv)
      endif
      call  objvide(fname,top)
      return
      end
     
      subroutine scixsegs(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,matsize,getrmat,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,v,mn2,m3,n3,lr3,iadr
      integer dstyle
      double precision dv
      data dstyle / -1/
      iadr(l)=l+l-1
      call sciwin()
      if (.not.checkrhs(fname,2,3)) return
      topk=top
      if (rhs.eq.3) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         il3=iadr(lr3)
         call entier(m3*n3,stk(lr3),istk(il3))
         if ( m3*n3.eq.1) dstyle=istk(il3)
         top=top-1
      else 
         m3=1
         n3=1
      endif
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      if (m3*n3.ne.1.and.m2*n2/2.ne.m3*n3) then 
         buf=fname// ' : style wrong size '
         call error (999)
         return
      endif
      mn2=m2*n2
      if (mn2.eq.0) then 
         call basout(io,wte,'xsegs Warning : call with empty arrays')
         return
      endif
      if (rhs.eq.3.and.m3*n3.ne.1) then 
         call  dr1('xsegs'//char(0),'v'//char(0),istk(il3),1,
     $        mn2,v,v,v,stk(lr1),stk(lr2),dv,dv)
      else
         call  dr1('xsegs'//char(0),'v'//char(0),dstyle,0,
     $        mn2,v,v,v,stk(lr1),stk(lr2),dv,dv)
      endif
      call  objvide(fname,top)
      return
      end
     
      subroutine scixaxis(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrvect,getscalar
      integer topk, lr1,m2,n2,lr2,m3,n3,lr3,m4,n4,lr4,v,iadr
      double precision dv
      iadr(l)=l+l-1
      call sciwin()
      if (.not.checkrhs(fname,4,4)) return
      topk=top
      if (.not.getrvect(fname,topk,top,m4,n4,lr4)) return
      if (m4*n4.ne.2) then
         buf=fname// ' : init wrong size, 2 expected '
         call error (999)
         return
      endif
c     il4=iadr(lr4)
c     call entier(2,stk(lr4),istk(il4))
      top=top-1
      if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
      if (m4*n4.ne.2) then
         buf=fname// ' : taille wrong size, 3 expected '
         call error (999)
         return
      endif
      top=top-1
      if (.not.getrvect(fname,topk,top,m2,n2,lr2)) return
      if (m2*n2.ne.2) then
         buf=fname// ' : init wrong size, 2 expected '
         call error (999)
         return
      endif
      il2=iadr(lr2)
      call entier(2,stk(lr2),istk(il2))
      top=top-1
      if (.not.getscalar(fname,topk,top,lr1)) return
      call  dr1('xaxis'//char(0),'v'//char(0),v,
     $     istk(il2),v,v,v,v,stk(lr1),stk(lr3),stk(lr4),dv)

      call  objvide(fname,top)
      return
      end
     
      subroutine scixchange(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,cremat,getsmat,matsize,checklhs
      integer topk, m,n,lr,nlr,m1,n1,lr1,m2,n2,lr2,i,lc
      integer irect(4),iadr 
      iadr(l)=l+l-1
      call sciwin()
      if (.not.checkrhs(fname,3,3)) return
      if (.not.checklhs(fname,1,3)) return
      topk=top
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,3)
      buf(nlr+1:nlr+1)=char(0)
      if (.not.getrmat(fname,topk,top-1,m2,n2,lr2)) return
      if (.not.getrmat(fname,topk,top-2,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top-2,m2,n2)) return
      call sciwin()
      if (buf(1:3).eq.'i2f') then
         call entier(m1*n1,stk(lr1),istk(iadr(lr1)))
         call entier(m1*n1,stk(lr2),istk(iadr(lr2)))
      endif
      if (.not.cremat(fname,top,0,1,4,lr,lc)) return
      call echelle2d(stk(lr1),stk(lr2),istk(iadr(lr1)),
     $     istk(iadr(lr2)),m1,n1,irect,buf)
      do 10 i=1,4
         stk(lr+i-1)=dble(irect(i))
 10   continue
      if (buf(1:3).eq.'f2i') then
         call entier2d(m1*n1,stk(lr1),istk(iadr(lr1)))
         call entier2d(m2*n2,stk(lr2),istk(iadr(lr2)))
      endif
      top=top + max(-2,-3+lhs)
      return
      end
     
      subroutine entier2d(n,d,s)
c     convertion d'entier vers double
C     d et s peuvent en fait pointer sur le meme tableau
C     car la recopie est fait de n,1,-1
c      implicit undefined (a-z)
      double precision d(*)
      integer s(*),n
      integer i
      do 10 i=n,1,-1
         d(i)=dble(s(i))
 10   continue
      return
      end
     
      subroutine simple2d(n,d,s)
c     convertion de float vers double
C     d et s peuvent en fait pointer sur le meme tableau
C     car la recopie est fait de n,1,-1
c      implicit undefined (a-z)
      double precision d(*)
      real  s(*)
      integer i,n
      do 10 i=n,1,-1
         d(i)=dble(s(i))
 10   continue
      return
      end


      subroutine scixclea(fname,ffname)
      character*(*) fname,ffname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar
      integer topk, v,lrx,lry,lrw,lrh
cc    <>=driver(dr_name)
CC    ccc marche pour xclea xrect xfrect
      call sciwin()
      if (.not.checkrhs(fname,4,4)) return
      topk=top
      if (.not.getscalar(fname,topk,top,lrh)) return
      top=top-1
      if (.not.getscalar(fname,topk,top,lrw)) return
      top=top-1
      if (.not.getscalar(fname,topk,top,lry)) return
      top=top-1
      if (.not.getscalar(fname,topk,top,lrx)) return
      call  dr1(ffname,'v'//char(0),v,v,v,v
     $  ,v,v,stk(lrx),stk(lry),stk(lrw),stk(lrh))

      call  objvide(fname,top)
      return
      end
     
      subroutine scixclear(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrvect
      integer topk, lr,i,m,n,win,verb,cur,na,v,wid
      double precision dv
      verb=0
      call sciwin()
      if (.not.checkrhs(fname,-1,1)) return
      topk=top
      if (rhs.eq.1) then
         if (.not.getrvect(fname,topk,top,m,n,lr)) return
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         do 10 i=1,m*n
            wid=int(stk(lr+i-1))
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
            call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $           dv,dv,dv,dv)
 10      continue
         call dr1('xset'//char(0),'window'//char(0),cur,v,v,v,v,v,
     $        dv,dv,dv,dv)
      else
         call dr1('xget'//char(0),'window'//char(0),verb,win,na,v,v,v,
     $        dv,dv,dv,dv)
         call dr1('xset'//char(0),'window'//char(0),win,v,v,v,v,v,
     $        dv,dv,dv,dv)
         call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $        dv,dv,dv,dv)
      endif
      call  objvide(fname,top)
      return
      end
     
      subroutine scixclick(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical cremat,checklhs
      integer topk, lr,lc,v
      double precision  x,y,dv
      integer i
      if (.not.checklhs(fname,1,4)) return
      call sciwin()
      if(lhs.eq.4) then
         call dr1('xclickany'//char(0),'xv'//char(0),
     $        i,iw,v,v,v,v,x,y,dv,dv)
      else
         call dr1('xclick'//char(0),'xv'//char(0),
     $        i,v,v,v,v,v,x,y,dv,dv)
      endif
      if (top.eq.0.or.rhs.lt.0)  top=top+1
c      if (top.eq.1) lstk(top)=1
      topk=top
      if (lhs.eq.1) then
         if (.not.cremat(fname,top,0,1,3,lr,lc)) return
         stk(lr)=dble(i)
         stk(lr+1)=x
         stk(lr+2)=y
      else if (lhs.eq.3) then
         if (.not.cremat(fname,top,0,1,1,lr,lc)) return
         stk(lr)=dble(i)
         if (.not.cremat(fname,top+1,0,1,1,lr,lc)) return
         stk(lr)=x
         if (.not.cremat(fname,top+2,0,1,1,lr,lc)) return
         stk(lr)=y
         top=top+2
      else if (lhs.eq.4) then
         if (.not.cremat(fname,top,0,1,1,lr,lc)) return
         stk(lr)=dble(i)
         if (.not.cremat(fname,top+1,0,1,1,lr,lc)) return
         stk(lr)=x
         if (.not.cremat(fname,top+2,0,1,1,lr,lc)) return
         stk(lr)=y
         if (.not.cremat(fname,top+3,0,1,1,lr,lc)) return
         stk(lr)=dble(iw)
         top=top+3
      else
         buf = fname // ' wrong lhs '
         call error(999)
      endif
      return
      end

      subroutine scixend(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs
      double precision dv
      integer v
      call sciwin()
      if (.not.checkrhs(fname,-1,-1)) return
      call dr1('xend'//char(0),'v'//char(0),
     $     v,v,v,v,v,v,dv,dv,dv,dv)
      call  objvide(fname,top)
      return
      end
     
      subroutine scixgrid(fname)
C     OK
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar
      integer topk,lr5,style
      data style /1 /
      call sciwin()
      if (.not.checkrhs(fname,-1,1)) return
      if ( rhs.eq.1) then 
         if(.not.getscalar(fname,topk,top,lr5))return
         style=int(stk(lr5))
c         top=top-1
      endif
      call xgrid(style)
      call  objvide(fname,top)
      return
      end

     
      subroutine scixfpoly(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrvect,getscalar,matsize
      integer topk, close,m1,n1,lr1,m2,n2,lr2,lr,v,mn1
      double precision dv
      call sciwin()
      if (.not.checkrhs(fname,2,3)) return
      topk=top
      if (rhs.eq.3) then
         if (.not.getscalar(fname,topk,top,lr)) return
         close=int(stk(lr))
         top=top-1
      else
         close=0
      endif
      if (.not.getrvect(fname,topk,top,m2,n2,lr2)) return
      top=top-1
      if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      mn1=m1*n1
      call  dr1('xarea'//char(0),'xvoi0',mn1,v,v,
     $     close,v,v,stk(lr1),stk(lr2),dv,dv)
      call  objvide(fname,top)
      return
      end
     
     
      subroutine scixfpolys (fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrvect,matsize,getrmat,cremat
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,lc3,i
      integer iwp,il3,na,verb,v,iadr
      double precision dv
      iadr(l)=l+l-1
      verb=0
      call sciwin()
      if (.not.checkrhs(fname,2,3)) return
      topk=top
      if (rhs.eq.3) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         il3=iadr(lr3)
         call entier(m3*n3,stk(lr3),istk(il3))
         top=top-1
      endif
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      if (rhs.ne.3) then
         if (.not.cremat(fname,top+2,0,1,n2,lr3,lc3)) return
         call  dr1('xget'//char(0),'white'//char(0),verb,iwp,na
     $        ,v,v,v,dv,dv,dv,dv)
         il3=iadr(lr3)
         do 10 i=1,n2
            istk(il3+i-1)= iwp+1
 10      continue
      else
         if (m3*n3.lt.n2) then
            buf=fname // ' fill vector is too small'
            call error(999)
            return
         endif
      endif
      call  dr1('xliness'//char(0),'v'//char(0),v,v,
     $     istk(il3),n2,m2,v,stk(lr1),stk(lr2),dv,dv)
      call  objvide(fname,top)
      return
      end        
     
      subroutine scixget(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      double precision dv
      logical checkrhs,getscalar,getsmat,cremat,checklhs
      integer topk, lr,nlr,lc,v
cc    <x1>=xget(str,flag)
      integer flag,x1(10),x2,m,n,i
      flag=0
      call sciwin()
      if (rhs.le.0) then
         buf= 'xsetm();$'
         call demo(fname,buf,0)
         return
      endif
      if (.not.checkrhs(fname,1,2)) return
      if (.not.checklhs(fname,1,1)) return
      topk=top
      if (rhs.eq.2) then
         if (.not.getscalar(fname,topk,top,lr)) return
         flag=int(stk(lr))
         top=top-1
      endif
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
      call dr1('xget'//char(0),buf,flag,x1,x2,v,v,v,dv,dv,dv,dv)
      if (.not.cremat(fname,top,0,1,x2,lr,lc)) return
      do 10 i=1,x2
         stk(lr+i-1)=dble(x1(i))
 10   continue
      return
      end
     
      subroutine scixinit(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getsmat
      double precision dv
      integer topk, lr,nlr,m,n,v,v1
      if (.not.checkrhs(fname,-1,2)) return
      v1=-1
      topk=top
      if (rhs.le.0) then
         call dr1('xinit'//char(0),' '//char(0),v1,v,v,v,v,v,
     $        dv,dv,dv,dv)
      else
         if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
         call  cvstr(nlr,istk(lr),buf,1)
         buf(nlr+1:nlr+1)=char(0)
         call dr1('xinit'//char(0),buf,v1,v,v,v,v,v,dv,dv,dv,dv)
      endif
      call objvide(fname,top)
      return
      end

      subroutine scixlfont(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      double precision dv
      logical checkrhs,getsmat,getscalar
      integer topk, lr,nlr,m,n,num,v
      call sciwin()
      if (.not.checkrhs(fname,2,2)) return
      topk=top
      if (.not.getscalar(fname,topk,top,lr)) return
      num=int(stk(lr))
      top=top-1
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
      call dr1('xlfont'//char(0),buf,num,v,v,v,v,v,dv,dv,dv,dv)
      call objvide(fname,top)
      return
      end
     
      subroutine scixnumb(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,matsize,getrmat,cremat,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,m,n,lr,lc,mn3
      integer flag,ttop,v
      flag=0
      call sciwin()
      ttop=top
      if (.not.checkrhs(fname,3,5)) return
      topk=top
      if (rhs.ge.5) then
         if (.not.getrmat(fname,topk,top,m,n,lr)) return
         top=top-1
      endif
      if (rhs.ge.4) then
         if (.not.getscalar(fname,topk,top,lr)) return
         flag=int(stk(lr))
         top=top-1
      endif
      if (.not.getrmat(fname,topk,top,m3,n3,lr3)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      if (.not.matsize(fname,topk,top,m3,n3)) return
      top=top-1
      if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      if (rhs.lt.5) then
         if (.not.cremat(fname,ttop+1,0,m3,n3,lr,lc)) return
         call dset(m3*n3,0.0d+0,stk(lr),1)           
      else
         if (.not.matsize(fname,topk,ttop,m3,n3)) return
      endif
      mn3=m3*n3
      call dr1('xnum'//char(0),'xv'//char(0),v,v,v,v,
     $     mn3,flag,stk(lr1),stk(lr2),stk(lr3),stk(lr))
      call objvide(fname,top)
      return
      end
     
      subroutine scixpause(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      double precision dv
      logical checkrhs,getscalar
      integer topk,sec,lr,v
      call sciwin()
      if (.not.checkrhs(fname,-1,1)) return
      topk=top
      if (rhs.eq.1) then
         if (.not.getscalar(fname,topk,top,lr)) return
         sec=int(stk(lr))
      else
         sec=0
      endif
      call  dr1('xpause'//char(0),'v'//char(0),sec,
     $     v,v,v,v,v,dv,dv,dv,dv)
      call  objvide(fname,top)
      return
      end

      subroutine scixpoly(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,matsize,getscalar,getsmat
      integer topk, m1,n1,lr1,m2,n2,lr2,close,m,n,nlr,lr,v,mn2
      double precision dv
cc    <>=xpoly(xv,yv,dtype,close)
      call sciwin()
      if (.not.checkrhs(fname,2,4)) return
      topk=top
      close=0
      if (rhs.ge.4) then
         if (.not.getscalar(fname,topk,top,lr)) return
         close=int(stk(lr))
         top=top-1
      endif
      if (rhs.ge.3) then
         if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
         call  cvstr(nlr,istk(lr),buf,1)
         buf(nlr+1:nlr+1)=char(0)
         top=top-1
      endif
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      if (buf(1:nlr).eq.'lines') then
         buf='xlines'//char(0)
      else if (buf(1:nlr).eq.'marks') then
         buf='xmarks'//char(0)
      else
         buf=fname // ' : dtype must be lines or marks '
         call error(999)
         return
      endif
      mn2=m2*n2
      call dr1(buf,'xv'//char(0),mn2,v,v,close,
     $     v,v,stk(lr1),stk(lr2),dv,dv)
      call objvide(fname,top)
      return
      end
     
      subroutine scixpolys (fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      double precision dv
      logical checkrhs,getrmat,matsize,cremat,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,lc3,il3
      integer i,iwp,verb,na,v,iadr
      iadr(l)=l+l-1
      verb=0
      call sciwin()
      if (.not.checkrhs(fname,2,3)) return
      topk=top
      if (rhs.eq.3) then
         if (.not.getrvect(fname,topk,top,m3,n3,lr3)) return
         il3=iadr(lr3)
         call entier(m3*n3,stk(lr3),istk(il3))
         top=top-1
      endif
      if (.not.getrmat(fname,topk,top,m2,n2,lr2)) return
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lr1)) return
      if (.not.matsize(fname,topk,top,m2,n2)) return
      if (rhs.eq.2) then
         if (.not.cremat(fname,top+2,0,1,n2,lr3,lc3)) return
         call  dr1('xget'//char(0),'white'//char(0),verb,iwp,na,
     $        v,v,v,dv,dv,dv,dv)
         il3=iadr(lr3)
         do 10 i=1,n2
            istk(il3+i-1)= -1
 10      continue
      else
         if (m3*n3.lt.n2) then
            buf=fname // ' draw vector is too small'
            call error(999)
            return
         endif
      endif
      call  dr1('xpolys'//char(0),'v'//char(0),v,v,
     $     istk(il3),n2,m2,v,stk(lr1),stk(lr2),dv,dv)
      call  objvide(fname,top)
      return
      end        


      subroutine scixselect(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs
      double precision dv
      integer v
      if (.not.checkrhs(fname,-1,-1)) return
      call  dr1('xselect'//char(0),'v'//char(0),
     $     v,v,v,v,v,v,dv,dv,dv,dv)
      call  objvide(fname,top)
      return
      end
     
      subroutine scixset(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,getsmat
      integer topk, lr,nlr,i,m,n,v
cc    <>=xset(str,x1,x2,x3,x4,x5)
      integer x(5)
      double precision xx(5),dv
      x(1)=0
      xx(1)=0
      if (rhs.le.0) then
         buf= 'xsetm();$'
         call demo(fname,buf,0)
         return
      endif
      if (.not.checkrhs(fname,1,6)) return
      topk=top
      do 10 i=5,1,-1
         if (rhs.ge.(i+1)) then
            if (.not.getscalar(fname,topk,top,lr)) return
            x(i)=int(stk(lr))
            xx(i)=stk(lr)
            top=top-1
         endif
 10   continue
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
c     initialisation of a window if argument is not xset('window')
      if (buf(1:nlr).ne.'window')  call sciwin()
      if (buf(1:nlr).eq.'clipping') then
         call dr1('xset'//char(0),buf,v,v,v,v,
     $        v,v,xx(1),xx(2),xx(3),xx(4))
      else
         call dr1('xset'//char(0),buf,x(1),x(2),x(3),x(4),x(5),
     $        v,dv,dv,dv,dv)
      endif
      call objvide(fname,top)
      return
      end
     
      subroutine scixstring(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,getsmat
      integer topk, flag,lr,nlr,v
      double precision x,y,yi,wc,angle,rect(4),dv
cc    <>=xstring(x,y,str,angle,flag)
      integer m,n,ib,m1,n1,i,j,topmat
      flag=0
      angle=0.0
      call sciwin()
      if (.not.checkrhs(fname,3,5)) return
      topk=top
      if (rhs.ge.5) then
         if (.not.getscalar(fname,topk,top,lr)) return
         flag=int(stk(lr))
         top=top-1
      endif
      if (rhs.ge.4) then
         if (.not.getscalar(fname,topk,top,lr)) return
         angle=stk(lr)
         top=top-1
      endif
      if (rhs.ge.3) then
         if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
         topmat=top
         top=top-1
      endif
      if (.not.getscalar(fname,topk,top,lr)) return
      y=stk(lr)
      yi=y
      top=top-1
      if (.not.getscalar(fname,topk,top,lr)) return
      x=stk(lr)
      wc=0.0d00
      do 10 i=m,1,-1
         ib=1
         do 20 j=1,n
            call getsimat(fname,topk,topmat,m1,n1,i,j,lr,nlr)
            call  cvstr(nlr,istk(lr),buf(ib:ib+nlr),1)
            ib=ib+nlr+1
            buf(ib-1:ib-1)= ' '
 20      continue
         buf(ib:ib)=char(0)
         call dr1('xstring'//char(0),buf,v,v,v,0,v,v,x,y,angle,dv) 
         call dr1('xstringl'//char(0),buf,v,v,v,v,v,v,x,y,rect,dv)
         wc=max(wc,rect(3))
C         y=y+2*rect(4)
         y=y+1.2*rect(4)
 10   continue
      y =y-rect(4)/2.0d00
      yi=yi-rect(4)/2.0d00
      call dr1('xstringl'//char(0),'x'//char(0),v,v,v,v,v,v,
     $     x,y,rect,dv)
      x=x-rect(3)/2.0d00
      wc=wc+rect(3)
      if (flag.eq.1) call  dr1('xrect','v'//char(0),v,v,v,v,
     $     v,v,x,y,wc,y-yi)
      call objvide(fname,top)
      return
      end        


      subroutine scixtitle(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getsmat
      integer topk,lr,nlr,v,is
      double precision dv
cc    <>=xstring(x,y,str,angle,flag)
      integer m,n,ib,m1,n1,i,j
      call sciwin()
      if (rhs.lt.0) then
         buf= 'plot2d();'
     $        // 'xtitle([''Titre'';''Principal''],''x'',''y'');$'
         call demo(fname,buf,1)
         return
      endif
      if (.not.checkrhs(fname,1,3)) return
      topk=top
      do 100 is=rhs,1,-1
         if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
         ib=1
         do 10 i=1,m
            do 20 j=1,n
               call getsimat(fname,topk,top,m1,n1,i,j,lr,nlr)
               call  cvstr(nlr,istk(lr),buf(ib:ib+nlr),1)
               ib=ib+nlr+1
               buf(ib-1:ib-1)= ' '
 20         continue
            buf(ib:ib)='@'
            ib=ib+1
 10      continue
         buf(ib:ib)= char(0)
         call dr1('xstringa'//char(0),buf,is,v,v,v,v,v,dv,dv,dv,dv)
         top=top-1
 100  continue
      top=topk-rhs+1
      call objvide(fname,top)
      return
      end        
      
      subroutine scixstringl(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getsmat,getscalar,cremat,checklhs
      integer topk, m,n,lc,nlr,v,lr,lr1,topmat,i,j,m1,n1,ib
      double precision x,y,yi,wc,rect(4),dv
cc    <rect>=xstringl(x,y,str)
      call sciwin()
      if (.not.checkrhs(fname,3,3)) return
      if (.not.checklhs(fname,1,1)) return
      topk=top
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      topmat=top
      top=top-1
      if (.not.getscalar(fname,topk,top,lr)) return
      y=stk(lr)
      yi=y
      top=top-1
      if (.not.getscalar(fname,topk,top,lr)) return
      x=stk(lr)
      wc=0.0d00
      if (.not.cremat(fname,top,0,1,4,lr,lc)) return
      do 10 i=m,1,-1
         ib=1
         do 20 j=1,n
            call getsimat(fname,topk,topmat,m1,n1,i,j,lr1,nlr)
            call  cvstr(nlr,istk(lr1),buf(ib:ib+nlr),1)
            ib=ib+nlr+1
            buf(ib-1:ib-1)= ' '
 20      continue
         buf(ib:ib)=char(0)
         call dr1('xstringl'//char(0),buf,v,v,v,v,v,v,
     $        x,y,rect,dv)
         wc=max(wc,rect(3))
         y=y+1.2*rect(4)
 10   continue
      y =y-rect(4)/2.0d00
      yi=yi-rect(4)/2.0d00
      call dr1('xstringl'//char(0),'x'//char(0),v,v,v,
     $     v,v,v,x,y,rect,dv)
      x=x-rect(3)/2.0d00
      wc=wc+rect(3)
      stk(lr)=x
      stk(lr+1)=y
      stk(lr+2)=wc
      stk(lr+3)=y-yi
      return
      end
     
      subroutine scixtape(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,getsmat,getrmat
      logical getrvect
      double precision alpha,theta,dv
      integer iflag(4),flag(3),iscflag(2),aint(4)
      integer topk, lr,nlr,m,n,num,v,lrr
      integer m7,n7,lr7,m3,n3,lr3,m4,n4,lr4,m5,n5,lr5
      data iflag / 0,0,0,0/,aint /0,0,0,0/
      data iscflag / 1,0/
      if (.not.checkrhs(fname,2,7)) return
      topk=top
      if (rhs.eq.7) then 
         if(.not.getrvect(fname,topk,top,m7,n7,lr7))return
         if (m7*n7.ne.6) then
            buf= fname//' : ebox has a wrong size, 6 expected'
            call error(999)
            return
         endif
         top=top-1
         if(.not.getrvect(fname,topk,top,m,n,lr))return
         if (m*n.ne.3) then
            buf= fname//' : flag has a wrong size, 3 expected'
            call error(999)
            return
         endif
         flag(1)=int(stk(lr))
         flag(2)=int(stk(lr+1))
         flag(3)=int(stk(lr+2))
         top=top-1
         if(.not.getrvect(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : iflag has a wrong size, 4 expected'
            call error(999)
            return
         endif
         iflag(1)=int(stk(lr))
         iflag(2)=int(stk(lr+1))
         iflag(3)=int(stk(lr+2))
         iflag(4)=int(stk(lr+3))
         top=top-1
      endif
C     s'il y a 5 argument 3,4,5 sont iscflag,rect,aint
      if ( rhs.eq.5 ) then 
         if(.not.getrvect(fname,topk,top,m5,n5,lr5))return
         if (m5*n5.ne.4) then
            buf= fname//' : nax has a wrong size, 4 expected'
            call error(999)
            return
         endif
         aint(1)=int(stk(lr5))
         aint(2)=int(stk(lr5+1))
         aint(3)=int(stk(lr5+2))
         aint(4)=int(stk(lr5+3))
         top=top-1
         if(.not.getrvect(fname,topk,top,m4,n4,lrr))return
         if (m4*n4.ne.4) then
            buf= fname//' : rect has a wrong size, 4 expected'
            call error(999)
            return
         endif
         top=top-1
         if(.not.getrvect(fname,topk,top,m3,n3,lr3))return
         if (m3*n3.ne.2) then
            buf= fname//' : iflag has a wrong size, 2 expected'
            call error(999)
            return
         endif
         iscflag(1)=int(stk(lr3))
         iscflag(2)=int(stk(lr3+1))
         top=top-1
      endif
      if ( rhs.eq.6 ) then 
         buf= fname//' : rhs must be 2,3,5 or 7 '
         call error(999)
         return
      endif
C     s'il y a 4 ou 7 argument le 4ieme et le 3ieme sont alpha et theta 
      if (rhs.eq.4.or.rhs.eq.7) then
         if(.not.getscalar(fname,topk,top,lr4))return
         alpha=stk(lr4)
         top=top-1
         if(.not.getscalar(fname,topk,top,lr3))return
         theta=stk(lr3)
         top=top-1
      endif
C     s'il n'y a que trois argument le 3ieme est rect[4] 
      if (rhs.eq.3) then
         if(.not.getrmat(fname,topk,top,m,n,lrr))return
         if (m*n.ne.4) then
            buf= fname//' : rect has a wrong size, 4 expected'
            call error(999)
            return
         endif
         top=top-1
      endif
C     le 2ieme argument : numero de la fenetre 
      if (.not.getscalar(fname,topk,top,lr)) return
      num=int(stk(lr))
      top=top-1
C     le premier argument est une chaine de caractere 
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
      if (buf(1:nlr).eq.'clear') then
         call dr('xstart'//char(0),'v'//char(0),num,v,v,v,v,v,
     $        dv,dv,dv,dv)
      elseif (buf(1:nlr).eq.'replay') then
         call dr('xreplay'//char(0),'v'//char(0),num,v,v,v,v,v
     $        ,dv,dv,dv,dv)
      elseif (buf(1:nlr).eq.'replayna') then
         call dr('xreplayna'//char(0),'v'//char(0),num,v,v,
     $        iflag,flag,v,theta,alpha,stk(lr7),dv)
      elseif (buf(1:nlr).eq.'replaysc') then
         call dr('xreplaysc'//char(0),'v'//char(0),num,iscflag,v,
     $        aint,v,v, stk(lrr),dv,dv,dv)
      elseif (buf(1:nlr).eq.'on') then  
         call dr('xsetdr'//char(0),'Rec'//char(0),
     $        v,v,v,v,v,v,dv,dv,dv,dv)
      else
         buf=fname // ' : str has a wrong value'
         call error(999)
         return
      endif
      call objvide(fname,top)
      return
      end
     
      subroutine scixinfo(fname)
c      subroutine scixinfo(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getsmat
      double precision dv
      integer topk,lr,nlr,m,n,v
      if (.not.checkrhs(fname,1,1)) return
      topk=top
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
      call dr('xinfo'//char(0),buf,v,v,v,v,v,v,dv,dv,dv,dv)
      call objvide(fname,top)
      return
      end
     
      subroutine scixsetech(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrvect,cremat,getsmat
      integer topk, m,n,lr,m1,n1,lr1,ii
      double precision frect(4)
      character*(4) logf
      logf='nn'//char(0)
      data frect / 0.00d0,0.00d0,1.00d0,1.00d0/
      call sciwin()
cc    <>=xsetech(frect1,frect)
      if (.not.checkrhs(fname,1,3)) return
      topk=top
      if ( rhs.eq.1) then 
         if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
         if (.not.cremat(fname,top+1,0,1,4,lr,lc)) return
      else
         if (rhs.ge.3) then
            if(.not.getsmat(fname,topk,top,m,n,1,1,lr3,nlr3))return
            if (nlr3.ne.2) then
               buf=fname//' : logflag has a wrong size,2 expected'
               call error(999)
               return
            endif
            call cvstr(nlr3,istk(lr3),logf,1)
            top=top-1
         endif
         if (.not.getrvect(fname,topk,top,m,n,lr)) return
         if (m*n.ne.4) then 
            buf= fname //' frect has a wrong size (4) expected'
            call  error(999)
            return
         endif
         do 10 ii=1,4
            frect(ii)= stk(lr+ii-1)
 10      continue
         top=top-1
         if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
      endif
      if (m1*n1.ne.4) then 
         buf= fname //' frect1 has a wrong size (4) expected'
         call  error(999)
         return
      endif
      call  setscale2d(stk(lr1),frect,logf)
      call  objvide(fname,top)
      return
      end
     
      subroutine scixgetech(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical cremat,checklhs,cresmat
      integer topk, lr1,lc1,lr2,lc2,m1,n1,lr,nlr
      character*(2) logf
      call sciwin()
      if (.not.checklhs(fname,2,3)) return
      topk=top
      if (top.eq.0.or.rhs.lt.0)  top=top+1
c      if (top.eq.1) lstk(top)=1
      if (.not.cremat(fname,top,0,1,4,lr1,lc1)) return
      top=top+1
      if (.not.cremat(fname,top,0,1,4,lr2,lc2)) return
      call getscale2d(stk(lr1),stk(lr2),logf)
      if (lhs.eq.3) then 
         top=top+1
         if (.not.cresmat(fname,top,1,1,2)) return
         call getsimat(fname,top,top,m1,n1,1,1,lr,nlr)
         call cvstr(2,istk(lr),logf,0)
      endif
      return
      end

      subroutine sciwin()
C     verifie qu'il y a bien une fenetre graphique
C     s'il n'y en a pas essaye d'en creer une
c      implicit undefined (a-z)
      include '../stack.h'
      integer verb,win,na,v
      double precision dv
      verb=0
      call dr('xget'//char(0),'window'//char(0),verb,win,na,
     $     v,v,v,dv,dv,dv,dv)
      call dr('xset'//char(0),'window'//char(0),win,
     $     v,v,v,v,v,dv,dv,dv,dv)
      return
      end
     
     

ccC   fec(x,y,triangles,func,strf,leg,rect,nax);
ccC   fec(x,y,triangles,func,[strf,leg,rect,nax]);
      subroutine scifec(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getrmat,getsmat,matsize,getrvect
      integer topk, m1,n1,lr1,m2,n2,lr2,m3,n3,lr3,m4,n4
      integer nax(4),m,n,lr,lr5,nlr5,lr4,nlr4
      double precision rect(4)
      character*(4) strf
      data nax / 2,10,2,10/
      data rect / 0.0d00,0.0d00,10.0d00,10.0d00/
      if (rhs.lt.0) then
         buf=' exec("SCI/demos/fec/fec.ex1");$'
         call demo(fname,buf,1)
         return
      endif
      buf='X@Y@Z'//char(0)
      strf='021'//char(0)
      if (.not.checkrhs(fname,4,8)) return
      topk=top
      if (rhs.ge.8) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : nax has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call entier(4,stk(lr),nax)
         do 10 i=1,4
            nax(i)=max(nax(i),1)
 10      continue
         top=top-1
      endif
      if (rhs.ge.7) then
         if(.not.getrmat(fname,topk,top,m,n,lr))return
         if (m*n.ne.4) then
            buf= fname//' : rect has a wrong size, 4 expected'
            call error(999)
            return
         endif
         call dcopy(4,stk(lr),1,rect,1)
         top=top-1
      endif
      if (rhs.ge.6) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr5,nlr5))return
         if (nlr5.eq.0) then
            buf=fname//' : legend is an empty string'
            call error(999)
            return
         endif
         call cvstr(nlr5,istk(lr5),buf,1)
         buf(nlr5+1:nlr5+1)=char(0)
         top=top-1
      endif
      if (rhs.ge.5) then
         if(.not.getsmat(fname,topk,top,m,n,1,1,lr4,nlr4))return
         if (nlr4.ne.3) then
            buf=fname//' : strf has a wrong size, 3 expected'
            call error(999)
            return
         endif
         call cvstr(nlr4,istk(lr4),strf,1)
         top=top-1
      endif
      if (rhs.ge.4) then
C        valeur de la fonction sur les Noeuds 
         if (.not.getrvect(fname,topk,top,m4,n4,lr4)) return
         top=top-1
C        matrice des triangles 
         if (.not.getrmat(fname,topk,top,m3,n3,lr3)) return
         if (n3.ne.5) then 
            buf=fname//'triangles must have 5 columns'
            call error(999)
            return
         endif
         top=top-1
C        y des noeuds 
         if (.not.getrvect(fname,topk,top,m2,n2,lr2)) return
         if (.not.matsize(fname,topk,top,m4,n4)) return
         top=top-1
C        x des noeuds 
         if (.not.getrvect(fname,topk,top,m1,n1,lr1)) return
         if (.not.matsize(fname,topk,top,m2,n2)) return
      endif
      call sciwin()
      call fec(stk(lr1),stk(lr2),stk(lr3),stk(lr4),m1*n1,m3
     $     ,strf,buf,rect,nax)
      call objvide(fname,top)
      return
      end

      subroutine scixgetmouse(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical cremat,checklhs
      integer topk, lr,lc,v
      double precision  x,y,dv
      integer i
      call sciwin()
      call dr1('xgetmouse'//char(0),'xv'//char(0),i,v,v,v,v,v,
     $     x,y,dv,dv)
      if (top.eq.0.or.rhs.lt.0)  top=top+1
c      if (top.eq.1) lstk(top)=1
      if (.not.checklhs(fname,1,1)) return
      topk=top
      if (.not.cremat(fname,top,0,1,3,lr,lc)) return
      stk(lr)=x
      stk(lr+1)=y
      stk(lr+2)=i
      return
      end

      subroutine scixsave(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,getsmat 
      integer topk, lr,verb,na,v,wid,m,n,nlr
      double precision dv
      verb=0
      call sciwin()
      if (.not.checkrhs(fname,1,2)) return
      topk=top
      if (rhs.eq.2) then
         if (.not.getscalar(fname,topk,top,lr)) return
         wid=int(stk(lr))
         top = top-1 
      else
         call dr('xget'//char(0),'window'//char(0),verb,wid,na,v,v,v,
     $        dv,dv,dv,dv)
      endif
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
      call xsaveplots(wid,buf)
      call  objvide(fname,top)
      return
      end

      subroutine scixload(fname)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar,getsmat 
      integer topk, lr,verb,v,wid,m,n,nlr
      double precision dv
      verb=0
      call sciwin()
      if (.not.checkrhs(fname,1,2)) return
      topk=top
      if (rhs.eq.2) then
         if (.not.getscalar(fname,topk,top,lr)) return
         wid=int(stk(lr))
         call dr('xset'//char(0),'window'//char(0),wid,
     $        v,v,v,v,v,dv,dv,dv,dv)
         top=top-1
      endif
      if (.not.getsmat(fname,topk,top,m,n,1,1,lr,nlr)) return
      call  cvstr(nlr,istk(lr),buf,1)
      buf(nlr+1:nlr+1)=char(0)
      call xloadplots(buf)
      call  objvide(fname,top)
      return
      end

      subroutine scidelw(fname)
C     OK
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,getscalar
      integer win,topk,lr1
      integer verb,na,v
      double precision dv
      topk=top
cc    <>=driver(dr_name)
      if (.not.checkrhs(fname,-1,1)) return
      if (rhs.ge.1) then
         if(.not.getscalar(fname,topk,top,lr1))return
         win=int(stk(lr1))
      else
         call dr('xget'//char(0),'window'//char(0),verb,win,na,
     $        v,v,v,dv,dv,dv,dv)
      endif      
      call deletewin(win)
      call objvide(fname,top)
      return
      end
