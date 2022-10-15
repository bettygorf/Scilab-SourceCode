function [w]=loadwave (filename)
// Copyright INRIA
// Read a WAV file.
// The sample rate is stored to defaultrate.
	defaultrate=22050;
        mopen(filename,"rb");
        if mgetstr(4)<>"RIFF"; error("No Wave file!"); end;
        mget(1,"l");; // This is the total file length minus 8
        if mgetstr(8)<>"WAVEfmt "; error("No Wave file!"); end;
        mget(1,"l");; // ??? Is always 16.
        mget(1,"s"); // ??? Is always 1.
        if (mget(1,"s")<>1); error("Stereo sample!"); end;
        rate=mget(1,"l");; mget(1,"l");;
        byte=mget(1,"s");
        bits=mget(1,"s");
        if mgetstr(4)<>"data"; error("No Wave file!"); end;
        if byte==1;
		xx=mget(1,"l");
                w=mget(xx,"uc");
        elseif byte==2;
                w=mget(mget(1,"l")/2,"s");
        else error("Not 8 or 16 bit!");
        end;
        if prod(size(w))>0; 
		w=w-sum(w)/prod(size(w)); w=w/max(abs(w)); end;
        mclose();
        defaultrate=rate;
