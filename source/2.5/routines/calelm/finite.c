typedef unsigned int __uint32_t;
typedef union 
{
  struct 
  {
    __uint32_t lsw;
    __uint32_t msw;
  } parts;
  double value;
} ieee_double_shape_type;

#ifdef __STDC__
int finite(double x)
#else
int finite(x)
double x;
#endif
{
  int hx;
  ieee_double_shape_type gh_u;
  
  gh_u.value = x;
  hx = gh_u.parts.msw;
  return  (int)((__uint32_t)((hx&0x7fffffff)-0x7ff00000)>>31);
}
