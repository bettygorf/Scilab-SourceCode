C/MEMBR ADD NAME=ISEYE,SSI=0
      logical function iseye(ib)
      integer ib(3),eye(3)
      data eye/14,34,14/
      iseye=.false.
      do 10 i=1,3
      if (ib(i).ne.eye(i)) return
 10   continue
      iseye=.true.
      return
      end
