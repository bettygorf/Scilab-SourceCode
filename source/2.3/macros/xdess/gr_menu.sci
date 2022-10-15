function [sd]=gr_menu(sd,flag,noframe)

getf('SCI/macros/xdess/gr_macros.sci','c');

deff('[modek]=clearmode()',['modek=xget(''alufunction'')';
            'xset(''alufunction'',6);']);
  
deff('[]=modeback(x)','xset(''alufunction'',x);');

symbtb=['1  +';
        '2  x';
        '3  + circle ';
        '4  full diamond';
        '5  empty diamond';
        '6  triangle (up)';
        '7  triangle (down)';
        '8  clubs';
        '9  circle'];

dash=['0        continue';
      '1        {2,5,2,5}';
      '2        {5,2,5,2}';
      '3        {5,3,2,3}';
      '4        {8,3,2,3}';
      '5        {11,3,2,3}'; 
      '6        {11,3,5,3}}'];

patt=['0  black';
    '1  navyblue';
    '2  blue';
    '3  skyblue';
    '4  aquamarine';
    '5  forestgreen';
    '6  green';
    '7  lightcyan';
    '8  cyan';
    '9  orange';
    '10  red';
    '11  magenta';
    '12  violet';
    '13  yellow';
    '14  gold';
    '15  beige';
    '16  white'];

[lhs,rhs]=argn(0);
if rhs<=1,flag=0;end;
if rhs<=2,noframe=0;end;
if rhs <=0 then
     cdef=[0 0 100 100];init=1
           else
     select type(sd)
       case 1 then cdef=sd;init=1
       case 15 then
            if sd(1)<>'sd' then
               error('l''entree n''est pas une liste de type sd'),
            end
            cdef=sd(2);init=0
       else error('incorrect input:'+...
                   '[xmin,ymin,xmax,ymax] ou list(''sd'',,,)')
     end
end
if noframe=1;s_t="010";else s_t="012";end
plot2d(0,0,[1],s_t,' ',cdef);
xclip('clipgrf')
//
// Trace des bouttons
   tmenu=['rectangle','circle','polyline','fpolyline',...
	  'spline','arrow',...
          'points','caption',...
          'dash style','pattern','mark','redraw','pause','delete',...
	  'clip off','clip on','exit']
//
if init=0 then redraw(sd,s_t); else sd=list('sd',cdef); end,
//
if flag=1; xclip();return ;end
fin='no';
// boucle principale
while fin<>'ok' then
 ksd=prod(size(sd))
 //
 x=x_choose(tmenu','Choose an option below (click)');
 if x<>0 then
 select tmenu(x)
   case 'rectangle'  then xinfo('rectangle '); sd(ksd+1)=rect();
   case 'circle'     then xinfo(['circle : center point,';...
                                 ' point on the circle']); sd(ksd+1)=cerc();
   case 'polyline'   then xinfo(['line : left-click to stop,';...
                                ' right or middle to add a point']);  sd(ksd+1)=ligne();
   case 'fpolyline'   then xinfo(['fline : left-click to stop,';...
                                ' right or middle to add a point']); sd(ksd+1)=fligne();
   case 'spline'     then xinfo(['splin [xi increasing]:left-click to stop,';...
                                ' right or middle to add a point ']);   sd(ksd+1)=curve();
   case 'arrow'      then xinfo('arrow : begining point, ending point');
                          sd(ksd+1)=fleche();
   case 'points'     then xinfo(['points: left-click to stop,';...
                                ' right or middle to add a point']);
                          sd(ksd+1)=points();
   case 'caption'    then xinfo('leg');    sd(ksd+1)=comment();
   case 'dash style' then xinfo('dash');    sd(ksd+1)=dashs()
   case 'pattern'    then xinfo('pattern'); sd(ksd+1)=patts();
   case 'mark'       then xinfo('symbols'); sd(ksd+1)=symbs();
   case 'redraw'     then redraw(sd,s_t);
   case 'pause'      then pause;
   case 'delete'     then delete(sd);
   case 'clip off'   then sd(ksd+1)=grclipoff();
   case 'clip on'    then sd(ksd+1)=grclipon();
   case 'exit' then fin='ok',
//
end, // fin select x
end,
end, // fin while
xset("default");
