clear;lines(0);
if MSDOS then unix_s("del foo");
else unix_s("rm foo"); end
