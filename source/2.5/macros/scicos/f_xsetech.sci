function f_xsetech(wsiz)
if MODE_X then
  WIDTH=3*wsiz(5);HIGHT=3*wsiz(6);
  XSHIFT=wsiz(5);YSHIFT=wsiz(6);
  
  xsetech([-1 -1 8 8]/6,[wsiz(3)-XSHIFT,wsiz(4)-YSHIFT,..
      wsiz(3)-XSHIFT+WIDTH,..
      wsiz(4)-YSHIFT+HIGHT])
else
  xsetech([-1 -1 8 8]/6,[wsiz(3),wsiz(4),wsiz(3)+wsiz(5),wsiz(4)+wsiz(6)])
end
