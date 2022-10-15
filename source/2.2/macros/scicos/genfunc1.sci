function [ok,tt,dep_ut]=genfunc1(tt,ni,no,nci,nco,nx,nz,nrp)
mac=[];ok=%f,dep_ut=[]
[txt1,txt2,txt3]=tt(1:3)
dep_u=%f;dep_t=%f
depp='t';deqq='t';
if ni>0 then depp=depp+',u',deqq=deqq+',u',end
if nx>0 then depp=depp+',x',deqq=deqq+',x',end 
if nz>0 then depp=depp+',z',deqq=deqq+',z',end 
if nci>0 then depp=depp+',n_evi',end 
if nrp>0 then depp=depp+',rpar',deqq=deqq+',rpar',end 

if no>0 then
  while %t do
    txt1=x_dialog(['Define output function';
	' '
	'Enter Scilab instructions defining'
	'y (size:'+string(no)+') as a function of '+deqq],txt1)
    if txt1==[] then return,end	  
       
    // check if txt defines y from u  
    mac=null();deff('[]=mac()',txt1)
    ok1=check_mac(mac)
    if ok1 then
      vars=macrovar(mac)
      if or(vars(3)=='u') then dep_u=%t,end
      if or(vars(3)=='t') then dep_t=%t,end
      if or(vars(5)=='y') then 
	break,
      else
	x_message('You did not define y!')
      end     
    end
  end
else
  txt1= ' '
end

if nx>0 then 
  t1='derivative of continuous state xd (size:'+string(nx)+')'
else 
  t1=[],
end

if nz>0 then 
  t2='next discrete state zp (size:'+string(nz)+')',
else 
  t2=[],
end

if nx>0|nz>0 then
  while %t do
    txt2=x_dialog(['Define states evolution';
	' '
	'Enter Scilab instructions defining:';
	t1;
	t2;
	'as  function(s) of '+depp],txt2)
    if txt2==[] then return,end	
    txt22=txt2
    if nx=0 then txt22=[txt22;'xd=[]'],end
    if nz=0 then txt22=[txt22;'zp=[]'],end
    mac=null();deff('[]=mac()',txt22)
    ok1=check_mac(mac)	
    if ok1 then
      vars=macrovar(mac)
      if or(vars(5)=='xd')&or(vars(5)=='zp') then 
	break,
      else
	tw=[]
	if nx>0 then tw='xd',end
	if nz>0 then tw=[tw 'zp'],end
	x_message('You did not define '+strcat(tw,' or ')+'!')
      end  
    end
  end
else
  txt2=' '
  txt22=[]
end

if nco>0 then
  while %t do
    txt3=x_dialog(['Define output events';
	' '
	'Enter Scilab instructions defining'
	'the vector t_evo (size:'+string(nco)+') containing the times'
	'of output events as a function of '+depp],txt3)

    if txt3==[] then return,end	
    mac=null();deff('[]=mac()',txt3)
    ok1=check_mac(mac)	
    if ok1 then
      vars=macrovar(mac)
    end
    if ok1 then
      if or(vars(5)=='t_evo') then 
	break,
      else
	x_message('You did not define t_evo!')
      end 
    end
  end
else
  txt3=' '
end

ok=%t
tt=list(txt1,txt22,txt3)

dep_ut=[dep_u dep_t]

function ok=check_mac(mac)
ok=%t,return
//errcatch doesnt work poperly
errcatch(-1,'kill')
comp(mac)
errcatch(-1)
if iserror(-1)==1 then
  errclear(-1)
  x_message('Incorrect syntax: see message in Scilab window')
  ok1=%f
end
