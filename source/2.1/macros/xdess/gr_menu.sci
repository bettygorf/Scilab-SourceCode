function [sd]=gr_menu(sd,flag,noframe)
deff('[modek]=clearmode()',['modek=xget(''alufunction'')';
            'xset(''alufunction'',6);']);
  
deff('[]=modeback(x)','xset(''alufunction'',x);');

deff('[]=symbs(n)',["n1=x_choose(symbtb,''Choose a mark'');";
            "dime=evstr(x_dialog(''Choose a size'',''0''))";
            "xset('"mark"',n1,dime)"]);

deff('[]=dashs(n)',['n1=x_choose(dash,''Choose a dash style'');";
            "xset('"dashes"',n1-1);']);

deff('[]=patts(n)',['n1=x_choose(patt,[''Choose a pattern '']);';
            "xset('"pattern"',n1);']);
 
deff('[]=xshow(str)',['[n1,n2]=size(str);';
         'rect=xstringl(cdef(1),cdef(2)+cdef(3)+cdef(3)/16,str);';
         'xclea(rect(1),rect(2),200,rect(4));';
         'xstring(cdef(1),cdef(2)+cdef(3)+cdef(3)/16,str);']);

deff('[sd1]=rect(sd,del)',['[lhs,rhs]=argn(0);sd1=[];';
                        'if rhs<=0 then ';
                        '[i,x1,y1]=xclick();[i,x2,y2]=xclick();';
                        'sd1=list(''rect'',x1,x2,y1,y2);';
                        'else';
                        'if rhs=2 then mm=clearmode();end';
                        'x1=sd(2);x2=sd(3),y1=sd(4),y2=sd(5);';
                        'end';
                        'xrect(x1,y2,abs(x2-x1),abs(y2-y1));';
                        'if rhs=2 then modeback(x);end;']);


 
deff('[sd1]=cerc(sd,del)',['[lhs,rhs]=argn(0);sd1=[];';
                        'if rhs<=0 then ';
                        '[i,c1,c2]=xclick();[i,x1,x2]=xclick();';
                        'x=[x1;x2],c=[c1;c2];r=norm(x-c,2);';
                        'sd1=list(''cercle'',c,r);';
                        'else';
                        'if rhs=2 then mm=clearmode();end;';
                        'c=sd(2);r=sd(3);';
                        'end;';
                        'xarc(c(1)-r,c(2)+r,2*r,2*r,0,64*360);';
                        'if rhs=2, modeback(x);end;']);
 
deff('[sd1]=fleche(sd,del)',['[lhs,rhs]=argn(0);sd1=[]';
                        'if rhs<=0 then,';
                        '[i,oi1,oi2]=xclick();';
                        '[i,of1,of2]=xclick();';
                        'o1=[oi1;of1],o2=[oi2;of2];';
                        'sd1=list(''fleche'',o1,o2);';
                        'else';
                        'if rhs=2 then mm=clearmode();end;';
                        'o1=sd(2),o2=sd(3),';
                        'end';
                        'xarrows(o1,o2);';
                        'if rhs=2, modeback(x);end;']);
 
deff('[sd1]=comment(sd,del)',['[lhs,rhs]=argn(0),sd1=[];';
                         'if rhs<=0 then ,';
                         '[i,z1,z2]=xclick();z=[z1;z2];';
                         'com=x_dialog(''Enter string'','' '');';
                         'sd1=list(''comm'',z,com)';
                         'else';
                         'if rhs=2 then mm=clearmode();end;';
                         'z=sd(2);com=sd(3);';
                         'end;';
                         'xstring(z(1),z(2),com,0,0);';
                       'if rhs=2, modeback(x);end;']);
 
deff('[sd1]=ligne(sd,del)',['[lhs,rhs]=argn(0);sd1=[];';
                       'if rhs<=0 then ,';
                       'z=locate(-1,1);';
                       'if z=[], return;end;';
                       'xx=xget('"dashes"');';
                       'sd1=list(''ligne'',z,xx);';
                       'else';
                       'if rhs=2 then mm=clearmode();end;';
                       'z=sd(2);xx=sd(3);';
                       'end;';
                       'plot2d(z(1,:)'',z(2,:)'',[-xx(1)-1,1],'"000"');';
                       'if rhs=2, modeback(x);end;']);


deff('[sd1]=fligne(sd,del)',['[lhs,rhs]=argn(0);sd1=[];';
                       'if rhs<=0 then ,';
                       'z=locate(-1,1);';
                       'if z=[], return;end;';
                       'xx=xget('"pattern"');';
                       'sd1=list(''fligne'',z,xx);';
                       'else';
                       'if rhs=2 then mm=clearmode();end;';
                       'z=sd(2);xx=sd(3);';
                       'end;';
                       'xx1=xget('"pattern"');';
                       'xset('"pattern"',xx);';
                       'xfpoly(z(1,:),z(2,:),1);';
                       'xset('"pattern"',xx1);';
                       'if rhs=2, modeback(x);end;']);

deff('[sd1]=curve(sd,del)',['[lhs,rhs]=argn(0);sd1=[];';
                       'if rhs<=0 then ,';
                       'z=locate(-1,1);';
                       'if z=[], return;end';
                       '[x1,k1]=sort(z(1,:));y1=z(2,k1);z=[x1;y1];';
                       '[n1,n2]=size(z);z=smooth(z(:,n2:-1:1));';
                       'xx=xget('"dashes"');';
                       'sd1=list(''ligne'',z,xx);';
                       'else';
                       'if rhs=2 then mm=clearmode();end;';
                       'z=sd(2);xx=sd(3);';
                       'end;';
                       'xx=xget('"dashes"');';
                       'plot2d(z(1,:)'',z(2,:)'',[-xx(1)-1,1],'"000"');';
                       'if rhs=2, modeback(x);end;']);

deff('[sd1]=point(sd,del)',['[lhs,rhs]=argn(0);sd1=[];';
                       'if rhs<=0 then ,';
                       'z=locate(-1,1);';
                       'if z=[], return;end;';
                       'xx=xget('"mark"');';
                       'sd1=list(''point'',z,xx);';
                       'else';
                       'if rhs=2 then mm=clearmode();end;';
                       'z=sd(2);xx=sd(3);';
                       'end;';
                       'plot2d(z(1,:)'',z(2,:)'',[xx(1)+1,1],'"000"');';
                       'if rhs=2, modeback(x);end;']);
 

deff('[]=redraw(sd,s_t)',['ksd=size(sd)';'xset(''default'');';
               'plot2d(0,0,[-1],s_t,'' '',sd(2));';
               'for k=3:ksd,';
                 'obj=sd(k);';
                 'if size(obj)<>0 then';
                    'to=obj(1)';
                    'select to,';
                     'case ''rect''    then rect(obj);';
                     'case ''cercle''  then cerc(obj);';
                     'case ''fleche''  then fleche(obj);';
                     'case ''cercle''  then cerc(obj);';
                     'case ''comm''    then comment(obj);';
                     'case ''ligne''   then ligne(obj);';
                     'case ''fligne''  then fligne(obj);';
                     'case ''point''   then point(obj);';
                    'end';
                 'end';
               'end']);


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
plot2d(0,0,[-1],s_t,' ',cdef);
//
// Trace des bouttons
   tmenu=['rectangle','circle','polyline','fpolyline',...
	  'spline','arrow',...
          'points','caption',...
          'dash style','pattern','mark','redraw','pause','delete','exit']
//
if init=0 then redraw(sd,s_t); else sd=list('sd',cdef); end,
//
if flag=1;return ;end
fin='no';
// boucle principale
while fin<>'ok' then
 ksd=size(sd)
 //
 x=x_choose(tmenu','Choose an option below (click)');
 if x<>0 then
 select tmenu(x)
   case 'rectangle'  then xshow('rectangle : down-left,upper-right');
                          sd(ksd+1)=rect();
   case 'circle'     then xshow(['circle : center point,';...
                                 ' point on the circle']);
                          sd(ksd+1)=cerc();
   case 'polyline'   then xshow(['line : left-click to stop,';...
                                ' right or middle to add a point']);
                          sd(ksd+1)=ligne();
   case 'fpolyline'   then xshow(['fline : left-click to stop,';...
                                ' right or middle to add a point']);
                          sd(ksd+1)=fligne();
   case 'spline'     then xshow(['splin [xi increasing]:left-click to stop,';...
                                ' right or middle to add a point ']);
                          sd(ksd+1)=curve();
   case 'arrow'      then xshow('arrow : begining point, ending point');
//begin point, end point');
                          sd(ksd+1)=fleche();
   case 'points'     then xshow(['points: left-click to stop,';...
                                ' right or middle to add a point']);
                          sd(ksd+1)=point();
   case 'caption'     then xshow('leg');      
                          sd(ksd+1)=comment();
   case 'dash style' then xshow('dash');     dashs(x);
   case 'pattern' then xshow('pattern');     patts(x);
   case 'mark'      then symbs(x);
   case 'redraw'     then xbasc();redraw(sd,s_t);
   case 'pause'      then pause;
   case 'delete' then  //destruction d'un objet
   xx=locate(1);eps=0.2
   //recherche de l'objet contenant le point
   for ko=2:ksd;
     obj=sd(ko);
     to='rien';if size(obj)<>0 then to=obj(1);end,
     select to
     case 'ligne' then
       z=obj(2),[nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=ligne(obj,'del');
         end,
       end,
     case 'fligne' then
       z=obj(2),[nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=fligne(obj,'del');
         end,
       end,
     case 'rect' then
       x1=obj(2);x2=obj(3);y1=obj(4);y2=obj(5);
       z=[x1,x1,x2,x2,x1 ; y1,y2,y2,y1,y1];
       [nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=rect(obj,'del');
         end,
       end,
     case 'points' then
       z=obj(2),[nw,npt]=size(z),
       for kpt=2:npt
         e=norm(xx-z(:,kpt),2)+norm(xx-z(:,kpt-1),2)
         if abs(e-norm(z(:,kpt)-z(:,kpt-1),2))< eps then
           sd(ko)=point(obj,'del');
         end,
       end,
     case 'cercle' then
       dist=norm(obj(2)-xx,2);
       if abs(dist-obj(3))<eps then sd(ko)=cerc(obj,'del');end,
     case 'fleche' then
       o1=obj(2);o2=obj(3);p1=[o1(1);o2(1)];p2=[o1(2);o2(2)];
       e=norm(xx-p1,2)+norm(xx-p2,2)
       if abs(e-norm(p2-p1))< eps then sd(ko)=fleche(obj,'del');end,
     case 'comm' then
       xxr=xstringl(0,0,obj(3))
       hx=xxr(3);
       hy=xxr(4);
       crit=norm(obj(2)-xx)+norm(obj(2)+[hx;hy]-xx)
       if crit<hx+hy then sd(ko)=comment(obj,'del');end
     end, //fin selec to
   end; //fin for ko ...
   
case 'exit' then fin='ok',
//
end, // fin select x
end,
end, // fin while
xset("default");




