function rep=x_message(comment,btns)
rep=0

function str=x_dialog(comment,default)
str=default

function str=x_mdialog(varargin)
rhs=size(varargin)
if rhs==2 then 
  str(size(varargin(2),'*'))=' ',
else 
  str=varargin($);
end

function num=x_choose(tochoose,comment,button)
num=1


function []=ExecAppli(varargin)
// empty

function []=CreateLink(varargin)
// empty

function  rep=x_choices(title,items)
rep=ones(1,size(items))


function addmenu(varargin)
// empty
function delmenu(varargin)
// empty
function unsetmenu(varargin)
// empty
function setmenu(varargin)
// empty

