      subroutine test(m,n,k,mn)
      if (k.ge.0) then
         mn=max(0,min(m,n-k))
      else
         mn=max(0,min(m+k,n))
      endif
      return
      end
