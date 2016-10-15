/* For copyright information, see olden/COPYRIGHT */

/* =============== NODE STRUCTURE =================== */

struct node { 
  int value;
  CAPABILITY struct node *left;
  CAPABILITY struct node *right;
  };

typedef struct node HANDLE;

#define NIL ((__capability HANDLE *) 0)
#ifdef FUTURES
#define makenode(procid) ALLOC(procid,sizeof(struct node))
#else
#define makenode(procid) mymalloc(sizeof(struct node))
#endif
