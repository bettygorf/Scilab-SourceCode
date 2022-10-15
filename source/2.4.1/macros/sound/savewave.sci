function [z]=savewave(filename,v,rate,bits)
// Copyright INRIA
// Save a vector of sound data in WAV format.
// Return the length of the sample in seconds.
// If rate=0, the default sampling rate is taken.
// bits may be 8 or 16.
	[lhs,rhs]=argn(0);
	if rhs <= 3 then bits =16;end
	if rhs <= 2 then rate =0;end
	defaultrate=22050;
        if rate==0; rate=defaultrate; end;
        mopen(filename,"wb");
        mputstr("RIFF");
        if bits==8;
                n=prod(size(v));
                mput(n+37,"l");
                mputstr("WAVEfmt ");
                mput(16,"l"); mput(1,"s"); mput(1,"s");
                mput(rate,"l"); mput(rate,"l");
                mput(1,"s"); mput(8,"s");
                mputstr("data");
                mput(n,"l");
                m=max(abs(v)); v=v/m*64+128;
                putuchar(v,"uc");
                putchar(0,"c");
        elseif bits==16;
                n=prod(size(v));
                mput(2*n+36,"l");
                mputstr("WAVEfmt ");
                mput(16,"l"); mput(1,"s"); mput(1,"s");
                mput(rate,"l"); mput(2*rate,"l");
                mput(2,"s"); mput(16,"s");
                mputstr("data");
                mput(2*n,"l");
                m=max(abs(v)); v=v/m*64*256;
                mput(v,"s");
        else error("Bits must be 8 or 16");
        end
        mclose();
	z=prod(size(v))/rate;
