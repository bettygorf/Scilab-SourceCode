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
getf(path+'gjx.sci','c');
getf(path+'constr.sci','c');
getf(path+'ii.sci','c');
getf(path+'h.sci','c');
getf(path+'iihs.sci','c');

// Other macros

getf(path+'show.sci','c');
getf(path+'macros.sci','c');
getf(path+'qinit.sci','c')
iiww=read(path+'iiww.dat',222,2,"(e24.18)");
getf(path+'simulation.sci','c');
getf(path+'bike.sci','c');
exec(path+'param.sci');
getf(path+'velo1.sci','c');
getf(path+'velo2.sci','c');
getf(path+'velo3.sci','c');
getf(path+'velo4.sci','c');
