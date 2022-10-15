SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME=mtlblib
NAM=mtlb

MTLB = mtlb_e.sci mtlb_i.sci mtlb_max.sci mtlb_min.sci \
	mtlb_ones.sci mtlb_zeros.sci mtlb_eye.sci mtlb_rand.sci mtlb_length.sci\
	mtlb_plot.sci mtlb_loglog.sci mtlb_subplot.sci mtlb_get.sci\
	mtlb_hold.sci mtlb_ishold.sci\
	mtlb_sum.sci mtlb_cumsum.sci \
	mtlb_ifft.sci  mtlb_fft.sci mtlb_filter.sci\
	mtlb_load.sci mtlb_save.sci mtlb_fread.sci mtlb_fwrite.sci\
	mtlb_exist.sci mtlb_mean.sci mtlb_qz.sci mtlb_find.sci\
	mtlb_all.sci mtlb_any.sci mtlb_prod.sci mtlb_median.sci \
	fseek_origin.sci mtlb_choices.sci\
	%s_m_b.sci %b_m_s.sci %s_x_b.sci %b_x_s.sci %b_g_s.sci %b_h_s.sci \
	%s_a_b.sci %b_a_s.sci %s_s_b.sci %b_s_s.sci \
	%b_c_s.sci %b_f_s.sci %s_c_b.sci %s_f_b.sci %s_g_b.sci %s_h_b.sci \
	%b_sum.sci %b_prod.sci

M5 = mtlb_cell.sci

MACROS =$(MTLB) $(M5)
include ../Make.lib

