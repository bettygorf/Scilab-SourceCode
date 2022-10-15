/******* Copyright INRIA *************/
/******* Please do not edit *************/
extern void F2C(intcos)(ARGS_scicos);
extern void F2C(coselm)(ARGS_scicos);
extern void F2C(evtdly)(ARGS_scicos);
extern void F2C(cstblk)(ARGS_scicos);
extern void F2C(dband)(ARGS_scicos);
extern void F2C(gain)(ARGS_scicos);
extern void F2C(lusat)(ARGS_scicos);
extern void F2C(pload)(ARGS_scicos);
extern void F2C(qzcel)(ARGS_scicos);
extern void F2C(qzflr)(ARGS_scicos);
extern void F2C(qzrnd)(ARGS_scicos);
extern void F2C(qztrn)(ARGS_scicos);
extern void F2C(scope)(ARGS_scicos);
extern void F2C(lsplit)(ARGS_scicos);
extern void F2C(csslti)(ARGS_scicos);
extern void F2C(dsslti)(ARGS_scicos);
extern void F2C(trash)(ARGS_scicos);
extern void F2C(zcross)(ARGS_scicos);
extern void F2C(absblk)(ARGS_scicos);
extern void F2C(expblk)(ARGS_scicos);
extern void F2C(logblk)(ARGS_scicos);
extern void F2C(sinblk)(ARGS_scicos);
extern void F2C(tanblk)(ARGS_scicos);
extern void F2C(cosblk)(ARGS_scicos);
extern void F2C(powblk)(ARGS_scicos);
extern void F2C(sqrblk)(ARGS_scicos);
extern void F2C(delay)(ARGS_scicos);
extern void F2C(selblk)(ARGS_scicos);
extern void F2C(forblk)(ARGS_scicos);
extern void F2C(ifthel)(ARGS_scicos);
extern void F2C(writef)(ARGS_scicos);
extern void F2C(invblk)(ARGS_scicos);
extern void F2C(hltblk)(ARGS_scicos);
extern void F2C(gensin)(ARGS_scicos);
extern void F2C(rndblk)(ARGS_scicos);
extern void F2C(lookup)(ARGS_scicos);
extern void F2C(timblk)(ARGS_scicos);
extern void F2C(cdummy)(ARGS_scicos);
extern void F2C(gensqr)(ARGS_scicos);
extern void F2C(mfclck)(ARGS_scicos);
extern void F2C(sawtth)(ARGS_scicos);
extern void F2C(tcslti)(ARGS_scicos);
extern void F2C(tcsltj)(ARGS_scicos);
extern void F2C(scopxy)(ARGS_scicos);
extern void F2C(evscpe)(ARGS_scicos);
extern void F2C(integr)(ARGS_scicos);
extern void F2C(readf)(ARGS_scicos);
extern void F2C(affich)(ARGS_scicos);
extern void F2C(intpol)(ARGS_scicos);
extern void F2C(intplt)(ARGS_scicos);
extern void F2C(minblk)(ARGS_scicos);
extern void F2C(maxblk)(ARGS_scicos);
extern void F2C(dlradp)(ARGS_scicos);
extern void F2C(andlog)(ARGS_scicos);
extern void F2C(iocopy)(ARGS_scicos);
extern void F2C(sum2)(ARGS_scicos);
extern void F2C(sum3)(ARGS_scicos);
extern void F2C(delayv)(ARGS_scicos);
extern void F2C(mux)(ARGS_scicos);
extern void F2C(demux)(ARGS_scicos);
extern void F2C(samphold)(ARGS_scicos);
extern void F2C(dollar)(ARGS_scicos);
extern void F2C(mscope)(ARGS_scicos);
extern void F2C(eselect)(ARGS_scicos);
extern void F2C(intrp2)(ARGS_scicos);
extern void F2C(intrpl)(ARGS_scicos);
extern void F2C(fsv)(ARGS_scicos);
extern void F2C(memo)(ARGS_scicos);
extern void selector(ARGS_scicos);
extern void sum(ARGS_scicos);
extern void prod(ARGS_scicos);
extern void switchn(ARGS_scicos);
extern void relay(ARGS_scicos);
 
OpTab tabsim[] ={
{"absblk",(ScicosF) F2C(absblk)},
{"affich",(ScicosF) F2C(affich)},
{"andlog",(ScicosF) F2C(andlog)},
{"cdummy",(ScicosF) F2C(cdummy)},
{"cosblk",(ScicosF) F2C(cosblk)},
{"coselm",(ScicosF) F2C(coselm)},
{"csslti",(ScicosF) F2C(csslti)},
{"cstblk",(ScicosF) F2C(cstblk)},
{"dband",(ScicosF) F2C(dband)},
{"delay",(ScicosF) F2C(delay)},
{"delayv",(ScicosF) F2C(delayv)},
{"demux",(ScicosF) F2C(demux)},
{"dlradp",(ScicosF) F2C(dlradp)},
{"dollar",(ScicosF) F2C(dollar)},
{"dsslti",(ScicosF) F2C(dsslti)},
{"eselect",(ScicosF) F2C(eselect)},
{"evscpe",(ScicosF) F2C(evscpe)},
{"evtdly",(ScicosF) F2C(evtdly)},
{"expblk",(ScicosF) F2C(expblk)},
{"forblk",(ScicosF) F2C(forblk)},
{"fsv",(ScicosF) F2C(fsv)},
{"gain",(ScicosF) F2C(gain)},
{"gensin",(ScicosF) F2C(gensin)},
{"gensqr",(ScicosF) F2C(gensqr)},
{"hltblk",(ScicosF) F2C(hltblk)},
{"ifthel",(ScicosF) F2C(ifthel)},
{"intcos",(ScicosF) F2C(intcos)},
{"integr",(ScicosF) F2C(integr)},
{"intplt",(ScicosF) F2C(intplt)},
{"intpol",(ScicosF) F2C(intpol)},
{"intrp2",(ScicosF) F2C(intrp2)},
{"intrpl",(ScicosF) F2C(intrpl)},
{"invblk",(ScicosF) F2C(invblk)},
{"iocopy",(ScicosF) F2C(iocopy)},
{"logblk",(ScicosF) F2C(logblk)},
{"lookup",(ScicosF) F2C(lookup)},
{"lsplit",(ScicosF) F2C(lsplit)},
{"lusat",(ScicosF) F2C(lusat)},
{"maxblk",(ScicosF) F2C(maxblk)},
{"memo",(ScicosF) F2C(memo)},
{"mfclck",(ScicosF) F2C(mfclck)},
{"minblk",(ScicosF) F2C(minblk)},
{"mscope",(ScicosF) F2C(mscope)},
{"mux",(ScicosF) F2C(mux)},
{"pload",(ScicosF) F2C(pload)},
{"powblk",(ScicosF) F2C(powblk)},
{"prod",(ScicosF) prod},
{"qzcel",(ScicosF) F2C(qzcel)},
{"qzflr",(ScicosF) F2C(qzflr)},
{"qzrnd",(ScicosF) F2C(qzrnd)},
{"qztrn",(ScicosF) F2C(qztrn)},
{"readf",(ScicosF) F2C(readf)},
{"relay",(ScicosF) relay},
{"rndblk",(ScicosF) F2C(rndblk)},
{"samphold",(ScicosF) F2C(samphold)},
{"sawtth",(ScicosF) F2C(sawtth)},
{"scope",(ScicosF) F2C(scope)},
{"scopxy",(ScicosF) F2C(scopxy)},
{"selblk",(ScicosF) F2C(selblk)},
{"selector",(ScicosF) selector},
{"sinblk",(ScicosF) F2C(sinblk)},
{"sqrblk",(ScicosF) F2C(sqrblk)},
{"sum",(ScicosF) sum},
{"sum2",(ScicosF) F2C(sum2)},
{"sum3",(ScicosF) F2C(sum3)},
{"switchn",(ScicosF) switchn},
{"tanblk",(ScicosF) F2C(tanblk)},
{"tcslti",(ScicosF) F2C(tcslti)},
{"tcsltj",(ScicosF) F2C(tcsltj)},
{"timblk",(ScicosF) F2C(timblk)},
{"trash",(ScicosF) F2C(trash)},
{"writef",(ScicosF) F2C(writef)},
{"zcross",(ScicosF) F2C(zcross)},
{(char *) 0, (ScicosF) 0}};
 
int ntabsim= 73 ;
/***********************************/
