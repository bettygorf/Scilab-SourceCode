function [x,y,typ]=TEXT_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position 
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);ipar=model(9);
  if ipar==[] then
    font=0,siz=1
  else
    font=ipar(1);siz=ipar(2)
  end
  oldfont=xget('font');  xset('font',font,siz)
  xstring(orig(1),orig(2),label)
  xset('font',oldfont(1),oldfont(2))
case 'getinputs' then
case 'getoutputs' then
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);[orig,sz,label]=graphics([1:2 4])
  model=arg1(3)
  ipar=model(9)
  if ipar==[] then
    font=0,siz=1
  else
    font=ipar(1);siz=ipar(2)
  end
  while %t do
    [ok,label,font,siz]=getvalue('Set Text block parameters',..
	['Text';'Font number';'Font size'],list('str',-1,'vec',1,'vec',1),..
	[label;string(font);string(siz)])
    if ~ok then break,end
    if font<=0|font>6 then
      x_message('Font number must be greater than 0 and less than 7')
      ok=%f
    end
    if siz<0 then
      x_message('Font size must be positive')
      ok=%f
    end
    if ok then
      graphics(4)=label
      oldfont=xget('font')
      xset('font',font,siz)
      r=xstringl(orig(1),orig(2),label)
      xset('font',oldfont(1),oldfont(2))
      sz=r(3:4)
      graphics(2)=sz
      x(2)=graphics;
      ipar=[font;siz]
      model(9)=ipar;
      x(3)=model
      break
    end
  end
case 'define' then
  ipar=[0;1]
  model=list('text',0,0,0,0,[],[],[],ipar,'c',%f,[%f %f])
  graphics=list([0,0],[2 1],%t,'Text',[],[],[],[])
  x=list('Text',graphics,model,' ','TEXT_f')
end
