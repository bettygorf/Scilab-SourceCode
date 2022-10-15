      subroutine banier( wwte )
c ====================================================================
c      prints entry message for scilab 
c      wwte   unite d'impression du terminal
c ================================== ( inria    ) =============
      integer    wwte
      character  instal*14, nuver*3
      integer    io
      instal = '2 January 1994'
      nuver  = '1.1'
      if(wwte.ne.999) then 
         call basout(io,wwte,
     $'                           ===========')
         call basout(io,wwte,
     $'                           S c i l a b')
         call basout(io,wwte,
     $'                           ===========')
         call basout(io,wwte,' ')
         call basout(io,wwte,' ')
         call basout(io,wwte,
     $'                  Version ' // nuver // ' (' // instal // ')')
         call basout(io,wwte,
     $'                  Copyright (C) 1989-94 INRIA ')
      endif
      return 
      end
