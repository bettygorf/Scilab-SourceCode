function [x_gc]=savegc()
// save the current graphic context
// and the curent scale ( xsetech)
vals=["alufunction";"clipping";"dashes";"font";
	"line mode";"mark";"pattern";"thickness";"wdim";"wpos";"window"];
x_gc=list();
for i=1:prod(size(vals)),xs=xget(vals(i));
	x_gc(i)=list(vals(i),xs);end
//end

function restgc(x_gc)
// restore the current graphic context
for x=x_gc,xx=x(2);select size(x(2)),
	case 1 then xset(x(1),x(2));
	case 2 then xset(x(1),xx(1),xx(2));
	case 3 then xset(x(1),xx(1),xx(2),xx(3));
	case 4 then xset(x(1),xx(1),xx(2),xx(3),xx(4));
	case 5 then xset(x(1),xx(1),xx(2),xx(3),xx(4),xx(5));
end
end
