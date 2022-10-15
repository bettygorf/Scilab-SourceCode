function [model,graphics,ok]=check_io(model,graphics,nin,nout,nclkin,nclkout)
// check_io first check if given number of ports agree with block connection 
// and then changes block structure 
//%parameters
// model   : initial and resulting block model structure
// graphics: initial and resulting block graphics structure
// nin     : desired number of inputs
// nout    : desired number of outputs
// nclkin  : desired number of clock inputs
// nclkout : desired number of clock outputs
// ok      : error flag
//           ok==-1 : some of input parameters are incorrects
//           ok==-2 : attempt to add/delete ports when some are connected
//           ok==1  : changes of block structure has been performed
//!
if nin<0|nout<0|nclkin<0|nclkout<0 then
  x_message('number of port can''t  be negative')
  ok=%f
  return
end
[label,ip1,op1,cip1,cop1]=graphics(4:8)
[nin1,nout1,nclkin1,nclkout1]=model(2:5)
//Check inputs
wasconnected=%f
if ip1<>[] then if find(ip1>0)<>[] then wasconnected=%t, end, end,
if wasconnected&nin<>nin1 then
  x_message(['It is not yet possible to add or delete inputs'
	       'when some of them are connected'])
  ok=%f
  return
end
if nin>nin1 then
    ip1(nin)=0
elseif nin<nin1 then
    ip1=ip1(1:nin)
end
//Check outputs
wasconnected=%f
if op1<>[] then if find(op1>0)<>[] then wasconnected=%t, end, end,
if wasconnected&nout<>nout1 then
  x_message(['It is not yet possible to add or delete outputs'
	       'when some of them are connected'])
  ok=%f
  return
end
if nout>nout1 then
    op1(nout)=0
elseif nout<nout1 then
    op1=op1(1:nout)
end
//Check clock inputs
wasconnected=%f
if cip1<>[] then if find(cip1>0)<>[] then wasconnected=%t, end, end,
if wasconnected&nclkin<>nclkin1 then
  x_message(['It is not yet possible to add or delete clock inputs'
	       'when some of them are connected'])
  ok=%f
  return
end
if nclkin>nclkin1 then
    cip1(nclkin)=0
elseif nclkin<nclkin1 then
    cip1=cip1(1:nclkin)
end
//Check clock outputs
wasconnected=%f
if cop1<>[] then if find(cop1>0)<>[] then wasconnected=%t, end, end,
if wasconnected&nclkout<>nclkout1 then
  x_message(['It is not yet possible to add or delete clock outputs'
	       'when some of them are connected'])
  ok=%f
  return
end
if nclkout>nclkout1 then
    cop1(nclkout)=0
elseif nclkout<nclkout1 then
    cop1=cop1(1:nclkout)
end
ok=%t
graphics(5)=ip1
graphics(6)=op1
graphics(7)=cip1
graphics(8)=cop1
model(2)=nin
model(3)=nout
model(4)=nclkin
model(5)=nclkout

