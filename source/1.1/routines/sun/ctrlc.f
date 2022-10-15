C/MEMBR ADD NAME=CTRLC,SSI=0
      subroutine ctrlc
c
c ====================================================================
c scilab . librairie vax
c ====================================================================
c
c gestion du controle c sous vax/vms
c
c ====================================================================
c
c ================================== ( Inria    ) =============
c
      external sigbas
c      integer  is
c
c vax/vms
c -------
c
c      integer*4 tt_chan,sys$qiow
c      common / brk1 / tt_chan
c      include '($iodef)'
cc
c      is=sys$qiow(,%val(tt_chan),%val(io$_setmode.or.io$m_ctrlcast),
c     1            ,,,sigbas,,%val(3),,,)
c
c fin
c ---
c
      end
