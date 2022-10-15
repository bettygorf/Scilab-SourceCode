function win=get_new_window(windows)
wfree=find(windows(:,1)==0)
if wfree<>[] then
  win=wfree(1)
else
  win=maxi(windows(:,2))+1
end
