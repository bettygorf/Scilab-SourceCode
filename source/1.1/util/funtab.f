      subroutine funtab(id,fptr,job)
c     ====================================================================
c!but
c     funtab gere et lit la table des primitives
c!liste d'appel
c     job : indicateur  de l'operation a effectuer
c     0 impression de la table des primitives id et fptr ne sont pas
c             references
c     1 recherche du pointeur fptr associe au nom id, le sous programme
c             retourne la valeur du pointeur dans fptr. S'il n'y a pas
c             de fonction correspondant a id funtab retourne fptr=0
c             si id est un nom incorrect funtab retourne fptr=-1
c     2 recherche du nom id associe au pointeur fptr s'il n'y a pas
c             de fonction associee a ce pointeur funtab retourne
c             id(1)=0
c     3 ajout du nom donne par id avec le pointeur donne par fptr
c             en cas d'erreur (nom incorrecte ou capacite de la table
c             depasse funtab appele error et retourne avec err>0
c     4 suppression du nom donne par id, le sous programme retourne
c             la valeur du pointeur associe dans fptr. S'il n'y a pas
c             de fonction correspondant a id funtab retourne fptr=0
c             si id est un nom incorrect funtab retourne fptr=-1
c
c     id  :vecteur de taille nsiz contenant le code scilab du nom
c     fptr:entier
c!remaque
c     ce sous programme peut etre regenere automatiquement par le
c     programme newfun a partir de sa version courante et du fichier
c     fundef.
c!
c     ====================================================================
c
      include '../stack.h'
      integer   nfree
      parameter (nfree=50)
c
      integer id(*),fptr,job
      logical eqid
      integer point(27)
      integer maxfun
c+
      parameter (maxfun=nfree+236)
      integer funl,funl1,funn(nsiz,maxfun),funp(maxfun)
      integer funm(nsiz,maxfun)
      common /funcs/funl,funn,funp
      data funl/236/
      data funl1/ 44/
c    1 abs            addf           amell   
c    2 argn           arl2           atan    
c    3 adj2l          balanc         bdiag   
c    4 bezout         bva            busack  
c    5 champ          chol           cleanp  
c    6 clearfun       coeff          comp    
c    7 cond           conj           contour 
c    8 contr          convstr        corr    
c    9 cos            connect        createg 
c    a compl2         compht         compunl1
c    1 compla         connex         concom  
c    2 chcm           dassl          debug   
c    3 deff           degree         delbpt  
c    4 delip          det            diag    
c    5 diary          dispbpt        driver  
c    6 dijkst         dfs            dmtree  
c    7 emptystr       ereduc         errcatch
c    8 errclear       error          exec    
c    9 execstr        exists         exp     
c    a eye            edge2st        euler   
c    1 feval          fft            file    
c    2 find           format         fort    
c    3 freq           fstair         funptr  
c    4 fsolve         ford           frank   
c    5 getf           geom3d         grayplot
c    6 gschur         gspec          hess    
c    7 host           int            imag    
c    8 impl           interp         intg    
c    9 inv            iserror        isconnex
c    a johns          kilter         ldiv    
c    1 ldivf          length         lib     
c    2 lines          link           list    
c    3 load           log            ltitr   
c    4 lu             lufact1        lusolve1
c    5 ludel1         lyap           loadg   
c    6 l2adj          macprt         macr2lst
c    7 matrix         maxi           mini    
c    8 mode           mulf           metanet 
c    9 maxflow        minqflow       maxcpl  
c    a mincfr         nemirov        newfun  
c    1 norm           ns2p           ode     
c    2 ones           optim          param3d 
c    3 part           pppdiv         pinv    
c    4 plot2d         plot2d1        plot2d2 
c    5 plot2d3        plot2d4        plot3d  
c    6 plot3d1        poly           ppol    
c    7 predef         print          prod    
c    8 prevn2p        p2ns           prevn2st
c    9 pcchna         pccsc          quapro  
c    a qr             rand           rank    
c    1 rcond          rdivf          read    
c    2 readb          real           remez   
c    3 residu         resume         return  
c    4 ricc           roots          round   
c    5 rpem           rref           rtitr   
c    6 save           schur          setbpt  
c    7 sfact          simp           sign    
c    8 sin            size           sort    
c    9 sousf          spec           splin   
c    a sqrt           string         sum     
c    1 sva            svd            sylv    
c    2 syredi         screen         showns  
c    3 showp          sconnex        sconcom 
c    4 tr_zer         tril           triu    
c    5 type           transc         unix    
c    6 user           umtree         umtree1 
c    7 varn           whereis        writb   
c    8 write          x_choose       x_dialog
c    9 x_messag       x_mdialo       xarc    
c    a xarcs          xarrows        xaxis   
c    1 xchange        xclea          xclear  
c    2 xclick         xend           xfarc   
c    3 xfpoly         xfpolys        xfrect  
c    4 xget           xgetech        xinit   
c    5 xlfont         xnumb          xpause  
c    6 xpoly          xpolys         xrect   
c    7 xrects         xsegs          xselect 
c    8 xset           xsetech        xstring 
c    9 xstringl       xtape   
      data ((funn(i,j),i=1,nsiz),j=  1, 30)/
     1 672926474,673720360, 252513546,673720360, 353244682,673720341, 
     2 386931466,673720360,  34937610,673720360, 386538762,673720360, 
     3  34802954,673720341, 169150987,673713175, 168955147,673720336, 
     4 404950539,673717534, 671751947,673720360, 169614859,673715212, 
     5 369758476,673720345, 353898764,673720360, 168695052,673716503, 
     6 168695052,387845915, 252581900,673720335, 420878348,673720360, 
     7 219617292,673720360, 320280588,673720360, 488052748,672865816, 
     8 488052748,673720347, 521607180,672865564, 454760460,673720360, 
     9 672929804,673720360, 387389452,672992270, 168696588,672140829, 
     a 420878348,673710613, 420878348,673717521, 420878348, 18159390/
      data ((funn(i,j),i=1,nsiz),j= 31, 60)/
     1 420878348,673712661, 387389452,673718542, 202840076,673715736, 
     2 369889548,673720360, 471599629,673720341, 504040973,673720336, 
     3 252644877,673720360, 454037005,673713678, 185929229,673717529, 
     4 303369741,673720345, 672992781,673720360, 269095437,673720360, 
     5 453644813,673720354, 421270029,672995595, 521280269,673717006, 
     6 336794125,673717532, 672927501,673720360, 454891021,673713678, 
     7 488183310,454892578, 219028238,673713182, 203102990,286006538, 
     8 203102990,453643797, 404429582,673720347, 202252558,673720360, 
     9 202252558,672865564, 470950158,673717277, 672735502,673720360, 
     a 672014862,673720360, 235932942,672996354, 236264974,673720347/
      data ((funn(i,j),i=1,nsiz),j= 61, 90)/
     1 169807375,673720341, 672993039,673720360, 236261903,673720360, 
     2 219615759,673720360, 370874383,673717514, 488314895,673720360, 
     3 437132047,673720360, 169679887,673717010, 420945423,673717021, 
     4 353901583,673713695, 219879439,673720360, 386538255,673720340, 
     5 253562384,673720360, 370675216,673713411, 571087632,488117529, 
     6 286006288,673717022, 236526608,673720332, 471600657,673720360, 
     7 488380433,673720360, 672995090,673720360, 269096466,673720360, 
     8 353965586,673720360, 236787474,673716507, 270341906,673720360, 
     9 673126162,673720360, 453909522,672864283, 403446802,554571543, 
     a 386996243,673720348, 487920148,673717006, 521276693,673720360/
      data ((funn(i,j),i=1,nsiz),j= 91,120)/
     1 521276693,673720335, 269946389,673714461, 671814165,673720360, 
     2 236392981,673720348, 337056277,673720360, 488378901,673720360, 
     3 218765333,673720360, 672143381,673720360, 487726357,673720347, 
     4 673717781,673720360, 168762901,671161612, 404495893, 17702677, 
     5 235740693,673710357, 420094485,673720360, 218765333,673720336, 
     6 218759701,673720339, 420219414,673717531, 453773846,488379650, 
     7 454887958,673718546, 304155158,673720360, 303501846,673720360, 
     8 235739158,673720360, 253042198,673720360, 169676310,672992791, 
     9 253823510,673191957, 437719574,538449167, 203491862,673715481, 
     a 202838550,673717007, 303435287,673126427, 253758999,673715998/
      data ((funn(i,j),i=1,nsiz),j=121,150)/
     1 370874391,673720360, 419568663,673720360, 672009496,673720360, 
     2 470685464,673720360, 303896856,673720342, 169544217,671941398, 
     3 488311321,673720360, 219748633,673718034, 521605657,673720360, 
     4 488117529,673713410, 488117529,671157506, 488117529,671223042, 
     5 488117529,671288578, 488117529,671354114, 488117529,673713411, 
     6 488117529,671157507, 571807769,673720360, 353900825,673720360, 
     7 219028249,673713934, 387062553,673720349, 219683609,673720360, 
     8 521018137,672727575, 471269913,673720360, 521018137,488374807, 
     9 286002201,673712663, 470551577,673720332, 420093466,673716251, 
     a 673717018,673720360, 219613723,673720360, 337054235,673720360/
      data ((funn(i,j),i=1,nsiz),j=151,180)/
     1 387451931,673720333, 521276699,673720335, 218762779,673720360, 
     2 218762779,673720331, 352980507,673720360, 236326427,673720355, 
     3 303828507,673717773, 505155099,673713686, 505220635,673715995, 
     4 202117659,673720360, 488118299,673720348, 387848219,673720333, 
     5 370022683,673720360, 252582683,673720360, 487726363,673720347, 
     6 236915228,673720360, 504433692,673720347, 186453532,673717529, 
     7 201985820,673720349, 420876828,673720360, 386929180,673720360, 
     8 672600604,673720360, 237179420,673720360, 488314908,673720360, 
     9 471734300,673720335, 202250524,673720360, 303372572,673720343, 
     a 488315420,673720360, 303766812,673714199, 672538140,673720360/
      data ((funn(i,j),i=1,nsiz),j=181,210)/
     1 671751964,673720360, 671948572,673720360, 521478684,673720360, 
     2 236659228,673714701, 236653596,673715982, 538448156,673717271, 
     3 538448156,673720345, 387451932,673254935, 387451932,672536588, 
     4 589568797,673717006, 353508125,673720360, 504503069,673720360, 
     5 236528157,673720360, 386538269,673713180, 554833694,673720360, 
     6 453909534,673720360, 454891038,673713678, 454891038,671157774, 
     7 387648031,673720360, 453906720,672928270, 487725856,673720331, 
     8 487725856,673720334, 286008353,236722200, 302851105,270013706, 
     9 236332065,269098012, 219554849,404032018, 203098657,673720360, 
     a 203098657,673720348, 454756897,672931864, 304155169,673720348/
      data ((funn(i,j),i=1,nsiz),j=211,236)/
     1 168889377,672010263, 236260385,673720330, 236260385,673717002, 
     2 303369249,673715212, 219614753,673720360, 453644065,673720332, 
     3 404295457,673718805, 404295457,672932373, 236654369,673717516, 
     4 487460897,673720360, 487460897,672205838, 303501857,673720349, 
     5 403641633,673717527, 371070753,673720331, 503978273,673713692, 
     6 353900833,673720354, 353900833,673717282, 202251041,673720349, 
     7 202251041,673717277, 269360161,673720348, 353246241,672992270, 
     8 487463969,673720360, 487463969,672205838, 454892577,672143122, 
     9 454892577,353376018, 420093217,673720334/
      data ((funm(i,j),i=1,nsiz),j=  1, 30)/
     1 386931466,673720360, 420878348,673720360, 252644877,673720360, 
     2 453644813,673720354, 488183310,454892578, 203102990,286006538, 
     3 203102990,453643797, 404429582,673720347, 202252558,673720360, 
     4 202252558,672865564, 470950158,673717277, 672014862,673720360, 
     5 236261903,673720360, 370874383,673717514, 488314895,673720360, 
     6 253562384,673720360, 488380433,673720360, 453909522,672864283, 
     7 269946389,673714461, 671814165,673720360, 236392981,673720348, 
     8 337056277,673720360, 488378901,673720360, 218765333,673720360, 
     9 235739158,673720360, 488311321,673720360, 571807769,673720360, 
     a 219028249,673713934, 387062553,673720349, 218762779,673720360/
      data ((funm(i,j),i=1,nsiz),j= 31, 44)/
     1 218762779,673720331, 505155099,673713686, 505220635,673715995, 
     2 236915228,673720360, 303766812,673714199, 554833694,673720360, 
     3 453909534,673720360, 387648031,673720360, 487725856,673720331, 
     4 487725856,673720334, 286008353,236722200, 302851105,270013706, 
     5 236332065,269098012, 219554849,404032018/
      data (funp(j),j=  1, 30)/
     1      601    ,     2201    ,     1806    ,
     2     1305    ,     2001    ,      625    ,
     3     1517    ,      206    ,      204    ,
     4     1613    ,     1205    ,     1538    ,
     5      701    ,      106    ,     1617    ,
     6     1320    ,     1604    ,     1306    ,
     7      303    ,      604    ,      702    ,
     8     1001    ,     2104    ,     1804    ,
     9      624    ,     1501    ,     1505    ,
     a     1511    ,     1512    ,     1513/
      data (funp(j),j= 31, 60)/
     1     1518    ,     1519    ,     1520    ,
     2     1528    ,     2602    ,     1301    ,
     3      511    ,     1603    ,     1324    ,
     4     1807    ,      102    ,      610    ,
     5      506    ,     1325    ,      712    ,
     6     1526    ,     1530    ,     1534    ,
     7     2105    ,      803    ,     1315    ,
     8     1316    ,     1310    ,      504    ,
     9      517    ,     1314    ,      626    ,
     a      613    ,     1514    ,     1541/
      data (funp(j),j= 61, 90)/
     1     1204    ,     1802    ,      513    ,
     2     2301    ,     1312    ,     1307    ,
     3     1004    ,      804    ,     1321    ,
     4     1104    ,     1524    ,     1527    ,
     5      503    ,      743    ,      711    ,
     6      801    ,      802    ,      201    ,
     7      514    ,      606    ,      603    ,
     8     2601    ,     1902    ,     1203    ,
     9      101    ,     1317    ,     1535    ,
     a     1525    ,     1537    ,     2003/
      data (funp(j),j= 91,120)/
     1     2204    ,     2101    ,      505    ,
     2     1304    ,     1313    ,     1701    ,
     3      501    ,      628    ,     1005    ,
     4      104    ,      108    ,      109    ,
     5      110    ,      901    ,     1504    ,
     6     1516    ,     1326    ,     1322    ,
     7      622    ,      616    ,      617    ,
     8     1308    ,     2203    ,     1502    ,
     9     1536    ,     1539    ,     1540    ,
     a     1542    ,     1103    ,     1319/
      data (funp(j),j=121,150)/
     1      304    ,     1509    ,     1201    ,
     2      615    ,     1101    ,      703    ,
     3     2102    ,     1606    ,      302    ,
     4      706    ,      707    ,      708    ,
     5      709    ,      710    ,      704    ,
     6      705    ,     1601    ,     1002    ,
     7     1318    ,      509    ,      609    ,
     8     1508    ,     1510    ,     1515    ,
     9     1523    ,     1531    ,     1102    ,
     a      401    ,      614    ,      305/
      data (funp(j),j=151,180)/
     1      103    ,     2205    ,      502    ,
     2      515    ,      602    ,     1808    ,
     3     2002    ,     1311    ,     1311    ,
     4      903    ,     1602    ,      605    ,
     5     1805    ,      107    ,     1006    ,
     6      507    ,      202    ,     1323    ,
     7     1614    ,     1607    ,      630    ,
     8      623    ,      607    ,      618    ,
     9     2202    ,      203    ,     1901    ,
     a      627    ,     2103    ,      608/
      data (funp(j),j=181,210)/
     1      306    ,      301    ,      902    ,
     2     1809    ,     1503    ,     1506    ,
     3     1507    ,     1521    ,     1522    ,
     4     1003    ,      612    ,      611    ,
     5     1309    ,     1529    ,      514    ,
     6     1401    ,     1532    ,     1533    ,
     7     1616    ,     1327    ,      516    ,
     8      508    ,     2503    ,     2501    ,
     9     2502    ,     2504    ,      714    ,
     a      715    ,      717    ,      719/
      data (funp(j),j=211,236)/
     1      720    ,      721    ,      724    ,
     2      725    ,      726    ,      713    ,
     3      727    ,      728    ,      723    ,
     4      729    ,      742    ,      730    ,
     5      731    ,      732    ,      733    ,
     6      734    ,      735    ,      722    ,
     7      716    ,      718    ,      736    ,
     8      737    ,      741    ,      738    ,
     9      739    ,      740/
      data point/  1,  8, 13, 35, 49, 61, 73, 78, 80, 88, 89, 90,107,
     1           119,123,126,147,149,166,190,195,199,200,203,237,237,
     2           237/
c+
      if(job.eq.0) then
c----------------------
c     display functions
c----------------------
c     display functions
         call basout(io,wte,'System functions:')
         call prntid(funm,funl1)
      elseif(job.eq.1) then
c-------------------------------------------
c     recherche du pointeur associe a un nom
c-------------------------------------------
         ip=mod(id(1),256)-9
         if(ip.le.26) then
            do 10 k = point(ip) , point(ip+1)-1
               if (eqid(id,funn(1,k))) then
                  fptr=funp(k)
                  return
               endif
 10         continue
            fptr=0
            return
         else
            fptr=-1
            return
         endif
      elseif(job.eq.2) then
c-------------------------------------------
c     recherche du nom associe a un pointeur
c-------------------------------------------
         id(1)=0
         do 20 i=1,funl
            if (funp(i).eq.fptr) then
               call putid(id,funn(1,i))
               return
            endif
 20      continue
      elseif(job.eq.3) then
c-------------------------
c     ajout d'une fonction
c-------------------------
         ip=mod(id(1),256)-9
         if(ip.gt.26) then
            call error(36)
            return
         endif
         if(funl.ge.maxfun) then
            err=maxfun
            call error(107)
            return
         endif
         do 30 k = point(ip) , point(ip+1)-1
            if (eqid(id,funn(1,k))) then
               call error(106)
               return
            endif
 30      continue
         ipp=point(ip+1)
         call icopy(point(27)-ipp,funp(ipp),-1,funp(ipp+1),-1)
         funp(ipp)=fptr
         call icopy(point(27)-ipp,funn(1,ipp),-2,funn(1,ipp+1),-2)
         call icopy(point(27)-ipp,funn(2,ipp),-2,funn(2,ipp+1),-2)
         funn(1,ipp)=id(1)
         funn(2,ipp)=id(2)
c     mise a jour de la table des pointeurs
         do 31 i=ip+1,27
            point(i)=point(i)+1
 31      continue
         funl=funl+1
      elseif(job.eq.4) then
c-------------------------------
c     suppression d'une fonction
c-------------------------------
         ip=mod(id(1),256)-9
         if(ip.le.26) then
            do 41 k = point(ip) , point(ip+1)-1
               if (eqid(id,funn(1,k))) then
                  fptr=funp(k)
                  call icopy(point(27)-k-1,funp(k+1),1,funp(k),1)
                  call icopy(point(27)-k-1,funn(1,k+1),2,funn(1,k),2)
                  call icopy(point(27)-k-1,funn(2,k+1),2,funn(2,k),2)
c     mise a jour de la table des pointeurs
                  do 40 i=ip+1,27
                     point(i)=point(i)-1
 40               continue
                  funl=funl-1
                  return
               endif
 41         continue
            fptr=0
            return
         else
            fptr=-1
            return
         endif
      endif
c
      return
      end
