clear;lines(0);
chdir(TMPDIR);
if MSDOS then
  unix_w("dir");
else
  unix_w("ls");
end
