      program netgen
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      NPROB=1
      CALL NETCRE(NPROB)
C
      OPEN(12,FILE='FOR012.DAT',STATUS='UNKNOWN',FORM='UNFORMATTED')
      REWIND(12)
      WRITE(12)NODES,IA,NSORC,NSINK
      CALL COPY (STARTN,ENDN,U,C,IA)
      ENDFILE(12)
      REWIND(12)
C
      OPEN(9,FILE='NETGEN.DAT',STATUS='UNKNOWN')
      IPRINT=1
      WRITE(9,7701)NODES
 7701 FORMAT('  NODES'/I7)
      WRITE(9,7702)NSORC
 7702 FORMAT('  NSORC'/I7)
      WRITE(9,7703)NSINK
 7703 FORMAT('  NSINK'/I7)
      WRITE(9,7704)IA
 7704 FORMAT('  NARCS'/I7)
      WRITE(9,7705)
 7705 FORMAT('    ARC  START    END   CAPA   COST')
      WRITE(9,7706)(I1,STARTN(I1),ENDN(I1),U(I1),C(I1),I1=1,IA)
 7706 FORMAT(5I7)
      STOP
      END
      SUBROUTINE COPY (STARTN,ENDN,U,C,N)
      INTEGER STARTN(N),ENDN(N),U(N),C(N)
      WRITE(12) STARTN
      WRITE(12) ENDN  
      WRITE(12) C
      WRITE(12) U
      RETURN
      END
C
C***********************************************************************
C                                                                       
C NETGEN:   CURRENT UNIVERSITY OF TEXAS VERSION                         
C                                                                       
C THIS IS A GENERAL PURPOSE CODE FOR THE GENERATION OF NETWORK TEST     
C PROBLEMS. IT CAN CREATE CAPACITATED AND UNCAPACITATED MINIMUM COST    
C FLOW (OR TRANSSHIPMENT), TRANSPORTATION, AND ASSIGNEMNT PROBLEMS.     
C                                                                       
C ORIGINAL REFERENCE: MANAGEMENT SCIENCE VOL 20 #5 (JANUARY 1974)       
C MODIFIED APRIL-MAY 1986 BY JOHN MOTE (512 / 471-9436)                 
C                                      (BITNET: BGHY231 @ UTA3081)      
C                                                                       
C                                                                       
C COSMETIC MODIFICATION HIGHLIGHTS:                                     
C    1.  GENERATION OF ONE PROBLEM ONLY PER SUBMISSION.  (DISK QUOTA)   
C    2.  ELIMINATION OF "SOLVE" AND "QUIT" RECORDS AT END OF FILE.      
C    3.  ELIMINATION OF "UNCAPACITATED" ON ARCS RECORD.                 
C    4.  ADDITION OF PROBLEM NUMBER FIELD IN FIRST COMMAND RECORD.      
C    5.  ELIMINATION OF BLANK TRAILER IN COMMAND FILE.                  
C    6.  GENERATES NON-CIRCULARIZED NETWORKS ONLY.                      
C    7.  MODIFIED BEGIN/DOCUMENTATION SECTION.       <-----  NOTE THIS. 
C    8.  ELIMINATION OF PROBLEM SUMMARY FILE.                           
C    9.  CHANGE READ/WRITE FROM 5/3 TO LUIN/LUOUT.  ADD COMMON.         
C   10.  ELIMINATION OF FILE CLOSE COMMANDS.                            
C   11.  ELIMINATION OF UNNECESSARY VARIABLES IN COMMON                 
C   12.  PUT ARRAY DIMENSION ON COMMON INSTEAD OF DIMENSION LINE.       
C   13.  CHANGE DENS VARIABLE TO IARCS.  ELIMINATE INTEGER LINE.        
C   14.  REMOVAL OF TWELVE YEAR OLD TYPO (NON6OR <---> NONSOR)          
C   15.  ELIMINATION OF WHEAD AND WEND ROUTINES.                        
C   16.  IMPROVED COMMENTS AND STATEMENT NUMBERING IN SOME ROUTINES.    
C   17.  RENAMED ROUTINES: SRT ---> SORT    PKHD ---> PICKJ             
C   18.  USE OF IMPLICIT TYPE STATEMENT IN EACH ROUTINE                 
C   19.  ADDITION OF RRAN FOR REAL RANDOM NUMBERS (NOT USED HERE)       
C   20.  REPLACEMENT OF MAX SOURCE/SINK WITH MAX NODE PARAMETER         
C   21.  ADDITION OF SIMPLE PROBLEM PARAMETER CONSISTENCY CHECKS        
C                                                                       
C***********************************************************************
C                                                                       
C NETGEN MAKES USE OF TWO LOGICAL UNITS/FILES:                          
C   (1)  LUIN  :  USER'S TEST PROBLEM DESCRIPTION                       
C   (2)  LUOUT :  GENERATED NETWORK IN SHARE FORMAT                     
C                                                                       
C THE USER'S PROBLEM DESCRIPTION IS GIVEN ON TWO RECORDS:               
C                                                                       
C   COLUMNS               DESCRIPTION                    VARIABLE       
C   -------               -----------                    --------       
C RECORD ONE:                                                           
C    1-8      8 DIGIT POSITIVE RANDOM NUMBER SEED........  ISEED        
C    9-16     8 DIGIT PROBLEM ID NUMBER..................  NPROB        
C                                                                       
C RECORD TWO:                                                           
C    1-5      TOTAL NUMBER OF NODES......................  NODES        
C    6-10     TOTAL NUMBER OF SOURCE NODES (INCLUDING                   
C             TRANSSHIPMENT SOURCES).....................  NSORC        
C   11-15     TOTAL NUMBER OF SINK NODES (INCLUDING                     
C             TRANSSHIPMENT SINKS).......................  NSINK        
C   16-20     NUMBER OF ARCS.............................  IARCS        
C   21-25     MINIMUM COST FOR ARCS......................  MINCST       
C   26-30     MAXIMUM COST FOR ARCS......................  MAXCST       
C   31-40     TOTAL SUPPLY...............................  ITSUP        
C   41-45     NUMBER OF TRANSSHIPMENT SOURCE NODES.......  NTSORC       
C   46-50     NUMBER OF TRANSSHIPMENT SINK NODES.........  NTSINK       
C   51-55     PERCENTAGE OF SKELETON ARCS TO BE GIVEN                   
C             THE MAXIMUM COST...........................  IPHIC        
C   56-60     PERCENTAGE OF ARCS TO BE CAPACITATED.......  IPCAP        
C   61-70     MINIMUM UPPER BOUND FOR CAPACITATED ARCS...  MINCAP       
C   71-80     MAXIMUM UPPER BOUND FOR CAPACITATED ARCS...  MAXCAP       
C                                                                       
C ALL INPUT VALUES ARE INTEGER AND MUST BE RIGHT-JUSTIFIED.             
C                                                                       
C NETGEN WILL GENERATE A TRANSPORTATION PROBLEM IF:                     
C    NSORC+NSINK=NODES , NTSORC=0 , AND NTSINK=0                        
C                                                                       
C NETGEN WILL GENERATE AN ASSIGNMENT PROBLEM IF THE REQUIREMENTS FOR    
C A TRANSPORTATION PROBLEM ARE MET AND:                                 
C    NSORC=NSINK  AND  ITSUP=NSORC                                      
C                                                                       
C THE SIX NODE LENGTH ARRAYS SHOULD BE ADJUSTED FOR LARGE PROBLEMS.     
C THE PARAMETER "MXNODE" MUST BE CHANGED ACCORDINGLY.                   
C                                                                       
C***********************************************************************
      SUBROUTINE NETCRE(NPROB)
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON /ARRAY1/ IST,IPRED(10101)                                  
      COMMON /ARRAY2/ IHEAD(10101)                                      
      COMMON /ARRAY3/ ITAIL(10101)                                      
      COMMON /ARRAY4/ IFLAG(10101)                                      
      COMMON /ARRAY5/ ISUP(10101)                                       
      COMMON /ARRAY6/ LSINKS(10101)                                     
      COMMON /NEW/ LUIN,LUOUT                                           
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
C                                                                       
C DEFINE THE ARRAY DIMENSION (MAXIMUM NUMBER OF NODES).                 
C                                                                       
      MXNODE=(10101)                                                    
C                                                                       
C SET THE LOGICAL UNITS.                                                
C                                                                       
      LUIN=5                                                            
      LUOUT=6                                                           
C                                                                       
C INPUT THE USER'S RANDOM NUMBER SEED AND FIX IT IF NON-POSITIVE.       
C                                                                       
      WRITE(LUOUT,10)                                                       
   10 FORMAT('INPUT ISEED (0 FOR ISEED=13502460)')
      READ(LUIN,*)ISEED                                                    
      IF(ISEED.LE.0) ISEED=13502460                                     
      CALL SETRAN(ISEED)                                                
C                                                                       
C INPUT THE USER'S PROBLEM CHARACTERISTICS.                             
C                                                                       
      WRITE(LUOUT,20)
20    FORMAT('INPUT NODES,NSORC,NSINK,IARCS,MINCST,MAXCST,ITSUP')        
 
      READ(LUIN,*)NODES,NSORC,NSINK,IARCS,MINCST,MAXCST,ITSUP
      WRITE(LUOUT,21)
21    FORMAT('INPUT NTSORC,NTSINK,IPHIC,IPCAP,MINCAP,MAXCAP')                 
      READ(LUIN,*)NTSORC,NTSINK,IPHIC,IPCAP,MINCAP,MAXCAP
C PRINT THE PROBLEM DOCUMENTATION RECORDS.  (NOTE CHANGE FROM OLD CODE) 
C                                                                       
C CHECK THE SIZE OF THE PROBLEM.                                        
C                                                                       
      IF(NODES.LE.MXNODE) GO TO 60                                      
      WRITE(LUOUT,50) NODES,MXNODE                                      
   50 FORMAT(' FATAL ERROR: PROBLEM TOO LARGE FOR NETGEN',              
     1      /' REQUESTED NODES:  ',I10,                                 
     1      /' CURRENT DIMENSION:',I10)                                 
      STOP 10                                                           
C                                                                       
C CHECK USER SUPPLIED PARAMETERS FOR CONSISTENCY.                       
C                                                                       
 60   IF(NSORC+NSINK.GT.NODES) then
         write(luout,8000)
 8000    format(' NSORC+NSINK MUST BE <= NODES')
         STOP 11
      endif
      IF(NTSORC.GT.NSORC) then
         write(luout,8001)
 8001    format(' NTSORC MUST BE <= NSORC')
         STOP 12
      endif
      IF(NTSINK.GT.NSINK) then
         write(luout,8002)
 8002    format(' NTSINK MUST BE <= NSINK')
         STOP 13
      endif
      IF(MINCST.GT.MAXCST) then
         write(luout,8003)
 8003    format(' MINCST MUST BE <= MAXCST')
         STOP 14   
      endif
      IF(MINCAP.GT.MAXCAP)  then
         write(luout,8004)
 8004    format(' MINCAP MUST BE <= MAXCAP')
         STOP 15
      endif
C                                                                       
C SET VARIOUS CONSTANTS USED IN THE PROGRAM.                            
C                                                                       
      IA=0
      NARCS=0                                                           
      NSKEL=0                                                           
      NLTR=NODES-NSINK                                                  
      LTSINK=NLTR+NTSINK                                                
      NTRANS=NLTR-NSORC                                                 
      NFSINK=NLTR+1                                                     
      ISSORC=NODES+1                                                    
      ISSINK=NODES+2                                                    
      NONSOR=NODES-NSORC+NTSORC                                         
      NPSINK=NSINK-NTSINK                                               
      NODLFT=NODES-NSINK+NTSINK                                         
      NFTR=NSORC+1                                                      
      NFTSOR=NSORC-NTSORC+1                                             
      NPSORC=NSORC-NTSORC                                               
C                                                                       
C RANDOMLY DISTRIBUTE THE SUPPLY AMONG THE SOURCE NODES.                
C                                                                       
      IF(NPSORC+NPSINK.NE.NODES) GO TO 70                               
      IF(NPSORC.NE.NPSINK) GO TO 70                                     
      IF(ITSUP.NE.NSORC) GO TO 70                                       
      CALL ASSIGN                                                       
      NSKEL=NSORC                                                       
      GO TO 390                                                         
   70 CALL CRESUP                                                       
C                                                                       
C PRINT THE SUPPLY RECORDS.                                             
C                                                                       
      DO 90 I=1,NSORC                                                   
        IA=IA+1
        STARTN(IA)=NODES+1
        ENDN(IA)=I
        C(IA)=0
        U(IA)=ISUP(I)
90    CONTINUE
C                                                                       
C MAKE THE SOURCES POINT TO THEMSELVES IN IPRED ARRAY.                  
C                                                                       
      DO 120 I=1,NSORC                                                  
  120    IPRED(I)=I                                                     
      IF(NTRANS.EQ.0) GO TO 170                                         
C                                                                       
C CHAIN THE TRANSSHIPMENT NODES TOGETHER IN THE IPRED ARRAY.            
C                                                                       
      IST=NFTR                                                          
      IPRED(NLTR)=0                                                     
      K=NLTR-1                                                          
      DO 130 I=NFTR,K                                                   
  130    IPRED(I)=I+1                                                   
C                                                                       
C FORM EVEN LENGTH CHAINS FOR 60 PERCENT OF THE TRANSSHIPMENTS.         
C                                                                       
      NTRAVL=6*NTRANS/10                                                
      NTRREM=NTRANS-NTRAVL                                              
  140 LSORC=1                                                           
  150 IF(NTRAVL.EQ.0) GO TO 160                                         
      LPICK=IRAN(1,NTRAVL+NTRREM)                                       
      NTRAVL=NTRAVL-1                                                   
      CALL CHAIN(LPICK,LSORC)                                           
      IF(LSORC.EQ.NSORC) GO TO 140                                      
      LSORC=LSORC+1                                                     
      GO TO 150                                                         
C                                                                       
C ADD THE REMAINING TRANSSHIPMENTS TO THE CHAINS.                       
C                                                                       
  160 IF(NTRREM.EQ.0) GO TO 170                                         
      LPICK=IRAN(1,NTRREM)                                              
      NTRREM=NTRREM-1                                                   
      LSORC=IRAN(1,NSORC)                                               
      CALL CHAIN(LPICK,LSORC)                                           
      GO TO 160                                                         
C                                                                       
C SET ALL DEMANDS EQUAL TO ZERO.                                        
C                                                                       
  170 DO 180 I=NFSINK,NODES                                             
  180    IPRED(I)=0                                                     
C                                                                       
C THE FOLLOWING LOOP TAKES ONE CHAIN AT A TIME (THROUGH THE USE OF      
C LOGIC CONTAINED IN THE LOOP AND CALLS TO OTHER ROUTINES) AND CREATES  
C THE REMAINING NETWORK ARCS.                                           
C                                                                       
      DO 360 LSORC=1,NSORC                                              
         CALL CHNARC(LSORC)                                             
         DO 190 I=NFSINK,NODES                                          
  190       IFLAG(I)=0                                                  
C                                                                       
C CHOOSE THE NUMBER OF SINKS TO BE HOOKED UP TO THE CURRENT CHAIN(NSK   
C                                                                       
         IF(NTRANS.EQ.0) GO TO 200                                      
         NSKSR=(NSORT*2*NSINK)/NTRANS                                   
         GO TO 210                                                      
  200    NSKSR=NSINK/NSORC+1                                            
  210    IF(NSKSR.LT.2) NSKSR=2                                         
         IF(NSKSR.GT.NSINK) NSKSR=NSINK                                 
         NSRCHN=NSORT                                                   
C                                                                       
C RANDOMLY PICK NSKSR SINKS AND PUT THEIR NAMES IN LSINKS               
C                                                                       
         KTL=NSINK                                                      
         DO 240 J=1,NSKSR                                               
            ITEM=IRAN(1,KTL)                                            
            KTL=KTL-1                                                   
            DO 220 L=NFSINK,NODES                                       
               IF(IFLAG(L).EQ.1) GO TO 220                              
               ITEM=ITEM-1                                              
               IF(ITEM.EQ.0) GO TO 230                                  
  220       CONTINUE                                                    
            GO TO 250                                                   
  230       LSINKS(J)=L                                                 
            IFLAG(L)=1                                                  
  240    CONTINUE                                                       
C                                                                       
C IF LAST SOURCE CHAIN, ADD ALL SINKS WITH ZERO DEMAND TO LSINKS LIST   
C                                                                       
  250    IF(LSORC.NE.NSORC) GO TO 270                                   
         DO 260 J=NFSINK,NODES                                          
            IF(IPRED(J).NE.0) GO TO 260                                 
            IF(IFLAG(J).EQ.1) GO TO 260                                 
            NSKSR=NSKSR+1                                               
            LSINKS(NSKSR)=J                                             
            IFLAG(J)=1                                                  
  260    CONTINUE                                                       
C CREATE DEMANDS FOR GROUP OF SINKS IN LSINKS                           
  270    KS=ISUP(LSORC)/NSKSR                                           
         K=IPRED(LSORC)                                                 
         DO 290 I=1,NSKSR                                               
            NSORT=NSORT+1                                               
            KSP=IRAN(1,KS)                                              
            J=IRAN(1,NSKSR)                                             
            ITAIL(NSORT)=K                                              
            LI=LSINKS(I)                                                
            IHEAD(NSORT)=LI                                             
            IPRED(LI)=IPRED(LI)+KSP                                     
            LI=LSINKS(J)                                                
            IPRED(LI)=IPRED(LI)+KS-KSP                                  
            N=IRAN(1,NSRCHN)                                            
            K=LSORC                                                     
            DO 280 II=1,N                                               
  280          K=IPRED(K)                                               
  290    CONTINUE                                                       
         LI=LSINKS(1)                                                   
         IPRED(LI)=IPRED(LI)+ISUP(LSORC)-(KS*NSKSR)                     
         NSKEL=NSKEL+NSORT                                              
C SORT THE ARCS IN THE CHAIN FROM SOURCE LSORC USING ITAIL AS SORT KEY. 
         CALL SORT                                                      
C PRINT THIS PART OF SKELETON AND CREATE THE ARCS FOR THESE NODES.      
         I=1                                                            
         ITAIL(NSORT+1)=0                                               
  300    DO 310 J=NFTSOR,NODES                                          
  310       IFLAG(J)=0                                                  
         KTL=NONSOR-1                                                   
         IT=ITAIL(I)                                                    
         IFLAG(IT)=1                                                    
  320    IH=IHEAD(I)                                                    
         IFLAG(IH)=1                                                    
         NARCS=NARCS+1                                                  
         KTL=KTL-1                                                      
C                                                                       
C DETERMINE IF THIS SKELETON ARC SHOULD BE CAPACITATED.                 
C                                                                       
         ICAP=ITSUP                                                     
         JCAP=IRAN(1,100)                                               
         IF(JCAP.GT.IPCAP) GO TO 330                                    
         ICAP=ISUP(LSORC)                                               
         IF(MINCAP.GT.ICAP) ICAP=MINCAP                                 
C                                                                       
C DETERMINE IF THIS SKELETON ARC SHOULD HAVE THE MAXIMUM COST.          
C                                                                       
  330    ICOST=MAXCST                                                   
         JCOST=IRAN(1,100)                                              
         IF(JCOST.LE.IPHIC) GO TO 340                                   
         ICOST=IRAN(MINCST,MAXCST)                                      
  340    IA=IA+1
         STARTN(IA)=IT
         ENDN(IA)=IH
         C(IA)=ICOST
         U(IA)=ICAP
         I=I+1                                                          
         IF(ITAIL(I).EQ.IT) GO TO 320                                   
         CALL PICKJ(IT)                                                 
         IF(I.LE.NSORT) GO TO 300                                       
  360 CONTINUE                                                          
C                                                                       
C CREATE ARCS FROM THE TRANSSHIPMENT SINKS.                             
C                                                                       
      IF(NTSINK.EQ.0) GO TO 390                                         
      NZ=0                                                              
      DO 380 I=NFSINK,LTSINK                                            
         DO 370 J=NFTSOR,NODES                                          
  370       IFLAG(J)=0                                                  
         KTL=NONSOR-1                                                   
         IFLAG(I)=1                                                     
         CALL PICKJ(I)                                                  
  380 CONTINUE                                                          
C                                                                       
C PRINT THE DEMAND RECORDS AND END RECORD.                              
C                                                                       
  390 CONTINUE
      DO 410 I=NFSINK,NODES                                             
        IA=IA+1
        STARTN(IA)=I
        ENDN(IA)=NODES+2
        C(IA)=0
        U(IA)=IPRED(I)
410   CONTINUE
      RETURN                                                             
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE CRESUP                                                 
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C CRESUP RANDOMLY DISTRIBUTES THE TOTAL SUPPLY AMONG THE SOURCE NODES.  
C***********************************************************************
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON /ARRAY1/ IST,IPRED(10101)                                      
      COMMON /ARRAY2/ IHEAD(10101)                                          
      COMMON /ARRAY3/ ITAIL(10101)                                          
      COMMON /ARRAY4/ IFLAG(10101)                                          
      COMMON /ARRAY5/ ISUP(10101)                                           
      COMMON /ARRAY6/ LSINKS(10101)                                         
      COMMON /NEW/ LUIN,LUOUT                                           
C                                                                       
      IF(ITSUP.LE.NSORC) then
         write(luout,8005)
 8005    format(' ITSUP MUST BE > NSORC')
         STOP 20
      endif
      KS=ITSUP/NSORC                                                    
      DO 10 I=1,NSORC                                                   
   10    ISUP(I)=0                                                      
      DO 20 I=1,NSORC                                                   
         KSP=IRAN(1,KS)                                                 
         J=IRAN(1,NSORC)                                                
         ISUP(I)=ISUP(I)+KSP                                            
   20    ISUP(J)=ISUP(J)+KS-KSP                                         
      J=IRAN(1,NSORC)                                                   
      ISUP(J)=ISUP(J)+ITSUP-(KS*NSORC)                                  
      RETURN                                                            
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE CHAIN(LPICK,LSORC)                                     
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C CHAIN HAS TWO INPUT PARAMETERS (LPICK AND LSORC). IT ADDS NODE LPICK  
C TO THE END OF THE CHAIN WITH SOURCE NODE LSORC.                       
C***********************************************************************
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON /ARRAY1/ IST,IPRED(10101)                                      
      COMMON /ARRAY2/ IHEAD(10101)                                          
      COMMON /ARRAY3/ ITAIL(10101)                                          
      COMMON /ARRAY4/ IFLAG(10101)                                          
      COMMON /ARRAY5/ ISUP(10101)                                           
      COMMON /ARRAY6/ LSINKS(10101)                                         
      COMMON /NEW/ LUIN,LUOUT                                           
C                                                                       
      K=0                                                               
      M=IST                                                             
      DO 10 I=1,LPICK                                                   
         L=K                                                            
         K=M                                                            
   10    M=IPRED(K)                                                     
      IPRED(L)=M                                                        
      J=IPRED(LSORC)                                                    
      IPRED(K)=J                                                        
      IPRED(LSORC)=K                                                    
      RETURN                                                            
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE CHNARC(LSORC)                                          
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C THIS ROUTINE PUTS THE ARCS IN THE CHAIN FROM SOURCE LSORC INTO THE    
C IHEAD AND ITAIL ARRAYS FOR SORTING.                                   
C***********************************************************************
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR
     1  ,NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT
      COMMON /ARRAY1/ IST,IPRED(10101)                                      
      COMMON /ARRAY2/ IHEAD(10101)                                          
      COMMON /ARRAY3/ ITAIL(10101)                                          
      COMMON /ARRAY4/ IFLAG(10101)                                          
      COMMON /ARRAY5/ ISUP(10101)                                           
      COMMON /ARRAY6/ LSINKS(10101)                                         
      COMMON /NEW/ LUIN,LUOUT                                           
C                                                                       
      NSORT=0                                                           
      ITO=IPRED(LSORC)                                                  
   10 IF(ITO.EQ.LSORC) RETURN                                           
      NSORT=NSORT+1                                                     
      IFROM=IPRED(ITO)                                                  
      IHEAD(NSORT)=ITO                                                  
      ITAIL(NSORT)=IFROM                                                
      ITO=IFROM                                                         
      GO TO 10                                                          
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE SORT                                                   
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C THIS ROUTINE SORTS THE NSORT ARCS IN THE IHEAD AND ITAIL ARRAYS.      
C IHEAD IS USED AS THE SORT KEY (I.E. FORWARD STAR SORT ORDER).         
C***********************************************************************
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON /ARRAY1/ IST,IPRED(10101)                                      
      COMMON /ARRAY2/ IHEAD(10101)                                          
      COMMON /ARRAY3/ ITAIL(10101)                                          
      COMMON /ARRAY4/ IFLAG(10101)                                          
      COMMON /ARRAY5/ ISUP(10101)                                           
      COMMON /ARRAY6/ LSINKS(10101)                                         
      COMMON /NEW/ LUIN,LUOUT                                           
C                                                                       
      N=NSORT                                                           
      M=N                                                               
   10 M=M/2                                                             
      IF(M.EQ.0) RETURN                                                 
      K=N-M                                                             
      J=1                                                               
   20 I=J                                                               
   30 L=I+M                                                             
      IF(ITAIL(I)-ITAIL(L).LE.0) GO TO 40                               
      IT=ITAIL(I)                                                       
      ITAIL(I)=ITAIL(L)                                                 
      ITAIL(L)=IT                                                       
      IT=IHEAD(I)                                                       
      IHEAD(I)=IHEAD(L)                                                 
      IHEAD(L)=IT                                                       
      I=I-M                                                             
      IF(I.GE.1) GO TO 30                                               
   40 J=J+1                                                             
      IF(J.LE.K) GO TO 20                                               
      GO TO 10                                                          
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE PICKJ(IT)                                              
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C THIS ROUTINE CREATES A RANDOM NUMBER OF ARCS OUT OF NODE 'IT'.        
C VARIOUS PARAMETERS ARE DYNAMICALLY ADJUSTED IN AN ATTEMPT TO ENSURE   
C THAT THE GENERATED NETWORK HAS THE CORRECT NUMBER OF ARCS.            
C***********************************************************************
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON /ARRAY1/ IST,IPRED(10101)                                      
      COMMON /ARRAY2/ IHEAD(10101)                                          
      COMMON /ARRAY3/ ITAIL(10101)                                          
      COMMON /ARRAY4/ IFLAG(10101)                                          
      COMMON /ARRAY5/ ISUP(10101)                                           
      COMMON /ARRAY6/ LSINKS(10101)                                         
      COMMON /NEW/ LUIN,LUOUT                                           
C                                                                       
      IF((NODLFT-1)*2.LE.IARCS-NARCS-1) GO TO 10                        
      NODLFT=NODLFT-1                                                   
      RETURN                                                            
   10 IF((IARCS-NARCS+NONSOR-KTL-1)/NODLFT-NONSOR+1) 30,20,20           
   20 K=NONSOR                                                          
      GO TO 50                                                          
   30 NUPBND=(IARCS-NARCS-NODLFT)/NODLFT*2                              
   40 K=IRAN(1,NUPBND)                                                  
      IF(NODLFT.EQ.1) K=IARCS-NARCS                                     
      IF((NODLFT-1)*(NONSOR-1).LT.IARCS-NARCS-K) GO TO 40               
   50 NODLFT=NODLFT-1                                                   
      DO 100 J=1,K                                                      
         NN=IRAN(1,KTL)                                                 
         KTL=KTL-1                                                      
         DO 60 L=NFTSOR,NODES                                           
            IF(IFLAG(L).EQ.1) GO TO 60                                  
            NN=NN-1                                                     
            IF(NN.EQ.0) GO TO 70                                        
   60    CONTINUE                                                       
         RETURN                                                         
   70    IFLAG(L)=1                                                     
         ICAP=ITSUP                                                     
         JCAP=IRAN(1,100)                                               
         IF(JCAP.GT.IPCAP) GO TO 80                                     
         ICAP=IRAN(MINCAP,MAXCAP)                                       
   80    ICOST=IRAN(MINCST,MAXCST)                                      
         IA=IA+1
         STARTN(IA)=IT
         ENDN(IA)=L
         C(IA)=ICOST
         U(IA)=ICAP
         NARCS=NARCS+1                                                  
  100 CONTINUE                                                          
      RETURN                                                            
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE ASSIGN                                                 
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C THIS ROUTINE GENERATES ASSIGNMENT PROBLEMS.  IT DEFINES THE UNIT      
C SUPPLIES, BUILDS A SKELETON, THEN CALLS PICKJ TO CREATE THE ARCS.     
C***********************************************************************
      INTEGER STARTN(12000),ENDN(12000),C(12000),U(12000)
      COMMON/ARRAYS/STARTN/ARRAYE/ENDN/ARRAY8/U/ARRAY9/C/BK/IA
      COMMON /VAR/ NODES,IARCS,MINCST,MAXCST,ITSUP,NSORC,NSINK,NONSOR,  
     1   NFSINK,NARCS,NSORT,NFTSOR,IPCAP,MINCAP,MAXCAP,KTL,NODLFT       
      COMMON /ARRAY1/ IST,IPRED(10101)                                      
      COMMON /ARRAY2/ IHEAD(10101)                                          
      COMMON /ARRAY3/ ITAIL(10101)                                          
      COMMON /ARRAY4/ IFLAG(10101)                                          
      COMMON /ARRAY5/ ISUP(10101)                                           
      COMMON /ARRAY6/ LSINKS(10101)                                         
      COMMON /NEW/ LUIN,LUOUT                                           
C                                                                       
      DO 20 I=1,NSORC                                                   
        IA=IA+1
        STARTN(IA)=NODES+1
        ENDN(IA)=I
        C(IA)=0
        U(IA)=1
         ISUP(I)=1                                                      
         IFLAG(I)=0                                                     
   20 CONTINUE                                                          
      DO 50 I=NFSINK,NODES                                              
   50    IPRED(I)=1                                                     
      DO 100 IT=1,NSORC                                                 
         DO 60 I=NFSINK,NODES                                           
   60       IFLAG(I)=0                                                  
         KTL=NSINK-1                                                    
         NN=IRAN(1,NSINK-IT+1)                                          
         DO 70 L=1,NSORC                                                
            IF(IFLAG(L).EQ.1) GO TO 70                                  
            NN=NN-1                                                     
            IF(NN.EQ.0) GO TO 80                                        
   70    CONTINUE                                                       
   80    NARCS=NARCS+1                                                  
         LL=NSORC+L                                                     
         ICOST=IRAN(MINCST,MAXCST)                                      
         IA=IA+1
         STARTN(IA)=IT
         ENDN(IA)=LL
         C(IA)=ICOST
         U(IA)=ISUP(1)
         IFLAG(L)=1                                                     
         IFLAG(LL)=1                                                    
         CALL PICKJ(IT)                                                 
  100 CONTINUE                                                          
      RETURN                                                            
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      SUBROUTINE SETRAN(ISEED)                                          
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C PORTABLE CONGRUENTIAL (UNIFORM) RANDOM NUMBER GENERATOR:              
C     NEXT_VALUE = [(7**5) * PREVIOUS_VALUE] MODULO[(2**31)-1]          
C                                                                       
C THIS GENERATOR CONSISTS OF THREE ROUTINES:                            
C   (1) SETRAN - INITIALIZES CONSTANTS AND SEED                         
C   (2) IRAN   - GENERATES AN INTEGER RANDOM NUMBER                     
C   (3) RRAN   - GENERATES A REAL RANDOM NUMBER                         
C                                                                       
C THE GENERATOR REQUIRES A MACHINE WITH AT LEAST 32 BITS OF PRECISION.  
C THE SEED (ISEED) MUST BE IN THE RANGE (1,(2**31)-1).                  
C***********************************************************************
      COMMON /RAN/ MULT,MODUL,I15,I16,JRAN    
      COMMON /NEW/ LUIN,LUOUT                                                               
      IF(ISEED.LT.1) then
         write(luout,8006)
 8006    format(' ISEED MUST BE >= 0')
         STOP 77
      endif
      MULT=16807                                                        
      MODUL=2147483647                                                  
      I15=2**15                                                         
      I16=2**16                                                         
      JRAN=ISEED                                                        
      RETURN                                                            
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      FUNCTION IRAN(ILOW,IHIGH)                                         
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C IRAN GENERATES AN INTEGER RANDOM NUMBER BETWEEN ILOW AND IHIGH.       
C IF ILOW.GT.IHIGH THEN IRAN RETURNS IRAN=IHIGH.                        
C***********************************************************************
      COMMON /RAN/ MULT,MODUL,I15,I16,JRAN                              
      IXHI=JRAN/I16                                                     
      IXLO=JRAN-IXHI*I16                                                
      IXALO=IXLO*MULT                                                   
      LEFTLO=IXALO/I16                                                  
      IXAHI=IXHI*MULT                                                   
      IFULHI=IXAHI+LEFTLO                                               
      IRTLO=IXALO-LEFTLO*I16                                            
      IOVER=IFULHI/I15                                                  
      IRTHI=IFULHI-IOVER*I15                                            
      JRAN=((IRTLO-MODUL)+IRTHI*I16)+IOVER                              
      IF(JRAN.LT.0) JRAN=JRAN+MODUL                                     
      J=IHIGH-ILOW+1                                                    
      IF(J.LE.0) GO TO 10                                               
      IRAN=MOD(JRAN,J)+ILOW                                             
      RETURN                                                            
   10 IRAN=IHIGH                                                        
      RETURN                                                            
      END                                                               
C                                                                       
C                                                                       
C                                                                       
      FUNCTION RRAN(RLOW,RHIGH)                                         
      IMPLICIT REAL*8 (A-H,O-Z) , INTEGER*4 (I-N)                       
C***********************************************************************
C RRAN GENERATES A REAL RANDOM NUMBER BETWEEN RLOW AND RHIGH BY SIMPLY  
C USING IRAN, THEN SCALING THE INTEGER VALUE TO THE DESIRED REAL RANGE. 
C IF RLOW.GT.RHIGH THEN RRAN RETURNS RRAN=RHIGH.                        
C***********************************************************************
      RRANGE=RHIGH-RLOW                                                 
      IF(RRANGE.GT.0.0) GO TO 10                                        
      RRAN=RHIGH                                                        
      RETURN                                                            
   10 ISCALE=10000                                                      
      IVALUE=IRAN(0,ISCALE)                                             
      RSCALE=ISCALE                                                     
      RVALUE=IVALUE                                                     
      RRAN=RLOW+(RVALUE/RSCALE)*RRANGE                                  
      RETURN                                                            
      END                                                               

