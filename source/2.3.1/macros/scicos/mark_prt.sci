function o=mark_prt(o,prt_number,inout,typ,v)
//mark a port of a block free or used
// o           : block data structure
// prt_number  : port number
// inout       : port orientation ('in' or 'out')
// typ         : port type
//               1  : standard port
//              -1  : event port
// v           : value to assign
//               k>0 : port is connected to link #k
//               0 : port is free


graphics=o(2),
if inout='out' then //set an output port
  if typ==1 then  //standard port
    o(2)(6)(prt_number)=v;
//    op=graphics(6);op(prt_number)=v;graphics(6)=op;
else //clock port
  o(2)(8)(prt_number)=v;
//    cop=graphics(8);cop(prt_number)=v;graphics(8)=cop;
  end
else //set an input port
  if typ==1 then  //standard port
    o(2)(5)(prt_number)=v;
    //    ip=graphics(5);ip(prt_number)=v;graphics(5)=ip;
  else //clock port
    o(2)(7)(prt_number)=v;
    //    cip=graphics(7);cip(prt_number)=v;graphics(7)=cip;
  end
end
//o(2)=graphics


