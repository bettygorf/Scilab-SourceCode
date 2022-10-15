function scicos_learn(fil)
funcprot(0);
comm='/'+'/'
x_mdia=funptr('x_mdialog')
c_cho=funptr('x_choose')
xcli=funptr('xclick')
xgetm=funptr('xgetmouse')

clearfun('xclick');newfun('xclick1',xcli);
deff('[c_i,c_x,c_y,c_w]=xclick()',[
    '[lhs,rhs]=argn(0)'
    'if lhs==3 then '
    '  [c_i,c_x,c_y]=xclick1()'
    '  write(uapp,strcat(string([c_i,c_x,c_y]),'','')+comm+''xclick'')'
    'else'
    '  [c_i,c_x,c_y,c_w]=xclick1()'
    '  write(uapp,strcat(string([c_i,c_x,c_y,c_w]),'','')+comm+''xclick'')'
    'end']);

clearfun('xgetmouse');newfun('xgetmouse1',xgetm)
deff('rep=xgetmouse()',[
    'rep=xgetmouse1()'
    'write(uapp,strcat(string(rep),'','')+comm+''xgemouse'')']);


deff('result=dialog(labels,valueini)',[
    'result=x_dialog(labels,valueini)'
    'res=result'
    'res(1)=res(1)+comm+''x_dialog'''
    'write(uapp,res)'])

deff('num=message(strings ,buttons)',[
'[lhs,rhs]=argn(0)'
'if rhs==2 then'
'  num=x_message(strings ,buttons)'
'  write(uapp,buttons(num)+comm+ ''message'')'
'else'
'  num=1'
'  x_message(strings)'
'end'])

clearfun('x_mdialog');newfun('x_mdialog1',x_mdia);
deff('result=x_mdialog(title,labels,default_inputs_vector)',[
    'result=x_mdialog1(title,labels,default_inputs_vector)'
    'if result<>[] then'
    '  res=result'
    '  res(1)=res(1)+comm+''x_mdialog'''
    '  write(uapp,res)'
    '  write(uapp,''o'')'
    'else'
    '  write(uapp,default_inputs_vector)'
    '  write(uapp,''c'')'
    'end'])

clearfun('x_choose');newfun('x_choose1',c_cho);
deff('num=x_choose(items,title,button)',[
    '[lhs,rhs]=argn(0)'
    'if rhs==3 then '
    '  num=x_choose1(items,title,button)'
    'else'
    '  num=x_choose1(items,title)'
    'end'
    'write(uapp,string(num)+comm+''x_choose'')'])

getf('SCI/macros/util/getvalue.sci');
getf('SCI/macros/xdess/getmenu.sci');
deff('[m,pt,btn]=getmenu(datas,pt)',[
'[lhs,rhs]=argn(0)'
'n=size(datas,1)-3'
'if rhs<2 then'
'  [btn,xc,yc]=xclick()'
'  pt=[xc,yc] '
'else'
'  xc=pt(1);yc=pt(2)'
'end'
'test1=datas(1:n,:)-ones(n,1)*[xc xc yc yc]'
'm=find(test1(:,1).*test1(:,2)<0&test1(:,3).*test1(:,4)<0 )'
'if m==[],m=0,end';
'write(uapp,string(m)+comm+''getmenu'')'])

names=['choosefile';
'do_addnew';
'do_block';
'do_color';
'do_copy';
'do_copy_region';
'do_delete';
'do_delete_region';
'do_help';
'do_move';
'do_palettes';
'do_replace';
'do_run';
'do_tild';
'do_view';
'getlink';
'move';
'prt_align';
'scicos']
for k=1:size(names,'r')
  getf('SCI/macros/scicos/'+names(k)+'.sci');
end

deff('c=getcolor(title,cini)',[
'colors=string(1:xget(""lastpattern""))'
'm=prod(size(cini))'
'll=list()'
'm=prod(size(cini))'
'for k=1:m'
'  ll(k)=list(''colors'',cini(k),colors);'
'end'
'c=x_choices(title,ll);'
'write(uapp,string(c)+comm+''getcolor'')'])
uapp=file('open',fil,'unknown');
lines(0);
scicos();
file('close',uapp);
newfun('x_mdialog',x_mdia)
newfun('x_choose',c_cho)
newfun('xclick',xcli)
newfun('xgetmouse',xgetm)


