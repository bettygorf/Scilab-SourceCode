typedef int type_id;
#define ARC 1
#define NODE 2

typedef char *ptr;

typedef struct mylinkdef {
  ptr element;
  struct mylinkdef *next;
} mylink;

typedef struct listdef {
  mylink *first;
} list;

extern void AddListElement();
extern void RemoveListElement();
extern int FindInLarray();
extern list *ListAlloc();
extern void SortLarray();
