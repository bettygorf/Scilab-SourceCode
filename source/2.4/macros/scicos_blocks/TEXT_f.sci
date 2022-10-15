function [x,y,typ]=TEXT_f(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position
  graphics=arg1(2); 
  model=arg1(3);
  if model(8)==[] then model(8)=graphics(4)(1),end //compatibility
  oldfont=xget('font');  xset('font',model(9)(1),model(9)(2))
  xstring(graphics(1)(1),graphics(1)(2),model(8))
  xset('font',oldfont(1),oldfont(2))
case 'getinputs' then
case 'getoutputs' then
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);[orig,label]=graphics([1 4])
  model=arg1(3)
  while %t do
    [ok,txt,font,siz,label]=getvalue('Set Text block parameters',..
	['Text';'Font number';'Font size'],list('str',-1,'vec',1,'vec',1),label)
    if ~ok then break,end
    if font<=0|font>6 then
      message('Font number must be greater than 0 and less than 7')
      ok=%f
    end
    if siz<0 then
      message('Font size must be positive')
      ok=%f
    end
    if ok then
      graphics(4)=label
      oldfont=xget('font')
      xset('font',font,siz)
      r=xstringl(orig(1),orig(2),label(1))
      xset('font',oldfont(1),oldfont(2))
      sz=r(3:4)
      graphics(2)=sz
      x(2)=graphics;
      ipar=[font;siz]
      model(8)=txt
      model(9)=ipar;
      model(11)=[]//compatibility
      x(3)=model
      break
    end
  end
case 'define' then
  font=2
  siz=1
  model=list('text',[],[],[],[],[],[],'Text',[font;siz],'c',[],[%f %f],' ',list())
  label=['Text';string(font);string(siz)]
  graphics=list([0,0],[2 1],%t,label,[],[],[],[],[])
  x=list('Text',graphics,model,' ','TEXT_f')
end




