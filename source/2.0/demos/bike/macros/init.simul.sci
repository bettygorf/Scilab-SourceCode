path=sci+'/demos/bike/'

// compile if necessary 

host("cd "+path+"; make simul");

// link if necessary 

deff('[]=linkif(fname)',['if ~c_link(fname) then';
             'link(''/tmp/''+fname+''.o'',fname);end']);

linkif('gjx');
linkif('constr');
linkif('ii');
linkif('h');

// Macros made by Maple
getf(path+'src/'+'gjx.sci','c');
getf(path+'src/'+'constr.sci','c');
getf(path+'src/'+'ii.sci','c');
getf(path+'src/'+'h.sci','c');
getf(path+'src/'+'iihs.sci','c');

// Other macros

getf(path+'macros/'+'show.sci','c');
getf(path+'macros/'+'macros.sci','c');
getf(path+'macros/'+'qinit.sci','c')
iiww=read(path+'data/'+'iiww.dat',222,2,"(e24.18)");
getf(path+'macros/'+'simulation.sci','c');
getf(path+'macros/'+'bike.sci','c');
exec(path+'macros/'+'param.sci');
getf(path+'macros/'+'velo1.sci','c');
getf(path+'macros/'+'velo2.sci','c');
getf(path+'macros/'+'velo3.sci','c');
getf(path+'macros/'+'velo4.sci','c');
