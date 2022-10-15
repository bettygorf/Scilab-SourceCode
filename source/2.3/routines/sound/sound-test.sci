// {w,rate}=loadwave(filename); loads a WAV file.
// w=loadwave(filename); loads a WAV file. r is saved to defaultrate.
// savewave(filename,v[,rate,bits]); saves a WAV file.
// analyze(v[,fmin,fmax,rate,points]); plots the frequencies of v
// mapsound(w,[,dt,fmin,fmax,simpl,rate]); show the sound history
// soundsec(n[,rate]); generates t values for n seconds.
// Default sample rate is 22050 or the sample rate of the last read WAV file.

stacksize(2000000);
exec('scilab.sci')
getf('sound1')

// At first we create 0.5 seconds of sound parameters.
t=soundsec(0.5);
// Then we generate the sound.

s=sin(440*t)+sin(220*t)/2+sin(880*t)/2;
[nr,nc]=size(t);
s(nc/2:nc)=sin(330*t(nc/2:nc));

// We can easily make a Fourier analysis of it.
xbasc();analyze(s);
// Save the file in WAV format.
// we renormalize s in order to check that save+load is invariant
s=s-sum(s)/prod(size(s)); s=s/max(abs(s));
savewave("test.wav",s);
// Load it back.
s1=loadwave("test.wav");

if maxi(abs(s1-s)) < 1.e-4;

// Now we can make a complete picture of the sound.
xbasc();mapsound(s);
// Or a Fourier analysis.
xbasc();analyze(s);

