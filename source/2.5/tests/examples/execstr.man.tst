clear;lines(0);
execstr('a=1') // sets a=1.
execstr('1+1') // does nothing (while evstr('1+1') returns 2)

execstr(['if %t then';
         '  a=1';
         '  b=a+1';
         'else'
         ' b=0'
         'end'])

execstr('a=zzzzzzz','errcatch')
