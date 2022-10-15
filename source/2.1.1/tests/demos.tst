//to Check all the demos
clearfun('x_message')
clearfun('x_dialog')
clearfun('x_mdialog')
clearfun('x_choose')
clearfun('mode')
deff('[]=mode(x)','x=x')
deff('[]=halt()',' ')
getf('SCI/tests/dialogs.sci','c')
I=file('open','SCI/tests/demos.dialogs','old')
O=file('open','/dev/null','old')
%IO=[I,O]
lines(0)
getf('SCI/macros/util/getvalue.sci')
exec('SCI/demos/alldems.dem')
file('close',I)
file('close',O)

