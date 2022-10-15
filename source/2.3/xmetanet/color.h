#define NUMCOLORS 19

#define FOREGROUND 0
#define BLACK 1
#define NAVYBLUE 2
#define BLUE 3
#define SKYBLUE 4
#define AQUAMARINE 5
#define FORESTGREEN 6
#define GREEN 7
#define LIGHTCYAN 8
#define CYAN 9
#define ORANGE 10
#define RED 11
#define MAGENTA 12
#define VIOLET 13
#define YELLOW 14
#define GOLD 15
#define BEIGE 16
#define WHITE 17
#define BACKGROUND 18

extern char* colorNames[];

extern unsigned long Colors[NUMCOLORS];

extern unsigned long theColor;

#define CheckColor(c) ((c<0||c>=NUMCOLORS) ? 0 : c)
