      subroutine evscpe(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     ipar(1) = win_num
c     ipar(2) = 0/1 color flag
c     rpar(1)=periode
c
      double precision ymin,ymax,per,rect(4),xx(2),yy(2)
      integer verb,cur,na,v,wid,nax(4)
      character*20 strf,buf
      double precision dv
      double precision frect(4)
      character*(4) logf
      common /dbcos/ idb
      data frect / 0.00d0,0.00d0,1.00d0,1.00d0/
      data cur/0/
      data yy / 0.00d0,0.80d0/
c     
      if(idb.eq.1) then
         write(6,'(''evscpe t='',e10.3,'' flag='',i1,''window='',i3)') t
     $        ,flag,ipar(1) 
      endif
c     
      if(flag.eq.2) then
         per=rpar(1)
         wid=ipar(1)
         if(t/per.ge.z(1)) then
            z(1)=int(t/per)+1.0d0
c     clear window
            nax(1)=2
            nax(2)=10
            nax(3)=2
            nax(4)=10
            call dr1('xget'//char(0),'window'//char(0),verb,cur,na,
     $		v,v,v,
     $          dv,dv,dv,dv)
            if(cur.ne.wid) then
               call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $              dv,dv,dv,dv)
            endif

            call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $           dv,dv,dv,dv)
            call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &           0,0,v,dv,dv,dv,dv)
            call dr('xstart'//char(0),'v'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
            buf='t@ @input and output'
            strf='011'//char(0)
            rect(1)=per*(z(1)-1.0d0)
            rect(2)=0.0d0
            rect(3)=per*z(1)
            rect(4)=1.0d0
            call dr1('xset'//char(0),'dashes'//char(0),0,0,0,
     &           0,0,v,dv,dv,dv,dv)
            call plot2d(rect(1),rect(2),1,1,-1,strf,buf,rect,nax)
         endif
c
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,
     $		v,v,v,
     $          dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         buf='xlines'//char(0)
         xx(1)=t
         xx(2)=t
         call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(2+nclock),
     &        1,2,v,xx,yy,dv,dv)
c
      elseif(flag.eq.4) then
         wid=ipar(1)
         ymin=0.0d0
         ymax=1.0d0
         per=rpar(1)
         nax(1)=2
         nax(2)=10
         nax(3)=2
         nax(4)=10
         n1=int(t)/per
         if(t.le.0.0d0) n1=n1-1
         call sciwin()
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,
     $        v,v,v,
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
         rect(1)=per*(1+n1)
         rect(2)=ymin
         rect(3)=per*(2+n1)
         rect(4)=ymax
         call  setscale2d(frect,rect,'nn'//char(0))
         call dr1('xset'//char(0),'dashes'//char(0),0,0,0,
     &        0,0,v,dv,dv,dv,dv)
         call plot2d(rect(1),rect(2),1,1,-1,strf,buf,rect,nax)
         z(1)=0.0d0

      endif
      end
