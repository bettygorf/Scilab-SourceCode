function [sd]=gr_menu(sd,flag,noframe)
// Copyright INRIA
getf('SCI/macros/xdess/gr_macros.sci','c');

deff('[modek]=clearmode()',['modek=xget(''alufunction'')';
            'xset(''alufunction'',6);']);
  
deff('[]=modeback(x)','xset(''alufunction'',x);');

[l,mac]=where();scsmode=find(mac=='scicos')<>[]
alu=xget('alufunction')
if scsmode then xset('alufunction',6),end

dash=['0        continue';
      '1        {2,5,2,5}';
      '2        {5,2,5,2}';
      '3        {5,3,2,3}';
      '4        {8,3,2,3}';
      '5        {11,3,2,3}'; 
      '6        {11,3,5,3}}'];

[lhs,rhs]=argn(0);
if rhs<=1,flag=0;end;
if rhs<=2,noframe=0;end;
if rhs <=0 then
  cdef=[0 0 100 100];init=1
else
  select type(sd)
  case 1 then 
    cdef=sd;init=1
  case 15 then
    if sd(1)<>'sd' then
      error('l''entree n''est pas une liste de type sd'),
    end
    cdef=sd(2);init=0
  else 
    error('incorrect input:'+...
	'[xmin,ymin,xmax,ymax] ou list(''sd'',,,)')
  end
end
if noframe==1;s_t="010";else s_t="012";end
plot2d(0,0,[1],s_t,' ',cdef);
curwin=xget('window')
xclip('clipgrf')

menu_o=['rectangle','frectangle','circle','fcircle','polyline',...
	'fpolyline','spline','arrow','points','caption']
menu_s=['dash style','pattern','thickness','mark','clip off','clip on']
menu_e=['redraw','pause','delete','move','Exit']
menus=list(['Objects','Settings','Edit'],menu_o,menu_s,menu_e)
w='menus(2)(';rpar=')'
Objects=w(ones(menu_o))+string(1:size(menu_o,'*'))+rpar(ones(menu_o))
w='menus(3)(';rpar=')'
Settings=w(ones(menu_s))+string(1:size(menu_s,'*'))+rpar(ones(menu_s))
w='menus(4)(';rpar=')'
Edit=w(ones(menu_e))+string(1:size(menu_e,'*'))+rpar(ones(menu_e))
execstr('Edit_'+string(curwin)+'=Edit')
execstr('Settings_'+string(curwin)+'=Settings')
execstr('Objects_'+string(curwin)+'=Objects')
menubar(curwin,menus)

if init==0 then redraw(sd,s_t); else sd=list('sd',cdef); end,
//
if flag==1; xclip();return ;end

// boucle principale
Cmenu1=[]
while %t then
  ksd=prod(size(sd))
  [btn,xc,yc,win,Cmenu]=getclick()
  c1=[xc,yc]
  select Cmenu
  case 'Exit' then
    fin='ok'
    xset('alufunction',alu)
    break
  case 'rectangle'  then 
    xinfo('rectangle '); 
    new=rect();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'frectangle'  then 
    xinfo('filled rectangle '); 
    new=frect();  
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'circle'     then 
    xinfo(['circle : center point,';...
	    ' point on the circle']); 
    new=cerc();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'fcircle'     then 
    xinfo(['filles circle : center point,';...
	    ' point on the circle']); 
    new=fcerc();  
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'polyline'   then 
    xinfo(['line : left-click to stop,';...
	    ' right or middle to add a point']);  
    new=ligne();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'fpolyline'   then 
    xinfo(['fline : left-click to stop,';...
	    ' right or middle to add a point']); 
    new=fligne();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'spline'     then 
    xinfo(['splin [xi increasing]:left-click to stop,';...
	    ' right or middle to add a point ']);   
    new=curve();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'arrow'      then
    xinfo('arrow : begining point, ending point');
    new=fleche();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'points'     then 
    xinfo(['points: left-click to stop,';
      ' right or middle to add a point']);
    new=points();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'caption'    then 
    xinfo('leg');    
    new=comment();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'dash style' then 
    xinfo('dash');    
    new=dashs()
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'pattern'    then 
    xinfo('pattern'); 
    new=patts();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'thickness'    then 
    xinfo('thickness'); 
    new=Thick();
    if new<>list() then
      sd(ksd+1)=new
    end    
  case 'mark'       then 
    xinfo('symbols'); 
    new=symbs();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'redraw'     then 
    xset("default");
    redraw(sd,s_t);
  case 'pause'      then 
    pause;
  case 'delete'     then 
    delete(sd);
  case 'move'     then 
    sd=move(sd);  
  case 'clip off'   then 
    new=grclipoff();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'clip on'    then 
    new=grclipon();
    if new<>list() then
      sd(ksd+1)=new
    end
  case 'group' then
    sd=sdgroup(sd)
  end  // fin select 
end, // fin while
xset("default");
