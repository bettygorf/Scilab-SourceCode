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

C-LAB_Interf.obj: ../stack.h ../stack-c.h



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile
