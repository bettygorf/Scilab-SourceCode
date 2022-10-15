      program scilab
* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*
* I.N.R.I.A      DOMAINE DE VOLUCEAU  -  BP 105  -  ROCQUENCOURT
*                78153   LE  CHESNAY  CEDEX
* ....................................................................
      character*80  bu1
      integer       init,nc
      bu1  = ' '
      init = -1
      call matlab( init, bu1)
      call inffic( 2, bu1,nc)
      nc   = max ( 1 , nc )
      init = -2
      call matlab( init, bu1(1:nc))
      end
