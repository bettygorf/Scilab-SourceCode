/*------------------------------------------------------------------------
    Graphic library for 2D and 3D plotting 
    Copyright (C) 1998 Chancelier Jean-Philippe
    jpc@cergrene.enpc.fr 
 --------------------------------------------------------------------------*/


#ifndef SCIG_PROTO
#define SCIG_PROTO

#ifdef __STDC__
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		paramlist
#endif
#else	
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		()
#endif
#endif

/* Other functions */

extern void sciprint _PARAMS((char *fmt, ...));
extern void Scistring _PARAMS((char *str));

	/*Actions.c */

extern int C2F(xg2psofig) _PARAMS((char *, integer *, integer *, integer *, char *, long int, long int)); 
extern void scig_2dzoom _PARAMS((integer )); 
extern void scig_unzoom _PARAMS((integer )); 
extern void scig_replay _PARAMS((integer )); 
extern void scig_3drot _PARAMS((integer )); 
extern void scig_sel _PARAMS((integer )); 
extern void scig_loadsg _PARAMS((int , char *)); 
extern void scig_resize _PARAMS((integer )); 
extern void scig_resize_pixmap _PARAMS((integer )); 
extern void scig_erase _PARAMS((integer )); 
extern void scig_tops _PARAMS((integer , integer colored, char *bufname, char *river)); 

/* Alloc.c */

extern integer AllocVectorZD  _PARAMS((double **zm)); 
extern void AllocD  _PARAMS((double **zm, integer zn, integer *err)); 
extern integer ReAllocVectorX  _PARAMS((integer **, integer)); 
extern integer AllocVectorX  _PARAMS((integer **m)); 
extern integer ReAllocVectorY  _PARAMS((integer **, integer)); 
extern integer AllocVectorY  _PARAMS((integer **m)); 
extern integer ReAllocVectorZ  _PARAMS((integer **zm, integer)); 
extern integer AllocVectorZ  _PARAMS((integer **zm)); 
extern void Alloc  _PARAMS((integer **, integer **, integer **zm, integer, integer, integer, integer *)); 

/* Axes.c */

extern void ChoixFormatE  _PARAMS((char *fmt, integer *esres, double xmin, double xmax, double xpas)); 
extern void ChoixFormatE1  _PARAMS((char *fmt, integer *esres, double *x, integer nx)); 
extern void C2F(aplot)  _PARAMS((integer *, double *, double *, double *, double *, integer *, integer *, char *)); 

/* Champ.c */

extern int C2F(champ)  _PARAMS((double *, double *, double *, double *, integer *, integer *, char *, double *, double *, integer)); 
extern int C2F(champ1)  _PARAMS((double *, double *, double *, double *, integer *, integer *, char *, double *, double *, integer)); 
extern double MiniD  _PARAMS((double *, integer)); 
extern void champg  _PARAMS((char *, integer , double *, double *, double *, double *, integer *, integer *, char *, double *, double *, integer)); 
	
	/* Contour.c */

extern integer C2F(get_itg_cont)  _PARAMS((integer i, integer j)); 
extern void C2F(inc_itg_cont)  _PARAMS((integer i, integer j, integer val)); 
extern integer C2F(not_same_sign)  _PARAMS((double val1, double val2)); 
extern integer oddp  _PARAMS((integer i)); 
extern double C2F(x_cont)  _PARAMS((integer i)); 
extern double C2F(y_cont)  _PARAMS((integer i)); 
extern int C2F(contour)  _PARAMS((double *, double *, double *, integer *, integer *, integer *, integer *, double *, double *, double *, char *, integer *, double *, double *, integer)); 
extern int C2F(contour2)  _PARAMS((double *, double *, double *, integer *, integer *, integer *, integer *, double *, integer *, char *, char *, double *, integer *, integer, integer)); 
extern void InitValues  _PARAMS((double *, double *, double *, integer , integer )); 

extern integer ReallocContour  _PARAMS((integer)); 
extern double C2F(phi_cont)  _PARAMS((integer, integer)); 
/* extern integer AllocContour  _PARAMS((void)); */
extern double C2F(f_intercept)  _PARAMS((double, double, double, double, double )); 
extern integer bdyp  _PARAMS((integer , integer )); 


	/* FeC.c */

extern int C2F(fec)  _PARAMS((double *, double *, double *triangles, double *func, integer *Nnode, integer *Ntr, char *, char *, double *, integer *, integer, integer)); 

/* Gray.c */

extern int C2F(xgray)  _PARAMS((double *, double *, double *, integer *, integer *, char *, double *, integer *, long int l1)); 

/* Math.c */

extern double Mini  _PARAMS((double *vect,integer));
extern double Maxi  _PARAMS((double *vect,integer));

	/* Plo2d.c */

extern int C2F(xgrid)  _PARAMS((integer *)); 
extern void AxisDraw  _PARAMS((double *, integer *, integer *, integer *, integer *, double, double, double, double, char *, char *)); 
extern void FrameBounds  _PARAMS((char *, double *, double *, integer *, integer *, integer *, char *, double *, double *, integer *, integer *)); 
extern void Legends  _PARAMS((integer *, integer *, integer *, char *)); 
extern int C2F(plot2d)  _PARAMS((double *, double *, integer *, integer *, integer *, char *, char *, double *, integer *, integer, integer)); 

/* Plo2d1.c */

extern int CheckxfParam  _PARAMS((char *)); 
extern int C2F(plot2d1)  _PARAMS((char *, double *, double *, integer *, integer *, integer *, char *,char *,double *,integer *,integer,integer,integer)); 

	/* Plo2d2.c */

extern int C2F(plot2d2)  _PARAMS((char *,double *,double *,integer *, integer *, integer *, char *, char *, double *,integer *, integer,integer, integer)); 

/* Plo2d3.c */

extern int C2F(plot2d3)  _PARAMS((char *, double *, double *, integer *, integer *,integer *,char *,char *,double *, integer *, integer, integer, integer )); 

/* Plo2d4.c */

extern int C2F(plot2d4)  _PARAMS((char *,double *,double *,integer *,integer *, integer *, char *, char *, double *,integer *,integer,integer, integer)); 

/* Plo2dEch.c */

extern int C2F(graduate)  _PARAMS((double *, double *, double *, double *, integer *, integer *, integer *, integer *, integer *)); 
/** extern void WCScaleList2Global  _PARAMS((WCScaleList *)); **/
extern void Cscale2default  _PARAMS((void)); 
/** extern void Global2WCScaleList  _PARAMS((WCScaleList *));  **/
extern void C2F(GetScaleWindowNumber)  _PARAMS((integer )); 
extern void C2F(SetScaleWindowNumber)  _PARAMS((integer )); 
extern void Scale2D  _PARAMS((integer, double *, integer *, integer *, double *, double *, double *, double *, char *, integer **, integer **, integer, integer *err)); 
extern int C2F(setscale2d)  _PARAMS((double *, double *, char *, integer)); 
extern int C2F(getscale2d)  _PARAMS((double *, double *, char *, integer)); 
extern int C2F(echelle2d)  _PARAMS((double *, double *, integer *, integer *, integer *, integer *, integer *, char *, integer)); 
extern void C2F(echelle2dl)  _PARAMS((double *, double *, integer *, integer *, integer *, integer *, integer *, char *)); 
extern void C2F(ellipse2d)  _PARAMS((double *, integer *, integer *, char *)); 
extern void C2F(rect2d)  _PARAMS((double *, integer *, integer *, char *)); 
extern void C2F(axis2d)  _PARAMS((double *, double *, double *, integer *, double *)); 
extern void zoom  _PARAMS((void)); 
extern void unzoom  _PARAMS((void)); 
extern void Gr_Rescale  _PARAMS((char *, double *, integer *, integer *, integer *, integer *)); 
extern void C2F(aplot1)  _PARAMS((double *, integer *, integer *, integer *, integer *npx, integer *npy, char *logflag, double scx, double scy, double xofset, double yofset)); 

	/* Plo3d.c */

void GetEch3d1  _PARAMS(( double (*m1)[3], double *, double *,double *,double *));
void GetEch3d   _PARAMS((void));
extern void AxesStrings  _PARAMS((integer, integer *, integer *, integer *, char *, double *)); 
extern void MaxiInd  _PARAMS((double *, integer, integer *, double)); 
extern void UpNext  _PARAMS((integer , integer *, integer *)); 
extern void DownNext  _PARAMS((integer , integer *, integer *)); 
extern void TDAxis  _PARAMS((integer flag, double FPval, double LPval, integer *nax, integer *FPoint, integer *LPoint, integer *Ticsdir)); 
extern void C2F(TDdrawaxis)  _PARAMS((double , double FPval, double LPval, integer *nax, integer *FPoint, integer *LPoint, integer *Ticsdir)); 
extern void BBoxToval  _PARAMS((double *, double *, double *, integer , double *)); 
extern void I3dRotation  _PARAMS((void)); 
extern int DPoints1  _PARAMS((integer *polyx, integer *polyy, integer *fill, integer whiteid, double zmin, double zmax, double *, double *, double *, integer i, integer j, integer jj1, integer *p, integer dc, integer fg)); 
extern int DPoints  _PARAMS((integer *polyx, integer *polyy, integer *fill, integer whiteid, double zmin, double zmax, double *, double *, double *, integer i, integer j, integer jj1, integer *p, integer dc, integer fg)); 
extern int C2F(plot3d)  _PARAMS((double *, double *, double *, integer *p, integer *q, double *teta, double *, char *, integer *, double *, integer)); 
extern int C2F(plot3d1)  _PARAMS((double *, double *, double *, integer *p, integer *q, double *teta, double *, char *, integer *, double *, integer)); 
extern int C2F(fac3d)  _PARAMS((double *, double *, double *, integer *cvect, integer *p, integer *q, double *teta, double *, char *, integer *, double *, integer)); 
extern int C2F(fac3d1)  _PARAMS((double *, double *, double *, integer *cvect, integer *p, integer *q, double *teta, double *, char *, integer *, double *, integer)); 
extern int C2F(fac3d2)  _PARAMS((double *, double *, double *, integer *cvect, integer *p, integer *q, double *teta, double *, char *, integer *, double *, integer)); 
extern int C2F(param3d)  _PARAMS((double *, double *, double *, integer *, double *teta, double *, char *, integer *, double *, integer)); 
extern int C2F(param3d1)  _PARAMS((double *, double *, double *, integer *, integer *, integer *, integer *colors, double *teta, double *, char *, integer *, double *, integer )); 
extern int C2F(box3d)  _PARAMS((double *, double *, double *)); 
extern int C2F(geom3d)  _PARAMS((double *, double *, double *, integer *n)); 
extern void SetEch3d  _PARAMS((double *, double *, double *, double *, double *teta, double *)); 
extern void SetEch3d1  _PARAMS((double *, double *, double *, double *, double *teta, double *, integer flag)); 
extern void DrawAxis  _PARAMS((double *, double *, integer *Indices, integer style)); 
extern void Convex_Box  _PARAMS((double *, double *, integer *, integer *, char *, integer *, double *)); 


/* Rec.c */ 

extern void CleanContour2D  _PARAMS((char *plot)); 
extern void CleanGray  _PARAMS((char *plot)); 
extern void CleanParam3D  _PARAMS((char *plot)); 
extern void CleanParam3D1  _PARAMS((char *plot)); 
extern void Clean2D  _PARAMS((char *plot)); 
extern void CleanGrid  _PARAMS((char *plot)); 
extern void CleanEch  _PARAMS((char *plot)); 
extern void CleanX1  _PARAMS((char *plot)); 
extern void CleanChamp  _PARAMS((char *plot)); 
extern void NA3D  _PARAMS((char *plot, double *theta, double *, integer *, integer *, double *)); 
extern void NAFac3D  _PARAMS((char *plot, double *theta, double *, integer *, integer *, double *)); 
extern void NAContour  _PARAMS((char *plot, double *theta, double *, integer *, integer *, double *)); 
extern void NAParam3D  _PARAMS((char *plot, double *theta, double *, integer *, integer *, double *)); 
extern void NAParam3D1  _PARAMS((char *plot, double *theta, double *, integer *, integer *, double *)); 
extern void SCPlots  _PARAMS((char *unused, integer *winnumber, integer *, double *, integer *)); 
extern void SC2DChangeFlag  _PARAMS((char *)); 
extern void SC2D  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void SCContour2D  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void SCgray  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void SCchamp  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void SCfec  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void SCEch  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void SCvoid  _PARAMS((char *plot, integer *, double *, integer *)); 
extern void UnSC2D  _PARAMS((char *plot)); 
extern void UnSCContour2D  _PARAMS((char *plot)); 
extern void UnSCgray  _PARAMS((char *plot)); 
extern void UnSCchamp  _PARAMS((char *plot)); 
extern void UnSCfec  _PARAMS((char *plot)); 
extern void UnSCEch  _PARAMS((char *plot)); 
extern void UnSCvoid  _PARAMS((char *plot)); 
extern int Check3DPlots  _PARAMS((char *unused, integer *winnumber)); 
extern int EchCheckSCPlots  _PARAMS((char *unused, integer *winnumber)); 
extern void Tape_ReplayUndoScale  _PARAMS((char *unused, integer *winnumber)); 
extern void Tape_ReplayNewScale  _PARAMS((char *unused, integer *winnumber, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void Tape_ReplayNewAngle  _PARAMS((char *unused, integer *winnumber, integer *, integer *, integer *, integer *, integer *, double *theta, double *, double *, double *)); 
 extern void Tape_Replay_Show  _PARAMS((char *unused, integer *winnumber, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 

 extern void Tape_Replay  _PARAMS((char *unused, integer *winnumber, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 

 extern void Replay3D  _PARAMS((char *theplot)); 
 extern void ReplayFac3D  _PARAMS((char *theplot)); 
 extern void ReplayFac3D1  _PARAMS((char *theplot)); 
 extern void ReplayFac3D2  _PARAMS((char *theplot)); 
 extern void ReplayFec  _PARAMS((char *theplot)); 
 extern int CopyVectG  _PARAMS((char **pstr, char *, integer, char type)); 
 extern void ReplayContour  _PARAMS((char *theplot)); 
 extern void ReplayContour2D  _PARAMS((char *theplot)); 
 extern void ReplayGray  _PARAMS((char *theplot)); 
 extern void ReplayParam3D  _PARAMS((char *theplot)); 
 extern void ReplayParam3D1  _PARAMS((char *theplot)); 
 extern void Replay3D1  _PARAMS((char *theplot)); 
 extern void Replay2D  _PARAMS((char *theplot)); 
 extern void ReplayGrid  _PARAMS((char *theplot)); 
 extern void ReplayEch  _PARAMS((char *theplot)); 
 extern void ReplayChamp  _PARAMS((char *theplot)); 
 extern void UseColorFlag  _PARAMS((int flag)); 
 extern void ReplayX1  _PARAMS((char *theplot)); 
 extern int  Store  _PARAMS((char *type, char *plot)); 
 extern void StoreEch  _PARAMS((char *, double *WRect, double *, char *logflag)); 
 extern void StorePlot  _PARAMS((char *, char *f, double *, double *, integer *, integer *, integer *, char *, char *, double *, integer *aint)); 
 extern void StoreGrid  _PARAMS((char *, integer *)); 
 extern void StoreParam3D  _PARAMS((char *, double *, double *, double *, integer *, double *teta, double *, char *, integer *, double *)); 
 extern void StoreParam3D1  _PARAMS((char *, double *, double *, double *, integer *, integer *, integer *, integer *colors, double *teta, double *, char *, integer *, double *)); 
 extern int MaybeCopyVect3dPLI  _PARAMS((integer *, integer **, integer *, int l)); 
 extern void StorePlot3D  _PARAMS((char *, double *, double *, double *, integer *p, integer *q, double *teta, double *, char *, integer *, double *)); 
 extern void StoreFac3D  _PARAMS((char *, double *, double *, double *, integer *cvect, integer *p, integer *q, double *teta, double *, char *, integer *, double *)); 
 extern int MaybeCopyVectLI  _PARAMS((char *, integer **, integer *, int l)); 
 extern void StoreFec  _PARAMS((char *, double *, double *, double *triangles, double *func, integer *Nnode, integer *Ntr, char *, char *, double *, integer *)); 
 extern void StoreContour  _PARAMS((char *, double *, double *, double *, integer *, integer *, integer *, integer *, double *, double *teta, double *, char *, integer *, double *, double *zlev)); 
 extern void StoreContour2D  _PARAMS((char *, double *, double *, double *, integer *, integer *, integer *, integer *, double *, integer *, char *, char *, double *, integer *)); 
 extern void StoreGray  _PARAMS((char *, double *, double *, double *, integer *, integer *, char *, double *, integer *)); 

 extern void StoreGray1  _PARAMS((char *, double *, integer *, integer *, char *, double *, integer *)); 
 extern void StoreGray2  _PARAMS((char *, double *, integer *, integer *, double *)); 

 extern void StoreChamp  _PARAMS((char *, double *, double *, double *, double *, integer *, integer *, char *, double *, double *)); 
 extern int CopyVectI  _PARAMS((int **, int *, integer )); 
 extern int CopyVectLI  _PARAMS((integer **, integer *, int )); 
 extern int CopyVectF  _PARAMS((double **, double *, integer )); 
 extern int CopyVectC  _PARAMS((char **, char *, int )); 
 extern void StoreXgc  _PARAMS((integer )); 
 extern void CleanPlots  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void StoreXcall1  _PARAMS((char *, char *, integer *, integer, integer *, integer , integer *, integer , integer *, integer , integer *, integer , integer *, integer , double *, integer , double *, integer , double *, integer , double *, integer )); 
 extern void Clean3D  _PARAMS((char *)); 
 extern void CleanFac3D  _PARAMS((char *)); 
 extern void CleanFec  _PARAMS((char *)); 
 extern void CleanContour  _PARAMS((char *)); 

	/* RecLoad.c  */

 extern int LoadPlot  _PARAMS((void)); 
 extern int LoadGrid  _PARAMS((void)); 
 extern int LoadParam3D  _PARAMS((void)); 
 extern int LoadParam3D1  _PARAMS((void)); 
 extern int LoadPlot3D  _PARAMS((void)); 
 extern int LoadFac3D  _PARAMS((void)); 
 extern int LoadFec  _PARAMS((void)); 
 extern int LoadContour  _PARAMS((void)); 
 extern int LoadContour2D  _PARAMS((void)); 
 extern int LoadGray  _PARAMS((void)); 
 extern int LoadChamp  _PARAMS((void)); 
 extern int LoadXcall1  _PARAMS((void)); 
 extern int C2F(xloadplots)  _PARAMS((char *, integer lvx)); 
 extern int LoadEch  _PARAMS((void)); 

	/* RecSave.c */ 

 extern int SaveGrid  _PARAMS((char *)); 
 extern int SaveParam3D  _PARAMS((char *)); 
 extern int SaveParam3D1  _PARAMS((char *)); 
 extern int SavePlot3D  _PARAMS((char *)); 
 extern int SaveFac3D  _PARAMS((char *)); 
 extern int SaveFec  _PARAMS((char *)); 
 extern int SaveContour  _PARAMS((char *)); 
 extern int SaveXcall1  _PARAMS((char *)); 
 extern int SaveContour2D  _PARAMS((char *)); 
 extern int SaveGray  _PARAMS((char *)); 
 extern int SaveChamp  _PARAMS((char *)); 
 extern int C2F(xsaveplots)  _PARAMS((integer *winnumber, char *, integer lxv)); 
 extern int SaveEch  _PARAMS((char *)); 
 extern int SavePlot  _PARAMS((char *)); 
	
	/* Tests.c */


	/* Xcall.c */

 extern int C2F(dr)  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void C2F(SetDriver)  _PARAMS((char * ,integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 

 extern void GetDriver1  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 


 extern char GetDriver  _PARAMS((void)); 
 extern int C2F(inttest) _PARAMS((int *)); 

	/* Xcall1 */

 extern char *getFPF _PARAMS((void));
 extern int C2F(dr1)  _PARAMS((char * ,char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void xset_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void drawarc_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *angle1, integer *angle2, double *, double *, double *width, double *height, integer , integer )); 
 extern void fillarcs_1  _PARAMS((char *, char *, integer *, integer *fillvect, integer *, integer *, integer *, integer *, double *vects, double *, double *, double *, integer , integer )); 
 extern void drawarcs_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *vects, double *, double *, double *, integer , integer )); 
 extern void fillpolyline_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *closeflag, integer *, integer *, double *, double *vy, double *, double *, integer , integer )); 
 extern void drawarrows_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *vy, double *as, double *, integer , integer )); 
 extern void drawaxis_1  _PARAMS((char *, char *, integer *, integer *nsteps, integer *, integer *, integer *, integer *, double *, double *, double *initpoint, double *, integer , integer )); 
 extern void cleararea_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *w, double *h, integer , integer )); 
 extern void xclick_1  _PARAMS((char *, char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void xclick_any_1  _PARAMS((char *, char *, integer *ibutton, integer *iwin, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void xgetmouse_1  _PARAMS((char *, char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void fillarc_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *angle1, integer *angle2, double *, double *, double *width, double *height, integer , integer )); 
 extern void fillrectangle_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *width, double *height, integer , integer )); 
 extern void drawpolyline_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *closeflag, integer *, integer *, double *, double *vy, double *, double *, integer , integer )); 
 extern void fillpolylines_1  _PARAMS((char *, char *, integer *, integer *, integer *fillvect, integer *, integer *p, integer *, double *, double *vy, double *, double *, integer , integer )); 
 extern void drawpolymark_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *vy, double *, double *, integer , integer )); 
 extern void displaynumbers_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void drawpolylines_1  _PARAMS((char *, char *, integer *, integer *, integer *rawvect, integer *, integer *p, integer *, double *, double *vy, double *, double *, integer , integer )); 
 extern void drawrectangle_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *w, double *h, integer , integer )); 
 extern void drawrectangles_1  _PARAMS((char *, char *, integer *, integer *fillvect, integer *, integer *, integer *, integer *, double *vects, double *, double *, double *, integer , integer )); 
 extern void drawsegments_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *vy, double *, double *, integer , integer )); 
 extern void displaystring_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *angle, double *, integer , integer )); 
 extern void displaystringa_1  _PARAMS((char *, char *, integer *ipos, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *, integer , integer )); 
 extern void boundingbox_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *rect, double *, integer, integer )); 

void xstringb_1  _PARAMS((char *, char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *rect, double *, integer, integer ));

	/* periFig.c */

extern void C2F(getcursymbolXfig)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(semptyXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(gemptyXfig)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(scilabgcgetXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(scilabgcsetXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(ScilabGCGetorSetXfig)  _PARAMS((char *, integer flag, integer *, integer *, integer *, integer *, integer *, integer *, integer *, double *)); 
 extern void C2F(displaystringXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *angle, double *, double *, double *)); 
 extern void C2F(boundingboxXfig)  _PARAMS((char *, integer *, integer *, integer *rect, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawlineXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(drawsegmentsXfig)  _PARAMS((char *, integer *, integer *vy, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarrowsXfig)  _PARAMS((char *, integer *, integer *vy, integer *, integer *as, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectangleXfig)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillrectangleXfig)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectanglesXfig)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillarcsXfig)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcsXfig)  _PARAMS((char *, integer *vects, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcXfig)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(xselgraphicXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillarcXfig)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(drawpolymarkXfig)  _PARAMS((char *, integer *, integer *, integer *vy, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolylinesXfig)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *rawvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillpolylinesXfig)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *fillvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolylineXfig)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xendgraphicXfig)  _PARAMS((void)); 
 extern void C2F(fillpolylineXfig)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeareaflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(initgraphicXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xendXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 

/** extern void C2F(FileInitXfig)  _PARAMS((FILE *filen));  **/

 extern void C2F(InitScilabGCXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(loadfamilyXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawaxisXfig)  _PARAMS((char *, integer *, integer *nsteps, integer *, integer *initpoint, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(clearwindowXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(displaynumbersXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void set_pattern_or_color _PARAMS((int pat, int *areafill, int *color)); 
 extern void set_dash_or_color  _PARAMS((int dash, int *l_style, int *_val, int *color)); 
 extern void C2F(viderbuffXfig)  _PARAMS((void)); 
 extern void C2F(WriteGenericXfig)  _PARAMS((char *, integer nobj, integer sizeobj, integer *, integer *vy, integer sizev, integer flag, integer *fvect)); 
 extern void C2F(getwindowdimXfig)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(Write2VectXfig)  _PARAMS((integer *, integer *vy, integer, integer flag)); 
 extern void C2F(setwindowdimXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getwindowposXfig)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowposXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xpauseXfig)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xclickXfig)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xclick_anyXfig)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xgetmouseXfig)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(clearareaXfig)  _PARAMS((char *, integer *, integer *, integer *w, integer *h, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(setcurwinXfig)  _PARAMS((integer *intnum, integer *, integer *, integer *)); 
 extern void C2F(getcurwinXfig)  _PARAMS((integer *, integer *intnum, integer *, double *)); 
 extern void C2F(setclipXfig)  _PARAMS((integer *, integer *, integer *w, integer *h)); 
 extern void C2F(unsetclipXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getclipXfig)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(absourelXfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getabsourelXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setalufunctionXfig)  _PARAMS((char *)); 
 extern void C2F(idfromnameXfig)  _PARAMS((char *, integer *num)); 
 extern void C2F(setalufunction1Xfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getalufunctionXfig)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setthicknessXfig)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(getthicknessXfig)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setpatternXfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getpatternXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(getlastXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setdashXfig)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(getdashXfig)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(usecolorXfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getusecolorXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setcolormapXfig)  _PARAMS((integer *, integer *, integer *, integer *, integer *, integer *, double *a)); 
 extern void C2F(set_cXfig)  _PARAMS((integer i)); 
 extern void C2F(setbackgroundXfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getbackgroundXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setforegroundXfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getforegroundXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(sethidden3dXfig)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(gethidden3dXfig)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(xsetfontXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetfontXfig)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setcursymbolXfig)  _PARAMS((integer *, integer *, integer *, integer *)); 

	/* periPos.c */

extern void C2F(gemptyPos)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(scilabgcgetPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(scilabgcsetPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(ScilabGCGetorSetPos)  _PARAMS((char *, integer flag, integer *, integer *, integer *, integer *, integer *, integer *, integer *, double *)); 
 extern void C2F(displaystringPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *angle, double *, double *, double *)); 
 extern void C2F(boundingboxPos)  _PARAMS((char *, integer *, integer *, integer *rect, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawlinePos)  _PARAMS((integer *x1, integer *, integer *, integer *)); 
 extern void C2F(drawsegmentsPos)  _PARAMS((char *, integer *, integer *vy, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarrowsPos)  _PARAMS((char *, integer *, integer *vy, integer *, integer *as, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xselgraphicPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectanglesPos)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectanglePos)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillrectanglePos)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillarcsPos)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcsPos)  _PARAMS((char *, integer *vects, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcPos)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(fillarcPos)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(xendgraphicPos)  _PARAMS((void)); 
 extern void C2F(drawpolylinesPos)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *rawvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillpolylinesPos)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *fillvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(xendPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolylinePos)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillpolylinePos)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeareaflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolymarkPos)  _PARAMS((char *, integer *, integer *, integer *vy, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(initgraphicPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void InitScilabGCPos  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(clearwindowPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawaxisPos)  _PARAMS((char *, integer *, integer *nsteps, integer *, integer *initpoint, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(displaynumbersPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(WriteGenericPos)  _PARAMS((char *, integer nobj, integer sizeobj, integer *, integer *vy, integer sizev, integer flag, integer *fvect)); 
 extern void C2F(WriteGeneric1Pos)  _PARAMS((char *, integer nobjpos, integer objbeg, integer sizeobj, integer *, integer *vy, integer flag, integer *fvect)); 
 extern void C2F(xpausePos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(Write2VectPos)  _PARAMS((integer *, integer *vy, integer from, integer, char *, integer flag, integer fv)); 
 extern void C2F(xsetfontPos)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetfontPos)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(xsetmarkPos)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetmarkPos)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(xclickPos)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(loadfamilyPos)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xclick_anyPos)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xgetmousePos)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(clearareaPos)  _PARAMS((char *, integer *, integer *, integer *w, integer *h, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(getwindowposPos)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowposPos)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getwindowdimPos)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowdimPos)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(setcurwinPos)  _PARAMS((integer *intnum, integer *, integer *, integer *)); 
 extern void C2F(getcurwinPos)  _PARAMS((integer *, integer *intnum, integer *, double *)); 
 extern void C2F(setclipPos)  _PARAMS((integer *, integer *, integer *w, integer *h)); 
 extern void C2F(unsetclipPos)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getclipPos)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setabsourelPos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getabsourelPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setalufunctionPos)  _PARAMS((char *)); 
 extern void C2F(idfromnamePos)  _PARAMS((char *, integer *num)); 
 extern void C2F(setalufunction1Pos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getalufunctionPos)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setthicknessPos)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(getthicknessPos)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setpatternPos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getpatternPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(getlastPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setdashPos)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(setdashstylePos)  _PARAMS((integer *value, integer *x, integer *n)); 
 extern void C2F(getdashPos)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(usecolorPos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getusecolorPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setcolormapPos)  _PARAMS((integer *, integer *, integer *, integer *, integer *, integer *, double *a)); 
 extern void ColorInit  _PARAMS((void)); 
 extern void C2F(set_cPos)  _PARAMS((integer i)); 
 extern void C2F(setbackgroundPos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getbackgroundPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setforegroundPos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getforegroundPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(sethidden3dPos)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(gethidden3dPos)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(semptyPos)  _PARAMS((integer *, integer *, integer *, integer *)); 
	
	/* periGif.c */

extern void C2F(gemptyGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(scilabgcgetGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(scilabgcsetGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(ScilabGCGetorSetGif)  _PARAMS((char *, integer flag, integer *, integer *, integer *, integer *, integer *, integer *, integer *, double *)); 
 extern void C2F(displaystringGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *angle, double *, double *, double *)); 
 extern void C2F(boundingboxGif)  _PARAMS((char *, integer *, integer *, integer *rect, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawlineGif)  _PARAMS((integer *x1, integer *, integer *, integer *)); 
 extern void C2F(drawsegmentsGif)  _PARAMS((char *, integer *, integer *vy, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarrowsGif)  _PARAMS((char *, integer *, integer *vy, integer *, integer *as, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xselgraphicGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectanglesGif)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectangleGif)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillrectangleGif)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillarcsGif)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcsGif)  _PARAMS((char *, integer *vects, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcGif)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(fillarcGif)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(xendgraphicGif)  _PARAMS((void)); 
 extern void C2F(drawpolylinesGif)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *rawvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillpolylinesGif)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *fillvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(xendGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolylineGif)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillpolylineGif)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeareaflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolymarkGif)  _PARAMS((char *, integer *, integer *, integer *vy, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(initgraphicGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void InitScilabGCGif  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(clearwindowGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawaxisGif)  _PARAMS((char *, integer *, integer *nsteps, integer *, integer *initpoint, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(displaynumbersGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(WriteGenericGif)  _PARAMS((char *, integer nobj, integer sizeobj, integer *, integer *vy, integer sizev, integer flag, integer *fvect)); 
 extern void C2F(WriteGeneric1Gif)  _PARAMS((char *, integer nobjpos, integer objbeg, integer sizeobj, integer *, integer *vy, integer flag, integer *fvect)); 
 extern void C2F(xpauseGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(Write2VectGif)  _PARAMS((integer *, integer *vy, integer from, integer, char *, integer flag, integer fv)); 
 extern void C2F(xsetfontGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetfontGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(xsetmarkGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetmarkGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(xclickGif)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(loadfamilyGif)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xclick_anyGif)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xgetmouseGif)  _PARAMS((char *, integer *ibutton, integer *x1, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(clearareaGif)  _PARAMS((char *, integer *, integer *, integer *w, integer *h, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(getwindowposGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowposGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getwindowdimGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowdimGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(setcurwinGif)  _PARAMS((integer *intnum, integer *, integer *, integer *)); 
 extern void C2F(getcurwinGif)  _PARAMS((integer *, integer *intnum, integer *, double *)); 
 extern void C2F(setclipGif)  _PARAMS((integer *, integer *, integer *w, integer *h)); 
 extern void C2F(unsetclipGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getclipGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setabsourelGif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getabsourelGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setalufunctionGif)  _PARAMS((char *)); 
 extern void C2F(idfromnameGif)  _PARAMS((char *, integer *num)); 
 extern void C2F(setalufunction1Gif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getalufunctionGif)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setthicknessGif)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(getthicknessGif)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setpatternGif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getpatternGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(getlastGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setdashGif)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(setdashstyleGif)  _PARAMS((integer *value, integer *x, integer *n)); 
 extern void C2F(getdashGif)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(usecolorGif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getusecolorGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setcolormapGif)  _PARAMS((integer *, integer *, integer *, integer *, integer *, integer *, double *a)); 
 extern void ColorInit  _PARAMS((void)); 
 extern void C2F(set_cGif)  _PARAMS((integer i)); 
 extern void C2F(setbackgroundGif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getbackgroundGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setforegroundGif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getforegroundGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(sethidden3dGif)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(gethidden3dGif)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(semptyGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
	
	/* periX11.c */

#ifndef WIN32 

int GetWinsMaxId _PARAMS((void));
void SwitchWindow _PARAMS((integer *intnum));
 extern void C2F(setalufunction)  _PARAMS((char *)); 
 extern void C2F(setalufunction1)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getalufunction)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(setthickness)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(getthickness)  _PARAMS((integer *, integer *value, integer *, double *)); 
/** extern void C2F(CreatePatterns)  _PARAMS((Pixel whitepixel, Pixel blackpixel)); **/
 extern void C2F(setpattern)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getpattern)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(getlast)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setdash)  _PARAMS((integer *value, integer *, integer *, integer *)); 
 extern void C2F(setdashstyle)  _PARAMS((integer *value, integer *x, integer *n)); 
 extern void C2F(getdash)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern void C2F(usecolor)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getusecolor)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setpixmapOn)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getpixmapOn)  _PARAMS((integer *, integer *value, integer *, double *)); 
 extern int C2F(sedeco)  _PARAMS((int *)); 
 extern void C2F(set_default_colormap)  _PARAMS((void)); 
 extern void C2F(setcolormap)  _PARAMS((integer *, integer *, integer *, integer *, integer *, integer *, double *a)); 
 extern void C2F(getcolormap)  _PARAMS((integer *, integer *num, integer *, double *val)); 
 extern void C2F(setbackground)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getbackground)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(setforeground)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getforeground)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void C2F(sethidden3d)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(gethidden3d)  _PARAMS((integer *, integer *num, integer *, double *)); 
/** extern int set_cmap  _PARAMS((Window w));  **/
 extern int get_pixel  _PARAMS((int i)); 
/** extern Pixmap C2F(get_pixmap)  _PARAMS((int i));  **/
/** extern int XgcAllocColors  _PARAMS((struct BCG *gc, int m)); **/
 extern int CheckColormap  _PARAMS((int *m)); 
 extern void get_r  _PARAMS((int i, float *r)); 
 extern void get_g  _PARAMS((int i, float *g)); 
 extern void get_b  _PARAMS((int i, float *b)); 
 extern void C2F(sempty)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(gempty)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(MissileGCget)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(MissileGCset)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(MissileGCGetorSet)  _PARAMS((char *, integer flag, integer *, integer *, integer *, integer *, integer *, integer *, integer *, double *)); 
 extern void C2F(displaystring)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *angle, double *, double *, double *)); 
 extern void C2F(DispStringAngle)  _PARAMS((integer *, integer *y0, char *, double *angle)); 
 extern void C2F(boundingbox)  _PARAMS((char *, integer *, integer *, integer *rect, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawline)  _PARAMS((integer *, integer *, integer *, integer *)); 
/**  extern int XgcFreeColors  _PARAMS((struct BCG *gc));  **/
 extern void C2F(drawsegments)  _PARAMS((char *, integer *, integer *vy, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarrows)  _PARAMS((char *, integer *, integer *vy, integer *, integer *as, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawrectangles)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(pixmapclear)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(drawrectangle)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillrectangle)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillarcs)  _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarcs)  _PARAMS((char *, integer *vects, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawarc)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(fillarc)  _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *)); 
 extern void C2F(show)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(drawpolylines)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *rawvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(fillpolylines)  _PARAMS((char *, integer *vectsx, integer *vectsy, integer *fillvect, integer *, integer *p, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolyline)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void CPixmapResize  _PARAMS((int x, int y)); 
 extern void C2F(fillpolyline)  _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(drawpolymark)  _PARAMS((char *, integer *, integer *, integer *vy, integer *, integer *, integer *, double *, double *, double *, double *)); 
 /** extern struct BCG *AddNewWindowToList  _PARAMS((void));  */
/** extern struct BCG *AddNewWindow  _PARAMS((WindowList **listptr));  */
 extern void DeleteSGWin  _PARAMS((integer intnum)); 
 extern void DeleteWindowToList  _PARAMS((integer num)); 
/** extern Window GetWindowNumber  _PARAMS((int wincount));  **/
/** extern struct BCG *GetWindowXgcNumber  _PARAMS((integer i));  */
/** extern struct BCG *GetWinXgc  _PARAMS((WindowList *listptr, integer i));  */
 extern void C2F(getwins)  _PARAMS((integer *Num, integer *, integer *)); 
 extern void set_c  _PARAMS((integer i)); 
 extern void C2F(initgraphic)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void CPixmapResize1  _PARAMS((void)); 
 extern void C2F(xinfo)  _PARAMS((char *message, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
/**  extern void SendScilab  _PARAMS((Window local, integer winnum));  **/
/** extern Window C2F(Window_With_Name)  _PARAMS((Window top, char *, int j, char *ResList0, char *ResList1, char *ResList2)); **/
 extern void C2F(xselgraphic)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
/** extern Window C2F(Find_X_Scilab)  _PARAMS((void));  **/
/** extern Window C2F(Find_ScilabGraphic_Window)  _PARAMS((integer i));  **/
/** extern Window C2F(Find_BG_Window)  _PARAMS((integer i));  **/
 extern void C2F(drawaxis)  _PARAMS((char *, integer *, integer *nsteps, integer *, integer *initpoint, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xendgraphic)  _PARAMS((void)); 
 extern void C2F(displaynumbers)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xend)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(bitmap)  _PARAMS((char *, integer, integer)); 
 extern void C2F(xsetfont)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetfont)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(xsetmark)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(xgetmark)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(loadfamily)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(clearwindow)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern int C2F(CurSymbXOffset)  _PARAMS((void)); 
 extern int C2F(CurSymbYOffset)  _PARAMS((void)); 
 extern int C2F(store_points)  _PARAMS((integer, integer *, integer *vy, integer onemore)); 
 extern int C2F(AllocVectorStorage)  _PARAMS((void)); 
 extern void set_clip_box _PARAMS((integer xxleft, integer xxright, integer yybot, integer yytop)); 
 extern void clip_line  _PARAMS((integer, integer, integer , integer, integer *, integer *, integer *, integer *, integer *)); 
 extern void C2F(xpause)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xclick)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xclick_any)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *iwin, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xgetmouse_test)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(xgetmouse)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(cleararea)  _PARAMS((char *, integer *, integer *, integer *w, integer *h, integer *, integer *, double *, double *, double *, double *)); 
 extern void C2F(Recenter_GW)  _PARAMS((void)); 
 extern void C2F(getwindowGif)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowGif)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getwindowdim)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setwindowdim)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(setcurwin)  _PARAMS((integer *intnum, integer *, integer *, integer *)); 
 extern void C2F(getcurwin)  _PARAMS((integer *, integer *intnum, integer *, double *)); 
 extern void C2F(setclip)  _PARAMS((integer *, integer *, integer *w, integer *h)); 
 extern void C2F(unsetclip)  _PARAMS((integer *, integer *, integer *, integer *)); 
 extern void C2F(getclip)  _PARAMS((integer *, integer *, integer *, double *)); 
 extern void C2F(setabsourel)  _PARAMS((integer *num, integer *, integer *, integer *)); 
 extern void C2F(getabsourel)  _PARAMS((integer *, integer *num, integer *, double *)); 
 extern void getcolordef  _PARAMS((integer *));
 extern void setcolordef  _PARAMS((integer ));


#else 
/*  periWin.c */

extern void SciG_Font_Printer(int scale);
extern void SciG_Font(void) ;
extern void CleanFonts();
extern void SciMouseCapture();
extern void SciMouseRelease();
extern void SetWinhdc  _PARAMS((void));  
extern int MaybeSetWinhdc  _PARAMS((void));  
extern void ReleaseWinHdc  _PARAMS((void));  
/**   extern void SetGHdc  _PARAMS((HDC lhdc, int width, int height));  **/
/**  extern int XgcAllocColors  _PARAMS((struct BCG *gc, int m));   **/
/**   extern int XgcFreeColors  _PARAMS((struct BCG *gc));  **/
  extern void C2F(pixmapclear)  _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(show)  _PARAMS((integer *, integer *, integer *, integer *));  
  extern void CPixmapResize  _PARAMS((int x, int y));  
  extern void CPixmapResize1  _PARAMS((void));  
  extern void C2F(xselgraphic)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(xendgraphic)  _PARAMS((void));  
  extern void C2F(xend)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(clearwindow)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(xpause)  _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(xclick)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(xclick_any)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *iwin, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(xgetmouse)  _PARAMS((char *, integer *ibutton, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(cleararea)  _PARAMS((char *, integer *, integer *, integer *w, integer *h, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(getwindowpos)  _PARAMS((integer *, integer *, integer *, double *));  
  extern void C2F(setwindowpos)  _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(getwindowdim)  _PARAMS((integer *, integer *, integer *, double *));  
  extern void C2F(setwindowdim)  _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(setcurwin)  _PARAMS((integer *intnum, integer *, integer *, integer *));  
  extern int SwitchWindow  _PARAMS((integer *intnum));  
  extern void C2F(getcurwin) _PARAMS((integer *, integer *intnum, integer *, double *));  
  extern void C2F(setclip) _PARAMS((integer *, integer *, integer *w, integer *h));  
  extern void C2F(unsetclip) _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(getclip) _PARAMS((integer *, integer *, integer *, double *));  
  extern void C2F(setabsourel) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getabsourel) _PARAMS((integer *, integer *num, integer *, double *));  
  extern void C2F(setalufunction) _PARAMS((char *));  
  extern void C2F(setalufunction1) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getalufunction) _PARAMS((integer *, integer *value, integer *, double *));  
  extern void C2F(setthickness) _PARAMS((integer *value, integer *, integer *, integer *));  
  extern void C2F(getthickness) _PARAMS((integer *, integer *value, integer *, double *));  
  extern void C2F(CreatePatterns) _PARAMS((void));  
  extern void C2F(setpattern) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getpattern) _PARAMS((integer *, integer *num, integer *, double *));  
  extern void C2F(getlast) _PARAMS((integer *, integer *num, integer *, double *));  
  extern void C2F(setdash) _PARAMS((integer *value, integer *, integer *, integer *));  
  extern void C2F(getdash) _PARAMS((integer *, integer *value, integer *, double *));  
  extern void C2F(usecolor) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getusecolor) _PARAMS((integer *, integer *num, integer *, double *));  
  extern void C2F(setpixmapOn) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getpixmapOn) _PARAMS((integer *, integer *value, integer *, double *));  
  extern int C2F(sedeco) _PARAMS((int *));  
  extern void set_default_colormap  _PARAMS((void));  
  extern void C2F(setcolormap) _PARAMS((integer *, integer *, integer *, integer *, integer *, integer *, double *a));  
  extern void C2F(getcolormap) _PARAMS((integer *, integer *num, integer *, double *val));  
  extern void C2F(setbackground) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getbackground) _PARAMS((integer *, integer *num, integer *, double *));  
  extern void C2F(setforeground) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(getforeground) _PARAMS((integer *, integer *num, integer *, double *));  
  extern void C2F(sethidden3d) _PARAMS((integer *num, integer *, integer *, integer *));  
  extern void C2F(gethidden3d) _PARAMS((integer *, integer *num, integer *, double *));  
  extern int CheckColormap  _PARAMS((int *m));  
  extern void get_r  _PARAMS((int i, float *r));  
  extern void get_g  _PARAMS((int i, float *g));  
  extern void get_b  _PARAMS((int i, float *b));  
  extern void C2F(sempty) _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(gempty) _PARAMS((integer *, integer *, integer *, double *));  
  extern void C2F(MissileGCget) _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(MissileGCset) _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(MissileGCGetorSet) _PARAMS((char *, integer flag, integer *, integer *, integer *, integer *, integer *, integer *, integer *, double *));  
  extern void C2F(displaystring) _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *angle, double *, double *, double *));  
  extern void C2F(DispStringAngle) _PARAMS((integer *, integer *y0, char *, double *angle));  
  extern void C2F(boundingbox) _PARAMS((char *, integer *, integer *, integer *rect, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawline) _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(drawsegments) _PARAMS((char *, integer *, integer *vy, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawarrows) _PARAMS((char *, integer *, integer *vy, integer *, integer *as, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawrectangles) _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawrectangle) _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(fillrectangle) _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(fillarcs) _PARAMS((char *, integer *vects, integer *fillvect, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawarcs) _PARAMS((char *, integer *vects, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawarc) _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *));  
  extern void C2F(fillarc) _PARAMS((char *, integer *, integer *, integer *width, integer *height, integer *angle1, integer *angle2, double *, double *, double *, double *));  
  extern void C2F(drawpolylines) _PARAMS((char *, integer *vectsx, integer *vectsy, integer *rawvect, integer *, integer *p, integer *, double *, double *, double *, double *));  
  extern void C2F(fillpolylines) _PARAMS((char *, integer *vectsx, integer *vectsy, integer *fillvect, integer *, integer *p, integer *, double *, double *, double *, double *));  
  extern void C2F(drawpolyline) _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(fillpolyline) _PARAMS((char *, integer *, integer *, integer *vy, integer *closeflag, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(drawpolymark) _PARAMS((char *, integer *, integer *, integer *vy, integer *, integer *, integer *, double *, double *, double *, double *));  
/**  extern struct BCG *AddNewWindowToList  _PARAMS((void));  **/
/**  extern struct BCG *AddNewWindow  _PARAMS((WindowList **listptr));  **/
  extern void DeleteSGWin  _PARAMS((integer intnum));  
  extern void DeleteWindowToList  _PARAMS((integer num));  
/**  extern HWND GetWindowNumber  _PARAMS((int wincount));  **/
/**  extern struct BCG *GetWindowXgcNumber  _PARAMS((integer i));  **/
/**  extern struct BCG *GetWinXgc  _PARAMS((WindowList *listptr, integer i));  **/
  extern void C2F(getwins) _PARAMS((integer *, integer *, integer *));  
  extern void set_c  _PARAMS((integer i));  
  extern void C2F(initgraphic) _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(xinfo) _PARAMS((char *message, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void wininfo  _PARAMS((char *fmt,...));
  extern void getcolordef  _PARAMS((integer *creenc));  
  extern void setcolordef  _PARAMS((integer screenc));  
  extern void ResetScilabXgc  _PARAMS((void));  
  extern void C2F(drawaxis) _PARAMS((char *, integer *, integer *nsteps, integer *, integer *initpoint, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(displaynumbers) _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
  extern void C2F(bitmap) _PARAMS((char *, integer, integer));  
  extern void C2F(xsetfont) _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(xgetfont) _PARAMS((integer *, integer *, integer *, double *));  
  extern void C2F(xsetmark) _PARAMS((integer *, integer *, integer *, integer *));  
  extern void C2F(xgetmark) _PARAMS((integer *, integer *, integer *, double *));  
  extern void C2F(loadfamily) _PARAMS((char *, integer *, integer *, integer *, integer *, integer *, integer *, double *, double *, double *, double *));  
/**   extern void SciMakeFont  _PARAMS((char *, int size, HFONT *hfont));  **/
  extern int C2F(CurSymbXOffset) _PARAMS((void));  
  extern int C2F(CurSymbYOffset) _PARAMS((void));  
  extern int C2F(store_points) _PARAMS((integer, integer *, integer *vy, integer onemore));  
  extern int C2F(AllocVectorStorage) _PARAMS((void));  
  extern void set_clip_box  _PARAMS((integer xxleft, integer xxright, integer yybot, integer yytop));  
  extern void clip_line  _PARAMS((integer, integer, integer , integer, integer *, integer *, integer *, integer *, integer *));  

#endif /* ifndef WIN32 */

#endif SCIG_PROTO
