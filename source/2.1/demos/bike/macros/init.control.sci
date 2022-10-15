path=sci+'/demos/bike/'

// compile if necessary 

xhost("cd "+path+"; make control");

// link if necessary 

deff('[]=linkif(fname)','if ~c_link(fname),link(''/tmp/''+fname+''.o'',
	fname)');


linkif('vecfin');
linkif('hamu');
linkif('emat');
linkif('fvec');
linkif('c');
linkif('psi');
linkif('ii');
linkif('h');

// Macros made by Maple
getf(path+'vecfin.sci','c');
getf(path+'hamu.sci','c');
getf(path+'emat.sci','c');
getf(path+'fvec.sci','c');
getf(path+'c.sci','c');
getf(path+'psi.sci','c');
getf(path+'efs.sci','c');

ematww=read(path+'ematww.dat',318,2,"(e24.18)");

