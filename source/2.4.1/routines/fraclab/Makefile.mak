#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------

SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/fraclab.lib

fraclab_OBJSC = \
 FRACLAB_compat.obj\
 MFAM_concave_hull.obj\
 MFAM_density.obj\
 MFAM_kernel.obj\
 MFAM_law.obj\
 MFAM_legendre.obj\
 MFAM_lepskii.obj\
 MFAM_measure.obj\
 MFAM_misc.obj\
 MFAM_oscillation.obj\
 MFAM_random.obj\
 MFAM_regression.obj\
 MFAM_stats.obj\
 MFAM_tree.obj\
 CWT1D_Convol.obj\
 CWT1D_DefWavelet.obj\
 CWT1D_WTransform.obj\
 CWT1D_Wavelet.obj\
 GIFS_util.obj\
 GIFS_alphacoefsigne.obj\
 GIFS_triangle2triangle.obj\
 MFAS_binomial.obj\
 MFAS_multinomial.obj\
 MFAS_multinomial_2d.obj\
 MFAS_lognormal.obj\
 MFAS_spectrum.obj\
 gif.obj\
 gifcomp.obj\
 gifdecomp.obj\
 gifrd.obj\
 gifwr.obj\
 quantize.obj\
 WT_arbre.obj\
 WT_filters.obj\
 WT_mem.obj\
 WT_wavelet_transform.obj\
 MFAG_continuous.obj\
 MFAG_hoelder.obj\
 MFAG_misc.obj\
 WT2D_filters.obj\
 WT2D_mem.obj\
 WT2D_arbre.obj\
 WT2D_wavelet_transform.obj\
 MFAL_discrete.obj\
 MFAL_partition.obj\
 MFAL_reyni.obj\
 sim_stable.obj\
 McCulloch.obj\
 Koutrouvelis.obj\
 stable_sm.obj\
 stable_test.obj\
 stable_cov.obj\
 HOLDER2D_meascalc.obj\
 WSAF_util.obj\
 WSAF_modelise.obj\
 LAB_beep.obj\
 LAB_bbch.obj\
 LAB_linearlt.obj\
 LAB_lepskiiap.obj\
 LAB_monolr.obj\
 LAB_cwt.obj\
 LAB_alphagifs.obj\
 LAB_sgifs.obj\
 LAB_prescalpha.obj\
 LAB_fif.obj\
 LAB_binom.obj\
 LAB_sbinom.obj\
 LAB_multim1d.obj\
 LAB_multim2d.obj\
 LAB_smultim1d.obj\
 LAB_smultim2d.obj\
 LAB_readgif.obj\
 LAB_FWT.obj\
 LAB_IWT.obj\
 LAB_WTDwnHi.obj\
 LAB_WTDwnLo.obj\
 LAB_fch1d.obj\
 LAB_fcfg1d.obj\
 LAB_mch1d.obj\
 LAB_mcfg1d.obj\
 LAB_cfg1d.obj\
 LAB_FWT2D.obj\
 LAB_IWT2D.obj\
 LAB_mdzq1d.obj\
 LAB_mdzq2d.obj\
 LAB_reynitq.obj\
 LAB_mdfl1d.obj\
 LAB_sim_stable.obj\
 LAB_McCulloch.obj\
 LAB_Koutrouvelis.obj\
 LAB_stable_sm.obj\
 LAB_stable_test.obj\
 LAB_stable_cov.obj\
 LAB_holder2d.obj\
 LAB_gifseg.obj\
 LAB_wave2gifs.obj\
 LAB_gifs2wave.obj\
 Interf_fraclab.obj

CLAB_OBJSC = C-LAB_Interf.obj

OBJSC = $(CLAB_OBJSC) $(fraclab_OBJSC)

OBJSF = 

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) -I..

include ../Make.lib.mak

C-LAB_Interf.obj: C-LAB_Interf.h 
C-LAB_Interf.obj: ../machine.h ../stack-def.h
CWT1D_Convol.obj: CWT1D_Filter.h
CWT1D_DefWavelet.obj: CWT1D_DefWavelet.h 
CWT1D_WTransform.obj: CWT1D_WTransform.h CWT1D_Wavelet.h CWT1D_Filter.h
CWT1D_WTransform.obj: CWT1D_Convol.h 
CWT1D_Wavelet.obj: CWT1D_Filter.h CWT1D_Wavelet.h 
HOLDER2D_meascalc.obj: HOLDER2D_const.h HOLDER2D_meascalc.h
Interf_fraclab.obj: C-LAB_Interf.h 
Interf_fraclab.obj: ../machine.h ../stack-def.h
LAB_FWT.obj: C-LAB_Interf.h 
LAB_FWT.obj: ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_FWT.obj: WT_wavelet_transform.h 
LAB_FWT2D.obj: C-LAB_Interf.h 
LAB_FWT2D.obj: ../stack-def.h WT2D_filters.h WT2D_arbre.h WT2D_mem.h
LAB_FWT2D.obj: WT2D_wavelet_transform.h WT2D_const.h 
LAB_IWT.obj: C-LAB_Interf.h 
LAB_IWT.obj: ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_IWT.obj: WT_wavelet_transform.h 
LAB_IWT2D.obj: C-LAB_Interf.h 
LAB_IWT2D.obj: ../stack-def.h WT2D_filters.h WT2D_arbre.h WT2D_mem.h
LAB_IWT2D.obj: WT2D_wavelet_transform.h WT2D_const.h 
LAB_Koutrouvelis.obj: C-LAB_Interf.h 
LAB_Koutrouvelis.obj: ../machine.h ../stack-def.h 
LAB_Koutrouvelis.obj: McCulloch.h Koutrouvelis.h
LAB_McCulloch.obj: C-LAB_Interf.h 
LAB_McCulloch.obj: ../machine.h ../stack-def.h 
LAB_WTDwnHi.obj: C-LAB_Interf.h 
LAB_WTDwnHi.obj: ../machine.h ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_WTDwnHi.obj: WT_wavelet_transform.h 
LAB_WTDwnLo.obj: C-LAB_Interf.h 
LAB_WTDwnLo.obj: ../machine.h ../stack-def.h WT_filters.h WT_arbre.h WT_mem.h
LAB_WTDwnLo.obj: WT_wavelet_transform.h 
LAB_alphagifs.obj: C-LAB_Interf.h 
LAB_alphagifs.obj: ../machine.h ../stack-def.h 
LAB_alphagifs.obj: GIFS_alphacoefsigne.h
LAB_bbch.obj: C-LAB_Interf.h 
LAB_bbch.obj: ../stack-def.h MFAM_concave_hull.h MFAM_include.h
LAB_beep.obj: C-LAB_Interf.h 
LAB_beep.obj: ../stack-def.h
LAB_binom.obj: C-LAB_Interf.h 
LAB_binom.obj: ../stack-def.h MFAS_multinomial.h MFAM_include.h
LAB_cfg1d.obj: C-LAB_Interf.h 
LAB_cfg1d.obj: ../stack-def.h MFAG_continuous.h MFAM_include.h
LAB_cfg1d.obj: MFAG_hoelder.h MFAM_measure.h MFAM_oscillation.h
LAB_cwt.obj: C-LAB_Interf.h 
LAB_cwt.obj: ../stack-def.h CWT1D_Convol.h CWT1D_Filter.h CWT1D_DefWavelet.h
LAB_cwt.obj: CWT1D_WTransform.h CWT1D_Wavelet.h 
LAB_dtq.obj: C-LAB_Interf.h 
LAB_dtq.obj: ../stack-def.h MFAL_reyni.h MFAM_regression.h MFAM_misc.h
LAB_dtq.obj: MFAM_include.h 
LAB_fcfg1d.obj: C-LAB_Interf.h 
LAB_fcfg1d.obj: ../stack-def.h MFAG_continuous.h MFAM_include.h
LAB_fcfg1d.obj: MFAG_hoelder.h MFAM_measure.h MFAM_oscillation.h
LAB_fch1d.obj: C-LAB_Interf.h 
LAB_fch1d.obj: ../stack-def.h MFAG_hoelder.h MFAM_include.h 
LAB_fch1d.obj: FRACLAB_compat.h 
LAB_fch1d.obj: MFAG_misc.h MFAM_misc.h
LAB_fif.obj: C-LAB_Interf.h 
LAB_fif.obj: ../stack-def.h 
LAB_gifs2wave.obj: C-LAB_Interf.h 
LAB_gifs2wave.obj: ../machine.h ../stack-def.h 
LAB_gifs2wave.obj: FRACLAB_compat.h
LAB_gifseg.obj: C-LAB_Interf.h 
LAB_gifseg.obj: ../stack-def.h 
LAB_gifseg.obj: FRACLAB_compat.h
LAB_holder2d.obj: C-LAB_Interf.h 
LAB_holder2d.obj: ../machine.h ../stack-def.h 
LAB_holder2d.obj: HOLDER2D_const.h HOLDER2D_meascalc.h
LAB_lap.obj: C-LAB_Interf.h 
LAB_lap.obj: ../stack-def.h MFAM_lepskii.h MFAM_include.h 
LAB_lap.obj: FRACLAB_compat.h 
LAB_lepskiiap.obj: C-LAB_Interf.h 
LAB_lepskiiap.obj: ../machine.h ../stack-def.h MFAM_lepskii.h MFAM_include.h
LAB_linearlt.obj: C-LAB_Interf.h 
LAB_linearlt.obj: ../machine.h ../stack-def.h MFAM_concave_hull.h
LAB_linearlt.obj: MFAM_include.h 
LAB_llt.obj: C-LAB_Interf.h 
LAB_llt.obj: ../stack-def.h MFAM_concave_hull.h MFAM_include.h
LAB_mcfg1d.obj: C-LAB_Interf.h 
LAB_mcfg1d.obj: ../stack-def.h MFAG_continuous.h MFAM_include.h
LAB_mcfg1d.obj: MFAG_hoelder.h MFAM_measure.h MFAM_oscillation.h
LAB_mch1d.obj: C-LAB_Interf.h 
LAB_mch1d.obj: ../stack-def.h MFAG_hoelder.h MFAM_include.h 
LAB_mch1d.obj: FRACLAB_compat.h 
LAB_mch1d.obj: MFAG_misc.h MFAM_misc.h
LAB_mdfl1d.obj: C-LAB_Interf.h 
LAB_mdfl1d.obj: ../stack-def.h MFAL_discrete.h MFAM_include.h
LAB_mdfl1d.obj: MFAM_measure.h MFAL_reyni.h MFAM_regression.h MFAM_lepskii.h
LAB_mdfl1d.obj: MFAM_concave_hull.h MFAM_legendre.h
LAB_mdzq1d.obj: C-LAB_Interf.h 
LAB_mdzq1d.obj: ../stack-def.h MFAL_partition.h MFAM_include.h
LAB_mdzq2d.obj: C-LAB_Interf.h 
LAB_mdzq2d.obj: ../stack-def.h MFAL_partition.h MFAM_include.h
LAB_monolr.obj: C-LAB_Interf.h 
LAB_monolr.obj: ../stack-def.h MFAM_regression.h MFAM_misc.h MFAM_include.h
LAB_multim1d.obj: C-LAB_Interf.h 
LAB_multim1d.obj: ../machine.h ../stack-def.h MFAM_legendre.h MFAM_include.h
LAB_multim2d.obj: C-LAB_Interf.h 
LAB_multim2d.obj: ../machine.h ../stack-def.h MFAM_legendre.h MFAM_include.h
LAB_prescalpha.obj: C-LAB_Interf.h 
LAB_prescalpha.obj: ../machine.h ../stack-def.h 
LAB_readgif.obj: C-LAB_Interf.h 
LAB_readgif.obj: ../machine.h ../stack-def.h 
LAB_reynitq.obj: C-LAB_Interf.h 
LAB_reynitq.obj: ../machine.h ../stack-def.h MFAL_reyni.h MFAM_regression.h
LAB_reynitq.obj: MFAM_misc.h MFAM_include.h 
LAB_reynitq.obj: FRACLAB_compat.h 
LAB_sbinom.obj: C-LAB_Interf.h 
LAB_sbinom.obj: ../stack-def.h MFAS_binomial.h MFAM_include.h
LAB_sgifs.obj: C-LAB_Interf.h 
LAB_sgifs.obj: ../stack-def.h 
LAB_sim_stable.obj: C-LAB_Interf.h 
LAB_sim_stable.obj: ../machine.h ../stack-def.h 
LAB_sim_stable.obj: sim_stable.h FRACLAB_compat.h
LAB_smultim1d.obj: C-LAB_Interf.h 
LAB_smultim1d.obj: ../machine.h ../stack-def.h MFAS_multinomial.h
LAB_smultim1d.obj: MFAM_include.h 
LAB_smultim2d.obj: C-LAB_Interf.h 
LAB_smultim2d.obj: ../machine.h ../stack-def.h MFAS_multinomial.h
LAB_smultim2d.obj: MFAM_include.h 
LAB_stable_cov.obj: McCulloch.h Koutrouvelis.h stable_sm.h stable_cov.h
LAB_stable_sm.obj: McCulloch.h Koutrouvelis.h stable_sm.h
LAB_stable_test.obj: McCulloch.h Koutrouvelis.h stable_sm.h stable_test.h
LAB_wave2gifs.obj: C-LAB_Interf.h 
LAB_wave2gifs.obj: ../machine.h ../stack-def.h 
LAB_wave2gifs.obj: FRACLAB_compat.h
MFAG_continuous.obj: MFAG_continuous.h MFAM_include.h 
MFAG_continuous.obj: FRACLAB_compat.h 
MFAG_continuous.obj: MFAM_misc.h MFAG_hoelder.h MFAM_measure.h
MFAG_continuous.obj: MFAM_oscillation.h
MFAG_discrete.obj: MFAG_discrete.h Params.h MFAM_include.h
MFAG_discrete.obj: MFAM_kernel.h MFAG_misc.h MFAG_hoelder.h MFAM_measure.h
MFAG_discrete.obj: MFAM_oscillation.h
MFAG_hoelder.obj: MFAG_hoelder.h MFAM_include.h 
MFAG_hoelder.obj: MFAG_misc.h MFAM_misc.h
MFAG_misc.obj: MFAG_misc.h MFAM_include.h 
MFAL_discrete.obj: MFAL_discrete.h MFAM_include.h 
MFAL_discrete.obj: MFAM_measure.h MFAL_reyni.h MFAM_regression.h MFAM_lepskii.h
MFAL_discrete.obj: MFAM_concave_hull.h MFAM_legendre.h
MFAL_partition.obj: MFAL_partition.h MFAM_include.h 
MFAL_reyni.obj: MFAL_reyni.h MFAM_regression.h MFAM_misc.h MFAM_include.h
MFAM_concave_hull.obj: MFAM_concave_hull.h MFAM_include.h 
MFAM_concave_hull.obj: FRACLAB_compat.h 
MFAM_density.obj: MFAM_density.h MFAM_include.h 
MFAM_kernel.obj: MFAM_kernel.h MFAM_include.h 
MFAM_law.obj: MFAM_law.h MFAM_include.h 
MFAM_legendre.obj: MFAM_legendre.h MFAM_include.h 
MFAM_lepskii.obj: MFAM_lepskii.h MFAM_include.h 
MFAM_measure.obj: MFAM_measure.h MFAM_include.h 
MFAM_misc.obj: MFAM_misc.h MFAM_include.h 
MFAM_oscillation.obj: MFAM_oscillation.h MFAM_include.h 
MFAM_oscillation.obj: FRACLAB_compat.h 
MFAM_random.obj: MFAM_random.h MFAM_include.h 
MFAM_regression.obj: MFAM_regression.h MFAM_misc.h MFAM_include.h
MFAM_regression.obj: FRACLAB_compat.h 
MFAM_stats.obj: MFAM_stats.h MFAM_include.h 
MFAM_tree.obj: MFAM_tree.h MFAM_include.h 
MFAS_binomial.obj: MFAM_random.h MFAM_include.h 
MFAS_lognormal.obj: MFAS_lognormal.h MFAM_include.h 
MFAS_multinomial.obj: MFAS_multinomial.h MFAM_include.h 
MFAS_multinomial.obj: FRACLAB_compat.h 
MFAS_multinomial_2d.obj: MFAS_multinomial_2d.h MFAM_include.h
MFAS_multinomial_2d.obj: FRACLAB_compat.h 
MFAS_multinomial_2d.obj: MFAM_random.h
MFAS_spectrum.obj: MFAS_spectrum.h MFAM_include.h 
McCulloch.obj: McCulloch.h 
WT2D_arbre.obj: WT2D_arbre.h 
WT2D_mem.obj: WT2D_mem.h
WT2D_wavelet_transform.obj: WT2D_filters.h WT2D_wavelet_transform.h
WT2D_wavelet_transform.obj: WT2D_arbre.h 
WT_arbre.obj: WT_arbre.h 
WT_mem.obj: WT_mem.h
WT_wavelet_transform.obj: WT_filters.h WT_wavelet_transform.h WT_arbre.h
gifcomp.obj: imgif_const.h
gifdecomp.obj: imgif_const.h
gifrd.obj: imgif_const.h
gifwr.obj: imgif_const.h
sim_stable.obj: sim_stable.h 







Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile
