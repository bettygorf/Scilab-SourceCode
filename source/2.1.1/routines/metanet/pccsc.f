      subroutine pccsc(i0,la1,long,lp1,ls1,m,n,ordre,p,pi)
      implicit integer (a-z)
      dimension la1(m),lp1(*),ls1(m),p(n),ordre(n)
      doubleprecision pi(n),long(m),infr,z
      do 10 i=1,n
         pi(i)=0.
         p(i)=0
 10   continue
      do 30 i=1,n
         if(lp1(i).eq.lp1(i+1))goto 30
         do 20 ll=lp1(i),lp1(i+1)-1
            j=ls1(ll)
            pi(j)=pi(j)-1
 20      continue
 30   continue
      k=0
      newtop=0
      do 40 i=1,n
         if(pi(i).lt.0.)goto 40
         newtop=newtop+1
         p(newtop)=i
 40   continue
      oldtop=newtop
      bottom=0
      iordre=0
 100  continue
      if(bottom.eq.oldtop)goto 200
      bottom=bottom+1
      i=p(bottom)
      pi(i)=k
      iordre=iordre+1
      ordre(iordre)=i
      if(lp1(i).eq.lp1(i+1))goto 100
      do 130 ll=lp1(i),lp1(i+1)-1
         j=ls1(ll)
         pi(j)=pi(j)+1
         if(pi(j).ne.0.)goto 130
         newtop=newtop+1
         p(newtop)=j
 130  continue
      goto 100
 200  continue
      if(bottom.eq.n)goto 300
      if(oldtop.ne.newtop)goto 210
      call erro('the graph has a circuit')
      return
 210  continue
      k=k+1
      oldtop=newtop
      goto 100
 300  continue
      infr=10.e6
      infe=32700
      do 310 i=1,n
         pi(i)=  infr
         p(i)= - infe
 310  continue
      pi(i0)=0.
      p(i0)=0
      do 460 ii=1,n
         i=ordre(ii)
         if(lp1(i).eq.lp1(i+1))goto 460
         do 450 ll= lp1(i),lp1(i+1)-1
            u=la1(ll)
            j=ls1(ll)
            z=pi(i)+long(u)
            if(z.ge.pi(j))goto 450
            pi(j)=z
            p(j)=i
 450     continue
 460  continue
      end
