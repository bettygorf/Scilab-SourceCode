struct {
    float b[10];
} cmntest;

#define Max(x,y)        (((x)>(y))?(x):(y))

int ext12ic(n, a)
int *n;
float *a;
{
    int i1;
    static int k;
    i1 = Max(*n,10);
    for (k = 0; k < i1; ++k) {
	cmntest.b[k] = a[k];
    }
} 

int ext12oc(n, c)
int *n;
float *c;
{
    int i1;
    static int k;

    i1 = Max(*n,10);
    for (k = 0; k < i1; ++k) {
	c[k] = cmntest.b[k];
    }
} 


