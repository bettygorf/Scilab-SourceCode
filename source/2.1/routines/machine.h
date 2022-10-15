/* Does C compiler add  a Trailing underscore */
#if defined(SYSV) || defined(sun) || defined(mips) || defined(linux) || defined(__alpha) 
#define WTU
#endif 

#if defined(_IBMR2) || defined(hpux)
#undef WTU
#endif

/* Does C compiler add  a Leading underscore */
#if defined(sun) && !defined(__STDC__)
#define WLU
#endif

/* Define  C2F and F2C entry point conversion */
#if defined(WTU)
#if (defined(__GNUC__) || defined(sun)) && defined(__STDC__)
#define C2F(name) name##_
#define F2C(name) name##_
#else 
#define C2F(name) name/**/_
#define F2C(name) name/**/_
#endif /* syntax */
#else
#define C2F(name) name
#define F2C(name) name
#endif

/* Define some functions */

#define nint(x) ((int) floor(x)) 
#if defined(sparc ) || defined(__alpha)
#undef nint
#endif

#define exp10(x) pow((double) 10.0,x)
#ifdef sparc
#undef exp10
#endif
