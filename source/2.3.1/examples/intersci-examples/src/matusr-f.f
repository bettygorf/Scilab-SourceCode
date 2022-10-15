       subroutine fcalc(i) 
       integer i(*) 
       i(1)=10+i(1)
       return 
       end 

       subroutine  fcalc1(ii,m1,n1,db,m2,n2,rea,m3,n3)
       integer ii(*) 
       double precision db(*) 
       real rea(*) 
       do 10 i=1,m1*n1
          ii(i) =i + ii(i) 
 10    continue
       do 20 i=1,m2*n2
          db(i) = dble(i) + db(i) 
 20    continue
       do 30 i=1,m3*n3
          rea(i) = real(i) + rea(i) 
 30    continue
       return
       end

       subroutine  fcalc2(ii,m1,n1,db,m2,n2,rea,m3,n3)
       integer ii(*) 
       double precision db(*) 
       real rea(*) 
       do 10 i=1,m1*n1
          ii(i) =i 
 10    continue
       do 20 i=1,m2*n2
          db(i) = dble(i)
 20    continue
       do 30 i=1,m3*n3
          rea(i) = real(i)
 30    continue
       return
       end

       subroutine fcalc7(a,b,c,d)
       integer a(*),d(*)
       double precision b(*)
       character c(*) 
       d(1)=d(1)+10
       return
       end

       subroutine  fcalc9(b,c,d)
       double precision b(*) ,c(*) 
       character d(*)
       b(1) = 10.0
       c(1) =20.0 
       return
       end










