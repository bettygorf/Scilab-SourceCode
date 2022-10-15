//FICHIER_DE_TEST ADD NAME=DISPLAY.TST,SSI=0
//
z=poly(0,'z')
//lines(20,60)
format('v',10)
num=[ (((((1)*z-2.6533333)*z+2.6887936)*z-1.2916784)*z+0.2911572)*...
     z-0.0243497
      (((((1)*z-2.6533333)*z+2.6887936)*z-1.2916784)*z+0.2911572)*...
     z-0.0243497
     (((1)*z )*z )*z+1
     0]
den = [ ((((1)*z-1.536926)*z+0.8067352)*z-0.1682810)*z+0.0113508
((((1)*z-1.536926)*z+0.8067352)*z-0.1682810)*z+0.0113508
((1)*z )*z
1]
num',den'
[num;den]
[num den]
r=num./den
r'
//
digits='abcdefghijklmnopqrstuvwxyz'
numbers='1234567890'
majuscules='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
symbols=',./;''[] \ =-!\$%^&*()_+~:""[]| @'
[numbers;digits]
[numbers digits;digits numbers]
[numbers digits+digits+digits]
ans';
[ans ans]
