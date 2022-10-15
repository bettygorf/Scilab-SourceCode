#include <stdio.h>

typedef int node_type;
#define PLAIN 0
#define SINK 1
#define SOURCE 2

#define LOOP 1000

#define MAXNAM 80

typedef struct nodedef {
  int number;
  char *name;
  list *connected_arcs;
  list *loop_arcs;
  double demand;
  node_type type;
  int x, y;
  int col;
  int hilited;
} node, *nodeptr;

extern void DrawNode();
extern void EraseNode();
extern void HiliteNode();
extern node *NodeAlloc();
extern void PrintNode();
extern void UnhiliteNode();

typedef struct arcdef {
  int number;
  char *name;
  node *head;
  node *tail;
  double unitary_cost;
  double minimum_capacity;
  double maximum_capacity;
  double length;
  double quadratic_weight;
  double quadratic_origin;
  double weight;
  int g_type;
  int x0, y0, x1, y1, x2, y2, x3, y3, xmax, ymax, xa0, ya0,
  xa1, ya1, xa2, ya2, xa3, ya3;
  int col;
  int hilited;
} arc, *arcptr;
 
extern arc *ArcAlloc();
extern void DrawArc();
extern void EraseArc();
extern void HiliteArc();
extern void PrintArc();
extern void SetCoordinatesArc();
extern void UnhiliteArc();

typedef struct graphdef {
  char name[MAXNAM];
  struct graphdef *un_graph;
  int directed;
  int node_number;
  int arc_number;
  int sink_number;
  int source_number;
  list *sinks; 
  list *sources;
  list *arcs; /* in decreasing order of arc numbers */
  list *nodes; /* in decreasing order of node numbers */
  arc **arcArray;
  node **nodeArray;
  char **nameEdgeArray;
  char **nameNodeArray;
} graph;

extern void DestroyGraph();
extern void DrawGraph();
extern graph *DuplicateGraph();
extern graph *GraphAlloc();
extern void ReDrawGraph();

extern arc *AddArc();
extern node *AddNode();
extern arc *GetArc();
extern node *GetNode();
extern arc *GetNamedArc();
extern node *GetNamedNode();

extern int ArcToEdgeNumber();
extern int EdgeNumber();
extern int EdgeNumberOfArc();
extern int EdgeToArcNumber();

extern void MakeArraysGraph();
extern void ComputeNameArraysGraph();

typedef struct GG {
  type_id active_type;
  ptr active;
  node *moving;
  int modified;
} GG;

extern GG theGG;
extern graph *theGraph;
