C/MEMBR ADD NAME=R1MACH,SSI=0
      real function r1mach(i)
c!but
c  single-precision machine constants
c
c  r1mach(1) = b**(emin-1), the smallest positive magnitude.
c  r1mach(2) = b**emax*(1 - b**(-t)), the largest magnitude.
c  r1mach(3) = b**(-t), the smallest relative spacing.
c  r1mach(4) = b**(1-t), the largest relative spacing.
c  r1mach(5) = log10(b)
c!
c  this routine is from the port mathematical subroutine library
c  it is described in the bell laboratories computing science
c  technical report #47 by p.a. fox, a.d. hall and n.l. schryer
c  a modification to the "i out of bounds" error message
c  has been made by c. a. mcgonegal - april, 1978
c
c  to alter this function for a particular environment,
c  the desired set of data statements should be activated by
c  removing the c from column 1.
c
c  where possible, octal or hexadecimal constants have been used
c  to specify the constants exactly which has in some cases
c  required the use of equivalent integer arrays.
c
      integer small(2)
      integer large(2)
      integer right(2)
      integer diver(2)
      integer lodec(2)
c
      real rmach(5)
c
      equivalence (rmach(1),small(1))
      equivalence (rmach(2),large(1))
      equivalence (rmach(3),right(1))
      equivalence (rmach(4),diver(1))
      equivalence (rmach(5),lodec(1))
c
c     machine constants for the burroughs 1700 system.
c
c     data rmach(1) / z400800000 /
c     data rmach(2) / z5ffffffff /
c     data rmach(3) / z4e9800000 /
c     data rmach(4) / z4ea800000 /
c     data rmach(5) / z500e730e8 /
c
c     machine constants for the burroughs 5700/6700/7700 systems.
c
c     data rmach(1) / o1771000000000000 /
c     data rmach(2) / o0777777777777777 /
c     data rmach(3) / o1311000000000000 /
c     data rmach(4) / o1301000000000000 /
c     data rmach(5) / o1157163034761675 /
c
c     machine constants for the cdc 6000/7000 series.
c
c     data rmach(1) / 00014000000000000000b /
c     data rmach(2) / 37767777777777777777b /
c     data rmach(3) / 16404000000000000000b /
c     data rmach(4) / 16414000000000000000b /
c     data rmach(5) / 17164642023241175720b /
c
c     machine constants for the cdc 180/nos-ve
c
c     data rmach(1) / z"3000800000000000" /
c     data rmach(2) / z"4fffffffffffffff"/
c     data rmach(3) / 7.10542735760100e-15 /
c     data rmach(4) / 1.42108547152020e-14 /
c     data rmach(5) / 0.301029995664 /
c
c     machine constants for the cray 1
c
c     data rmach(1) / 200004000000000000000b /
c     data rmach(2) / 577767777777777777776b /
c     data rmach(3) / 377224000000000000000b /
c     data rmach(4) / 377234000000000000000b /
c     data rmach(5) / 377774642023241175720b /
c
c     machine constants for the data general eclipse s/200
c
c     note - it may be appropriate to include the following card -
c     static rmach(5)
c
c     data small/20k,0/,large/77777k,177777k/
c     data right/35420k,0/,diver/36020k,0/
c     data lodec/40423k,42023k/
c
c     machine constants for the harris slash 6 and slash 7
c
c     data small(1),small(2) / '20000000, '00000201 /
c     data large(1),large(2) / '37777777, '00000177 /
c     data right(1),right(2) / '20000000, '00000352 /
c     data diver(1),diver(2) / '20000000, '00000353 /
c     data lodec(1),lodec(2) / '23210115, '00000377 /
c
c     machine constants for the honeywell 600/6000 series.
c
c     data rmach(1) / o402400000000 /
c     data rmach(2) / o376777777777 /
c     data rmach(3) / o714400000000 /
c     data rmach(4) / o716400000000 /
c     data rmach(5) / o776464202324 /
c
c     machine constants for the ibm 360/370 series,
c     the xerox sigma 5/7/9 and the sel systems 85/86.
c
c     data rmach(1) / z00100000 /
c     data rmach(2) / z7fffffff /
c     data rmach(3) / z3b100000 /
c     data rmach(4) / z3c100000 /
c     data rmach(5) / z41134413 /
c
c     machine constants for the ibm 3090/tso et vm, the ibm 4380/vm
c
c     data rmach(1) / 2.159042138773611160e-78 /
c     data rmach(2) / 9.046256971665327770e+74 /
c     data rmach(3) / 4.768371580e-07 /
c     data rmach(4) / 3.814697270e-06 /
c     data rmach(5) / 1.2041199826559248  /
c
c     machine constants for the gouls sel/x32
c
c     data rmach(1) / 5.397600e-79 /
c     data rmach(2) / 7.237000e+75 /
c     data rmach(3) / 4.768370e-07 /
c     data rmach(4) / 9.536740e-07 /
c     data rmach(5) / 1.204120e+00 /
c
c     machine constants for the pdp-10 (ka or ki processor).
c
c     data rmach(1) / "000400000000 /
c     data rmach(2) / "377777777777 /
c     data rmach(3) / "146400000000 /
c     data rmach(4) / "147400000000 /
c     data rmach(5) / "177464202324 /
c
c     machine constants for pdp-11 fortran's supporting
c     32-bit integers (expressed in integer and octal).
c
c
c     machine constants for pdp-11 fortran's supporting
c     32-bit integers (expressed in integer and octal).
c
c     data small(1) /    8388608 /
c     data large(1) / 2147483647 /
c     data right(1) /  880803840 /
c     data diver(1) /  889192448 /
c     data lodec(1) / 1067065499 /
c
c     data rmach(1) / o00040000000 /
c     data rmach(2) / o17777777777 /
c     data rmach(3) / o06440000000 /
c     data rmach(4) / o06500000000 /
c     data rmach(5) / o07746420233 /
c
c     machine constants for pdp-11 fortran's supporting
c     16-bit integers  (expressed in integer and octal).
c
c     data small(1),small(2) /   128,     0 /
c     data large(1),large(2) / 32767,    -1 /
c     data right(1),right(2) / 13440,     0 /
c     data diver(1),diver(2) / 13568,     0 /
c     data lodec(1),lodec(2) / 16282,  8347 /
c
c     data small(1),small(2) / o000200, o000000 /
c     data large(1),large(2) / o077777, o177777 /
c     data right(1),right(2) / o032200, o000000 /
c     data diver(1),diver(2) / o032400, o000000 /
c     data lodec(1),lodec(2) / o037632, o020233 /
c
c     machine constants for the univac 1100 series.
c
c     data rmach(1) / o000400000000 /
c     data rmach(2) / o377777777777 /
c     data rmach(3) / o146400000000 /
c     data rmach(4) / o147400000000 /
c     data rmach(5) / o177464202324 /
c
c     machine constants for the vax-11 with
c     fortran iv-plus compiler
c
c     data rmach(1) / z00000080 /
c     data rmach(2) / zffff7fff /
c     data rmach(3) / z00003480 /
c     data rmach(4) / z00003500 /
c     data rmach(5) / z209b3f9a /
c
c     machine constants for the apollo domain : 68020
c     machine constants for the alliant  unix
c     machine constants for the hp9000   unix
c     machine constants for the motorola vm121 unix systeme 5 68010
c     machine constants for the sun      unix
c     machine constants for the sps9     spix
c     machine constants for the unigraph unix
c     machine constants for the symbolic
c
      data rmach(1),rmach(2) / 1.1754943510e-38, 1.7014118350e+38 /
      data rmach(3),rmach(4) / 1.1920928960e-07, 2.3841857920e-07 /
      data rmach(5)          / 0.301029995664 /
c
      if ( i.lt.1 .or. i.gt.5 ) goto 100
      r1mach = rmach(i)
      return
c
  100 iwunit = i1mach(4)
      write(iwunit, 99)
   99 format(/,1x,'%% error in r1mach - i out of bounds')
      stop
      end
