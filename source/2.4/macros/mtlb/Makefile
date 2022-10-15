SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME=mtlblib
NAM=mtlb

MTLB = mtlb_e.sci mtlb_fft.sci  mtlb_max.sci mtlb_min.sci mtlb_filter.sci\
	mtlb_ones.sci mtlb_zeros.sci mtlb_eye.sci mtlb_rand.sci \
	mtlb_plot.sci mtlb_loglog.sci mtlb_choices.sci\
	mtlb_length.sci mtlb_subplot.sci mtlb_get.sci mtlb_sum.sci \
	mtlb_cumsum.sci mtlb_ifft.sci\
	mtlb_exist.sci mtlb_mean.sci mtlb_qz.sci mtlb_find.sci\
	%s_m_b.sci %b_m_s.sci %s_x_b.sci %b_x_s.sci %b_g_s.sci %b_h_s.sci \
	%s_a_b.sci %b_a_s.sci %s_s_b.sci %b_s_s.sci \
	%b_c_s.sci %b_f_s.sci %s_c_b.sci %s_f_b.sci %s_g_b.sci %s_h_b.sci

M5 = mtlb_cell.sci

MACROS =$(MTLB) $(M5)
include ../Make.lib

