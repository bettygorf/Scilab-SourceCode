SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/fraclab.a

fraclab_OBJSC = \
 FRACLAB_compat.o\
 MFAM_concave_hull.o\
 MFAM_density.o\
 MFAM_kernel.o\
 MFAM_law.o\
 MFAM_legendre.o\
 MFAM_lepskii.o\
 MFAM_measure.o\
 MFAM_misc.o\
 MFAM_oscillation.o\
 MFAM_random.o\
 MFAM_regression.o\
 MFAM_stats.o\
 MFAM_tree.o\
 CWT1D_Convol.o\
 CWT1D_DefWavelet.o\
 CWT1D_WTransform.o\
 CWT1D_Wavelet.o\
 GIFS_util.o\
 GIFS_alphacoefsigne.o\
 GIFS_triangle2triangle.o\
 MFAS_binomial.o\
 MFAS_multinomial.o\
 MFAS_multinomial_2d.o\
 MFAS_lognormal.o\
 MFAS_spectrum.o\
 gif.o\
 gifcomp.o\
 gifdecomp.o\
 gifrd.o\
 gifwr.o\
 quantize.o\
 WT_arbre.o\
 WT_filters.o\
 WT_mem.o\
 WT_wavelet_transform.o\
 MFAG_continuous.o\
 MFAG_hoelder.o\
 MFAG_misc.o\
 WT2D_filters.o\
 WT2D_mem.o\
 WT2D_arbre.o\
 WT2D_wavelet_transform.o\
 MFAL_discrete.o\
 MFAL_partition.o\
 MFAL_reyni.o\
 sim_stable.o\
 McCulloch.o\
 Koutrouvelis.o\
 stable_sm.o\
 stable_test.o\
 stable_cov.o\
 HOLDER2D_meascalc.o\
 WSAF_util.o\
 WSAF_modelise.o\
 LAB_beep.o\
 LAB_bbch.o\
 LAB_linearlt.o\
 LAB_lepskiiap.o\
 LAB_monolr.o\
 LAB_cwt.o\
 LAB_alphagifs.o\
 LAB_sgifs.o\
 LAB_prescalpha.o\
 LAB_fif.o\
 LAB_binom.o\
 LAB_sbinom.o\
 LAB_multim1d.o\
 LAB_multim2d.o\
 LAB_smultim1d.o\
 LAB_smultim2d.o\
 LAB_readgif.o\
 LAB_FWT.o\
 LAB_IWT.o\
 LAB_WTDwnHi.o\
 LAB_WTDwnLo.o\
 LAB_fch1d.o\
 LAB_fcfg1d.o\
 LAB_mch1d.o\
 LAB_mcfg1d.o\
 LAB_cfg1d.o\
 LAB_FWT2D.o\
 LAB_IWT2D.o\
 LAB_mdzq1d.o\
 LAB_mdzq2d.o\
 LAB_reynitq.o\
 LAB_mdfl1d.o\
 LAB_sim_stable.o\
 LAB_McCulloch.o\
 LAB_Koutrouvelis.o\
 LAB_stable_sm.o\
 LAB_stable_test.o\
 LAB_stable_cov.o\
 LAB_holder2d.o\
 LAB_gifseg.o\
 LAB_wave2gifs.o\
 LAB_gifs2wave.o\
 Interf_fraclab.o

CLAB_OBJSC = C-LAB_Interf.o

OBJSC = $(CLAB_OBJSC) $(fraclab_OBJSC)

OBJSF = 

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) -I..

FFLAGS = $(FC_OPTIONS)

include ../Make.lib

C-LAB_Interf.o: C-LAB_Interf.h 
C-LAB_Interf.o: ../machine.h ../stack-def.h
CWT1D_Convol.o: CWT1D_Filter.h
CWT1D_DefWavelet.o: CWT1D_DefWavelet.h 
CWT1D_WTransform.o: CWT1D_WTransform.h CWT1D_Wavelet.h CWT1D_Filter.h
CWT1D_WTransform.o: CWT1D_Convol.h 
CWT1D_Wavelet.o: CWT1D_Filter.h CWT1D_Wavelet.h 
HOLDER2D_meascalc.o: HOLDER2D_const.h HOLDER2D_meascalc.h
Interf_fraclab.o: C-LAB_Interf.h 
Interf_fraclab.o: ../machine.h ../stack-def.h
LAB_FWT.o: C-LAB_Interf.h 
LAB_FWT.o: ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_FWT.o: WT_wavelet_transform.h 
LAB_FWT2D.o: C-LAB_Interf.h 
LAB_FWT2D.o: ../stack-def.h WT2D_filters.h WT2D_arbre.h WT2D_mem.h
LAB_FWT2D.o: WT2D_wavelet_transform.h WT2D_const.h 
LAB_IWT.o: C-LAB_Interf.h 
LAB_IWT.o: ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_IWT.o: WT_wavelet_transform.h 
LAB_IWT2D.o: C-LAB_Interf.h 
LAB_IWT2D.o: ../stack-def.h WT2D_filters.h WT2D_arbre.h WT2D_mem.h
LAB_IWT2D.o: WT2D_wavelet_transform.h WT2D_const.h 
LAB_Koutrouvelis.o: C-LAB_Interf.h 
LAB_Koutrouvelis.o: ../machine.h ../stack-def.h 
LAB_Koutrouvelis.o: McCulloch.h Koutrouvelis.h
LAB_McCulloch.o: C-LAB_Interf.h 
LAB_McCulloch.o: ../machine.h ../stack-def.h 
LAB_WTDwnHi.o: C-LAB_Interf.h 
LAB_WTDwnHi.o: ../machine.h ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_WTDwnHi.o: WT_wavelet_transform.h 
LAB_WTDwnLo.o: C-LAB_Interf.h 
LAB_WTDwnLo.o: ../machine.h ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_WTDwnLo.o: WT_wavelet_transform.h 
LAB_alphagifs.o: C-LAB_Interf.h 
LAB_alphagifs.o: ../machine.h ../stack-def.h 
LAB_alphagifs.o: GIFS_alphacoefsigne.h
LAB_bbch.o: C-LAB_Interf.h 
LAB_bbch.o: ../stack-def.h MFAM_concave_hull.h MFAM_include.h
LAB_beep.o: C-LAB_Interf.h 
LAB_beep.o: ../stack-def.h
LAB_binom.o: C-LAB_Interf.h 
LAB_binom.o: ../stack-def.h MFAS_multinomial.h MFAM_include.h
LAB_cfg1d.o: C-LAB_Interf.h 
LAB_cfg1d.o: ../stack-def.h MFAG_continuous.h MFAM_include.h
LAB_cfg1d.o: MFAG_hoelder.h MFAM_measure.h MFAM_oscillation.h
LAB_cwt.o: C-LAB_Interf.h 
LAB_cwt.o: ../stack-def.h CWT1D_Convol.h CWT1D_Filter.h CWT1D_DefWavelet.h
LAB_cwt.o: CWT1D_WTransform.h CWT1D_Wavelet.h 
LAB_dtq.o: C-LAB_Interf.h 
LAB_dtq.o: ../stack-def.h MFAL_reyni.h MFAM_regression.h MFAM_misc.h
LAB_dtq.o: MFAM_include.h 
LAB_fcfg1d.o: C-LAB_Interf.h 
LAB_fcfg1d.o: ../stack-def.h MFAG_continuous.h MFAM_include.h
LAB_fcfg1d.o: MFAG_hoelder.h MFAM_measure.h MFAM_oscillation.h
LAB_fch1d.o: C-LAB_Interf.h 
LAB_fch1d.o: ../stack-def.h MFAG_hoelder.h MFAM_include.h 
LAB_fch1d.o: FRACLAB_compat.h 
LAB_fch1d.o: MFAG_misc.h MFAM_misc.h
LAB_fif.o: C-LAB_Interf.h 
LAB_fif.o: ../stack-def.h 
LAB_gifs2wave.o: C-LAB_Interf.h 
LAB_gifs2wave.o: ../machine.h ../stack-def.h 
LAB_gifs2wave.o: FRACLAB_compat.h
LAB_gifseg.o: C-LAB_Interf.h 
LAB_gifseg.o: ../stack-def.h 
LAB_gifseg.o: FRACLAB_compat.h
LAB_holder2d.o: C-LAB_Interf.h 
LAB_holder2d.o: ../machine.h ../stack-def.h 
LAB_holder2d.o: HOLDER2D_const.h HOLDER2D_meascalc.h
LAB_lap.o: C-LAB_Interf.h 
LAB_lap.o: ../stack-def.h MFAM_lepskii.h MFAM_include.h 
LAB_lap.o: FRACLAB_compat.h 
LAB_lepskiiap.o: C-LAB_Interf.h 
LAB_lepskiiap.o: ../machine.h ../stack-def.h MFAM_lepskii.h MFAM_include.h
LAB_linearlt.o: C-LAB_Interf.h 
LAB_linearlt.o: ../machine.h ../stack-def.h MFAM_concave_hull.h
LAB_linearlt.o: MFAM_include.h 
LAB_llt.o: C-LAB_Interf.h 
LAB_llt.o: ../stack-def.h MFAM_concave_hull.h MFAM_include.h
LAB_mcfg1d.o: C-LAB_Interf.h 
LAB_mcfg1d.o: ../stack-def.h MFAG_continuous.h MFAM_include.h
LAB_mcfg1d.o: MFAG_hoelder.h MFAM_measure.h MFAM_oscillation.h
LAB_mch1d.o: C-LAB_Interf.h 
LAB_mch1d.o: ../stack-def.h MFAG_hoelder.h MFAM_include.h 
LAB_mch1d.o: FRACLAB_compat.h 
LAB_mch1d.o: MFAG_misc.h MFAM_misc.h
LAB_mdfl1d.o: C-LAB_Interf.h 
LAB_mdfl1d.o: ../stack-def.h MFAL_discrete.h MFAM_include.h
LAB_mdfl1d.o: MFAM_measure.h MFAL_reyni.h MFAM_regression.h MFAM_lepskii.h
LAB_mdfl1d.o: MFAM_concave_hull.h MFAM_legendre.h
LAB_mdzq1d.o: C-LAB_Interf.h 
LAB_mdzq1d.o: ../stack-def.h MFAL_partition.h MFAM_include.h
LAB_mdzq2d.o: C-LAB_Interf.h 
LAB_mdzq2d.o: ../stack-def.h MFAL_partition.h MFAM_include.h
LAB_monolr.o: C-LAB_Interf.h 
LAB_monolr.o: ../stack-def.h MFAM_regression.h MFAM_misc.h MFAM_include.h
LAB_multim1d.o: C-LAB_Interf.h 
LAB_multim1d.o: ../machine.h ../stack-def.h MFAM_legendre.h MFAM_include.h
LAB_multim2d.o: C-LAB_Interf.h 
LAB_multim2d.o: ../machine.h ../stack-def.h MFAM_legendre.h MFAM_include.h
LAB_prescalpha.o: C-LAB_Interf.h 
LAB_prescalpha.o: ../machine.h ../stack-def.h 
LAB_readgif.o: C-LAB_Interf.h 
LAB_readgif.o: ../machine.h ../stack-def.h 
LAB_reynitq.o: C-LAB_Interf.h 
LAB_reynitq.o: ../machine.h ../stack-def.h MFAL_reyni.h MFAM_regression.h
LAB_reynitq.o: MFAM_misc.h MFAM_include.h 
LAB_reynitq.o: FRACLAB_compat.h 
LAB_sbinom.o: C-LAB_Interf.h 
LAB_sbinom.o: ../stack-def.h MFAS_binomial.h MFAM_include.h
LAB_sgifs.o: C-LAB_Interf.h 
LAB_sgifs.o: ../stack-def.h 
LAB_sim_stable.o: C-LAB_Interf.h 
LAB_sim_stable.o: ../machine.h ../stack-def.h 
LAB_sim_stable.o: sim_stable.h FRACLAB_compat.h
LAB_smultim1d.o: C-LAB_Interf.h 
LAB_smultim1d.o: ../machine.h ../stack-def.h MFAS_multinomial.h
LAB_smultim1d.o: MFAM_include.h 
LAB_smultim2d.o: C-LAB_Interf.h 
LAB_smultim2d.o: ../machine.h ../stack-def.h MFAS_multinomial.h
LAB_smultim2d.o: MFAM_include.h 
LAB_stable_cov.o: McCulloch.h Koutrouvelis.h stable_sm.h stable_cov.h
LAB_stable_sm.o: McCulloch.h Koutrouvelis.h stable_sm.h
LAB_stable_test.o: McCulloch.h Koutrouvelis.h stable_sm.h stable_test.h
LAB_wave2gifs.o: C-LAB_Interf.h 
LAB_wave2gifs.o: ../machine.h ../stack-def.h 
LAB_wave2gifs.o: FRACLAB_compat.h
MFAG_continuous.o: MFAG_continuous.h MFAM_include.h 
MFAG_continuous.o: FRACLAB_compat.h 
MFAG_continuous.o: MFAM_misc.h MFAG_hoelder.h MFAM_measure.h
MFAG_continuous.o: MFAM_oscillation.h
MFAG_discrete.o: MFAG_discrete.h Params.h MFAM_include.h
MFAG_discrete.o: MFAM_kernel.h MFAG_misc.h MFAG_hoelder.h MFAM_measure.h
MFAG_discrete.o: MFAM_oscillation.h
MFAG_hoelder.o: MFAG_hoelder.h MFAM_include.h 
MFAG_hoelder.o: MFAG_misc.h MFAM_misc.h
MFAG_misc.o: MFAG_misc.h MFAM_include.h 
MFAL_discrete.o: MFAL_discrete.h MFAM_include.h 
MFAL_discrete.o: MFAM_measure.h MFAL_reyni.h MFAM_regression.h MFAM_lepskii.h
MFAL_discrete.o: MFAM_concave_hull.h MFAM_legendre.h
MFAL_partition.o: MFAL_partition.h MFAM_include.h 
MFAL_reyni.o: MFAL_reyni.h MFAM_regression.h MFAM_misc.h MFAM_include.h
MFAM_concave_hull.o: MFAM_concave_hull.h MFAM_include.h 
MFAM_concave_hull.o: FRACLAB_compat.h 
MFAM_density.o: MFAM_density.h MFAM_include.h 
MFAM_kernel.o: MFAM_kernel.h MFAM_include.h 
MFAM_law.o: MFAM_law.h MFAM_include.h 
MFAM_legendre.o: MFAM_legendre.h MFAM_include.h 
MFAM_lepskii.o: MFAM_lepskii.h MFAM_include.h 
MFAM_measure.o: MFAM_measure.h MFAM_include.h 
MFAM_misc.o: MFAM_misc.h MFAM_include.h 
MFAM_oscillation.o: MFAM_oscillation.h MFAM_include.h 
MFAM_oscillation.o: FRACLAB_compat.h 
MFAM_random.o: MFAM_random.h MFAM_include.h 
MFAM_regression.o: MFAM_regression.h MFAM_misc.h MFAM_include.h
MFAM_regression.o: FRACLAB_compat.h 
MFAM_stats.o: MFAM_stats.h MFAM_include.h 
MFAM_tree.o: MFAM_tree.h MFAM_include.h 
MFAS_binomial.o: MFAM_random.h MFAM_include.h 
MFAS_lognormal.o: MFAS_lognormal.h MFAM_include.h 
MFAS_multinomial.o: MFAS_multinomial.h MFAM_include.h 
MFAS_multinomial.o: FRACLAB_compat.h 
MFAS_multinomial_2d.o: MFAS_multinomial_2d.h MFAM_include.h
MFAS_multinomial_2d.o: FRACLAB_compat.h 
MFAS_multinomial_2d.o: MFAM_random.h
MFAS_spectrum.o: MFAS_spectrum.h MFAM_include.h 
McCulloch.o: McCulloch.h 
WT2D_arbre.o: WT2D_arbre.h 
WT2D_mem.o: WT2D_mem.h
WT2D_wavelet_transform.o: WT2D_filters.h WT2D_wavelet_transform.h
WT2D_wavelet_transform.o: WT2D_arbre.h 
WT_arbre.o: WT_arbre.h 
WT_mem.o: WT_mem.h
WT_wavelet_transform.o: WT_filters.h WT_wavelet_transform.h WT_arbre.h
gifcomp.o: imgif_const.h
gifdecomp.o: imgif_const.h
gifrd.o: imgif_const.h
gifwr.o: imgif_const.h
sim_stable.o: sim_stable.h 





all:: Makefile.mak Makefile.amk

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.amk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile








