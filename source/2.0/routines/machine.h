
#if defined(sun) || defined(mips) ||  defined(__alpha) || defined(linux)
#if defined(__GNUC__) && defined(__STDC__)
#define C2F(name) name##_
#define F2C(name) name##_
#else 
#define C2F(name) name/**/_
#define F2C(name) name/**/_
#endif /* GNUC && STDC */
#else 
#define C2F(name) name
#define F2C(name) name
#endif /* sun || mips */

#define nint(x) ((int) floor(x)) 

#if defined(sparc ) || defined(__alpha)
#undef nint
#endif


#define exp10(x) pow((double) 10.0,x)
#ifdef sparc
#undef exp10
#endif
