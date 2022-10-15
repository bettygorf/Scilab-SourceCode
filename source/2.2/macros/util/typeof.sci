function [tf]=typeof(object)
select type(object)
case 1 then tf='usual';
case 2 then tf='polynomial';
case 4 then tf='boolean';
case 5 then tf='sparse';
case 6 then tf='boolean sparse';
case 10 then tf='character';
case 11 then tf='macro';
case 13 then tf='macro';
case 14 then tf='library';
case 128 then tf='pointer';
case 15 then tf='list'
case 16 then
    select object(1)
        case 'r' then tf='rational';
        case 'lss' then tf='state-space'
        case 'sp' then tf='tlist'
                  else tf='tlist';
    end
end
