      program gcall
      character*7 name
      character*7 blocks(1000)
      character *40 buf

      open(10,file='blocknames',status='old',form='formatted')
      open(11,file='blocks.h',status='unknown',form='formatted')
      
      i=1
 10   continue
      read(10,'(a)',err=100,end=20) blocks(i)
      i=i+1
      goto 10
 20   continue
      n=i-1
      do 30  i=1,n
         name=blocks(i)
         l=lnblnk(name)
         if(l.gt.0) then
            buf='extern void F2C('//name(1:l)//')();'
            write(11,'(40a1)') (buf(j:j),j=1,len(buf))
         endif
 30   continue

      buf='OpTab tabsim[] ={'
      write(11,'(40a1)') (buf(j:j),j=1,len(buf))

      do 35  i=1,n
         name=blocks(i)
         l=lnblnk(name)
         if(l.gt.0) then
            buf='  "' // name(1:l) // '",F2C(' // name(1:l) // '),'
            write(11,'(40a1)') (buf(j:j),j=1,len(buf))
         endif
 35   continue
      buf='  (char *)NULL,vide'
      write(11,'(40a1)') (buf(j:j),j=1,len(buf))
      buf='};'
      write(11,'(40a1)') (buf(j:j),j=1,len(buf))

      write(11,'(''int ntabsim = '',i4,'';'')') n
      stop
 100  print *, 'Incorrect input file'
      stop
      end
