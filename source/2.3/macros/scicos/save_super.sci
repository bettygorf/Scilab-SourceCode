function save_super(scs_m)
// given a super block definition x save_super creates a file which contains
// this super block  handling  macro definition
x1=scs_m(1);nam=x1(2);
nin=0;nout=0;clkin=0;clkout=0;




in=[];out=[];clkin=[];clkout=[];
for k=2:size(scs_m)
  o=scs_m(k)
  if o(1)=='Block' then
    model=o(2)
    select o(5)
    case 'IN_f' then
      in=[in;model(3)]
    case 'OUT_f' then
      out=[out;model(2)]
    case 'CLKIN_f' then
      clkin=[clkin;model(5)]
    case 'CLKOUT_f' then
      clkout=[clkout;model(4)];
    end
  end
end
model=list('super',in,out,clkin,clkout,[],[],..
      x,[],'h',%f,[%f %f])
txt=[
'function [x,y,typ]='+nam+'(job,arg1,arg2)';
'x=[];y=[],typ=[]';
'select job';
'case ''plot'' then';
'  standard_draw(arg1)';
'  graphics=arg1(2); [orig,sz]=graphics(1:2)';
'  thick=xget(''thickness'');xset(''thickness'',2)';
'  xx=orig(1)+      [2 4 4]*(sz(1)/7)';
'  yy=orig(2)+sz(2)-[2 2 6]*(sz(2)/10)';
'  xrects([xx;yy;[sz(1)/7;sz(2)/5]*ones(1,3)])';
'  xx=orig(1)+      [1 2 3 4 5 6 3.5 3.5 3.5 4 5 5.5 5.5 5.5]*sz(1)/7';
'  yy=orig(2)+sz(2)-[3 3 3 3 3 3 3   7   7   7 7 7   7   3  ]*sz(2)/10';
'  xsegs(xx,yy,1)   ';
'  xset(''thickness'',thick)';
'case ''getinputs'' then';
'  [x,y,typ]=standard_inputs(arg1)';
'case ''getoutputs'' then';
'  [x,y,typ]=standard_outputs(arg1)';
'case ''getorigin'' then';
'  [x,y]=standard_origin(arg1)';
'case ''set'' then';
'  graphics=arg1(2);label=graphics(4)';
'  model=arg1(3);';
'  x=model(8)';
'  while %t do';
'    [x,newparameters,needcompile]=scicos(model(8))';
'    in=[];out=[];clkin=[];clkout=[];';
'    for k=2:size(x)';
'      o=x(k)';
'      if o(1)==''Block'' then';
'        modelb=o(3);'
'        select o(5)';
'        case ''IN_f'' then';
'          in=[in;modelb(3)];';
'        case ''OUT_f'' then';
'          out=[out;modelb(2)];';
'        case ''CLKIN_f'' then';
'          clkin=[clkin;modelb(5)];';
'        case ''CLKOUT_f'' then';
'          clkout=[clkout;modelb(4)];';
'        end';
'      end';
'    end';
'    [model,graphics,ok]=check_io(model,graphics,in,out,clkin,clkout)';
'    if ok then';
'      model(8)=x';
'      x=arg1;x(3)=model;x(2)=graphics;';
'      y=needcompile';
'      typ=newparameters';
'      break';
'    end';
'  end';
'case ''define'' then']


t1=sci2exp(model,'model');
bl='  '
txt=[
   txt;
   bl(ones(size(t1,1),1))+t1;
'  x=standard_define([2 2],model,'''+nam+''',[])';
'end']
u=file('open',nam+'.sci','unknown')
write(u,txt,'(a)')
file('close',u)




