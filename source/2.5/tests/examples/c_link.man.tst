clear;lines(0);
if c_link('foo') then link('foo.o','foo');end
// to unlink all the shared libarries which contain foo
a=%t; while a ;[a,b]=c_link('foo'); ulink(b);end
