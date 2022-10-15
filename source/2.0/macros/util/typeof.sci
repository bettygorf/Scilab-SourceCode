function [tf]=typeof(object)
select type(object)
case 1 then tf='usual';
case 2 then tf='polynomial';
case 4 then tf='boolean';
case 10 then tf='character';
case 11 then tf='macro';
case 13 then tf='macro';
case 14 then tf='library';
case 15 then
    select object(1)
        case 'r' then tf='rational';
        case 'lss' then tf='state-space'
        case 'sp' then tf='sparse'
                  else tf='list';
    end
end
