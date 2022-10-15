      subroutine mpstyp(ivt,job)
c     definition of first field  of tlist's type: mps
c     tlist fields are:
c     irobj
c     namec
c     nameb
c     namran
c     nambnd
c     name
c     rownames
c     colnames
c     rowstat
c     rowcode
c     colcode
c     rownmbs
c     colpnts
c     acoeff
c     rhs
c     ranges
c     bounds
c     stavar
c
      integer ivt(*),l
      character*(*) job
c
      if(job.eq.'size') then
c        size of the data structure
         ivt(1)=136
      elseif(job.eq.'nchar') then
c        number of chars defining the type field
         ivt(1)=112
      elseif(job.eq.'nfield') then
c        number of fields in the tlist
         ivt(1)=19
      elseif(job.eq.'ptr') then
c        pointers on individual strings
         ivt(1)=1
         ivt(2)=4
         ivt(3)=9
         ivt(4)=14
         ivt(5)=19
         ivt(6)=25
         ivt(7)=31
         ivt(8)=35
         ivt(9)=43
         ivt(10)=51
         ivt(11)=58
         ivt(12)=65
         ivt(13)=72
         ivt(14)=79
         ivt(15)=86
         ivt(16)=92
         ivt(17)=95
         ivt(18)=101
         ivt(19)=107
         ivt(20)=113
      else
c        Character string Variable header
         ivt(1)=10
         ivt(2)=1
         ivt(3)=19
         ivt(4)=0
         ivt(5)=1
         l=24
c        entry (1,1) = "mps"
         ivt(l+1)=22
         ivt(l+2)=25
         ivt(l+3)=28
         ivt(6)=ivt(5)+3
         l=l+3
c        entry (2,1) = "irobj"
         ivt(l+1)=18
         ivt(l+2)=27
         ivt(l+3)=24
         ivt(l+4)=11
         ivt(l+5)=19
         ivt(7)=ivt(6)+5
         l=l+5
c        entry (3,1) = "namec"
         ivt(l+1)=23
         ivt(l+2)=10
         ivt(l+3)=22
         ivt(l+4)=14
         ivt(l+5)=12
         ivt(8)=ivt(7)+5
         l=l+5
c        entry (4,1) = "nameb"
         ivt(l+1)=23
         ivt(l+2)=10
         ivt(l+3)=22
         ivt(l+4)=14
         ivt(l+5)=11
         ivt(9)=ivt(8)+5
         l=l+5
c        entry (5,1) = "namran"
         ivt(l+1)=23
         ivt(l+2)=10
         ivt(l+3)=22
         ivt(l+4)=27
         ivt(l+5)=10
         ivt(l+6)=23
         ivt(10)=ivt(9)+6
         l=l+6
c        entry (6,1) = "nambnd"
         ivt(l+1)=23
         ivt(l+2)=10
         ivt(l+3)=22
         ivt(l+4)=11
         ivt(l+5)=23
         ivt(l+6)=13
         ivt(11)=ivt(10)+6
         l=l+6
c        entry (7,1) = "name"
         ivt(l+1)=23
         ivt(l+2)=10
         ivt(l+3)=22
         ivt(l+4)=14
         ivt(12)=ivt(11)+4
         l=l+4
c        entry (8,1) = "rownames"
         ivt(l+1)=27
         ivt(l+2)=24
         ivt(l+3)=32
         ivt(l+4)=23
         ivt(l+5)=10
         ivt(l+6)=22
         ivt(l+7)=14
         ivt(l+8)=28
         ivt(13)=ivt(12)+8
         l=l+8
c        entry (9,1) = "colnames"
         ivt(l+1)=12
         ivt(l+2)=24
         ivt(l+3)=21
         ivt(l+4)=23
         ivt(l+5)=10
         ivt(l+6)=22
         ivt(l+7)=14
         ivt(l+8)=28
         ivt(14)=ivt(13)+8
         l=l+8
c        entry (10,1) = "rowstat"
         ivt(l+1)=27
         ivt(l+2)=24
         ivt(l+3)=32
         ivt(l+4)=28
         ivt(l+5)=29
         ivt(l+6)=10
         ivt(l+7)=29
         ivt(15)=ivt(14)+7
         l=l+7
c        entry (11,1) = "rowcode"
         ivt(l+1)=27
         ivt(l+2)=24
         ivt(l+3)=32
         ivt(l+4)=12
         ivt(l+5)=24
         ivt(l+6)=13
         ivt(l+7)=14
         ivt(16)=ivt(15)+7
         l=l+7
c        entry (12,1) = "colcode"
         ivt(l+1)=12
         ivt(l+2)=24
         ivt(l+3)=21
         ivt(l+4)=12
         ivt(l+5)=24
         ivt(l+6)=13
         ivt(l+7)=14
         ivt(17)=ivt(16)+7
         l=l+7
c        entry (13,1) = "rownmbs"
         ivt(l+1)=27
         ivt(l+2)=24
         ivt(l+3)=32
         ivt(l+4)=23
         ivt(l+5)=22
         ivt(l+6)=11
         ivt(l+7)=28
         ivt(18)=ivt(17)+7
         l=l+7
c        entry (14,1) = "colpnts"
         ivt(l+1)=12
         ivt(l+2)=24
         ivt(l+3)=21
         ivt(l+4)=25
         ivt(l+5)=23
         ivt(l+6)=29
         ivt(l+7)=28
         ivt(19)=ivt(18)+7
         l=l+7
c        entry (15,1) = "acoeff"
         ivt(l+1)=10
         ivt(l+2)=12
         ivt(l+3)=24
         ivt(l+4)=14
         ivt(l+5)=15
         ivt(l+6)=15
         ivt(20)=ivt(19)+6
         l=l+6
c        entry (16,1) = "rhs"
         ivt(l+1)=27
         ivt(l+2)=17
         ivt(l+3)=28
         ivt(21)=ivt(20)+3
         l=l+3
c        entry (17,1) = "ranges"
         ivt(l+1)=27
         ivt(l+2)=10
         ivt(l+3)=23
         ivt(l+4)=16
         ivt(l+5)=14
         ivt(l+6)=28
         ivt(22)=ivt(21)+6
         l=l+6
c        entry (18,1) = "bounds"
         ivt(l+1)=11
         ivt(l+2)=24
         ivt(l+3)=30
         ivt(l+4)=23
         ivt(l+5)=13
         ivt(l+6)=28
         ivt(23)=ivt(22)+6
         l=l+6
c        entry (19,1) = "stavar"
         ivt(l+1)=28
         ivt(l+2)=29
         ivt(l+3)=10
         ivt(l+4)=31
         ivt(l+5)=10
         ivt(l+6)=27
         ivt(24)=ivt(23)+6
         l=l+6
      endif
      return
      end
