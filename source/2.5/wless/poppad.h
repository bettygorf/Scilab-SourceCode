/*----------------------
   POPPAD.H header file
  ----------------------*/
#if (defined __GNUC__) || (defined __ABSC__)
#define _MAX_PATH   260 /* max. length of full pathname */
#define _MAX_DRIVE  3   /* max. length of drive component */
#define _MAX_DIR    256 /* max. length of path component */
#define _MAX_FNAME  256 /* max. length of file name component */
#define _MAX_EXT    256 /* max. length of extension component */
#endif


#define IDM_NEW          10
#define IDM_OPEN         11
#define IDM_SAVE         12
#define IDM_SAVEAS       13
#define IDM_PRINT        14
#define IDM_EXIT         15

#define IDM_UNDO         20
#define IDM_CUT          21
#define IDM_COPY         22
#define IDM_PASTE        23
#define IDM_CLEAR        24
#define IDM_SELALL       25

#define IDM_FIND         30
#define IDM_NEXT         31
#define IDM_REPLACE      32

#define IDM_FONT         40

#define IDM_HELP         50
#define IDM_ABOUT        51

#define IDD_FNAME        10
