//[nwrk]=freewrk(nwrk,name)
//cette macro libere la place occuppe par la variable dont le nom est
//donne dans names
//!
//  write(6,'-----------------'+name);pause
  if part(name,1:7)=='work(iw' then
     ext=part(name,8:length(name)-1)
     if isnum(ext) then
       nb=evstr(ext)
       nw2=nwrk(2);
       nw2(2,nb)='0'
//     write(6,'libere :'+nw2(1,nb))
       nwrk(2)=nw2
     end
  elseif part(name,1:9)=='iwork(iiw' then
     ext=part(name,10:length(name)-1)
     if isnum(ext) then
       nb=evstr(ext)
       nw5=nwrk(5)
       nw5(2,nb)='0'
       nwrk(5)=nw5
     end
  end
 
//end


