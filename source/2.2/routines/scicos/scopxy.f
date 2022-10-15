      subroutine scopxy(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     ipar(1) = win_num
c     ipar(2) = 0/1 color flag
c     ipar(3) = buffer size
c     ipar(4) = dash,color or mark choice
c     ipar(5) = line or mark size
c     ipar(6) = mode : animated =0 fixed=1
c
c     rpar(1)=xmin
c     rpar(2)=xmax
c     rpar(3)=ymin
c     rpar(4)=ymax
c
      double precision xmin,xmax,ymin,ymax,rect(4)
      integer n,verb,cur,na,v,wid,nax(4)
      character*20 strf,buf
      double precision dv
      double precision frect(4)
      character*(4) logf
      common /dbcos/ idb
      data frect / 0.00d0,0.00d0,1.00d0,1.00d0/
      data cur/0/

c     
      if(idb.eq.1) then
         write(6,'(''Scopxy t='',e10.3,'' flag='',i1,''window='',i3)') t
     $        ,flag,ipar(1) 
      endif
c     
      if(flag.eq.2) then
         wid=ipar(1)
         N=ipar(3)
c     
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
c     erase first point
         if(ipar(6).eq.0) then
            z(1)=z(1)+1.0d0
            if(ipar(4).gt.0) then
               call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(4),
     &              1,1,v,z(2),z(2+N),dv,dv)
            else
               call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(4),
     &              1,2,v,z(2),z(2+N),dv,dv)
            endif
         endif
c     shift buffer left
         call dcopy(N-1,z(3),1,z(2),1)
         z(N+1)=u(1)
         call dcopy(N-1,z(N+3),1,z(N+2),1)
         z(2*N+1)=u(2)
c     draw new point
         if(ipar(4).gt.0) then
            call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(4),
     &           1,1,v,z(1+N),z(1+2*N),dv,dv)
         else
            call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(4),
     &           1,2,v,z(N),z(2*N),dv,dv)
         endif
         if(int(z(1)).gt.N.and.ipar(6).eq.0) then
c     erase memory
            call dr('xstart'//char(0),'v'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv) 
            z(1)=0.0d0
         endif
      elseif(flag.eq.4) then
         wid=ipar(1)
         N=ipar(3)
         xmin=rpar(1)
         xmax=rpar(2)
         ymin=rpar(3)
         ymax=rpar(4)
         nax(1)=2
         nax(2)=10
         nax(3)=2
         nax(4)=10
         call sciwin()
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         logf='nn'//char(0)
         call  setscale2d(frect,frect,logf)
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $        dv,dv,dv,dv)
         call dr('xstart'//char(0),'v'//char(0),wid,v,v,v,v,v,
     $        dv,dv,dv,dv)
         buf='t@ @input and output'
         strf='011'//char(0)
         rect(1)=xmin
         rect(2)=ymin
         rect(3)=xmax
         rect(4)=ymax
         call  setscale2d(frect,rect,'nn'//char(0))
         call dr1('xset'//char(0),'dashes'//char(0),0,0,0,
     &        0,0,v,dv,dv,dv,dv)
         call dr1('xset'//char(0),'alufunction'//char(0),3,v,v,v,v,v,
     $        dv,dv,dv,dv)
         call plot2d(rect(1),rect(2),1,1,-1,strf,buf,rect,nax)
         call dr1('xset'//char(0),'alufunction'//char(0),6,v,v,v,v,v,
     $        dv,dv,dv,dv)
c first point drawing
         if(ipar(4).gt.0) then
            call dr1('xset'//char(0),'mark'//char(0),ipar(4),ipar(5),
     $        v,v,v,v,dv,dv,dv,dv)
            call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(4),
     &           1,1,v,z(2),z(2+N),dv,dv)
         else
            call dr1('xset'//char(0),'thickness'//char(0),ipar(5),v,
     $        v,v,v,v,dv,dv,dv,dv)
            call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(4),
     &           1,2,v,z(2),z(2+N),dv,dv)
         endif
         z(1)=0
         
      elseif(flag.eq.5) then
         call dr1('xset'//char(0),'alufunction'//char(0),3,v,v,v,v,v,
     $        dv,dv,dv,dv)
      endif
      end
