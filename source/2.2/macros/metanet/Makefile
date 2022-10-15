SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = metalib
NAM = metanet

MACROS= %cigra.sci %grae.sci %sigra.sci adj_lists.sci \
	check_graph.sci circuit.sci con_nodes.sci connex.sci find_path.sci \
	graph_2_mat.sci is_connex.sci load_graph.sci make_graph.sci \
	mat_2_graph.sci max_cap_path.sci max_flow.sci metanet.sci \
	min_lcost_cflow.sci min_lcost_flow1.sci min_lcost_flow2.sci \
	min_qcost_flow.sci \
	min_weight_tree.sci nodes_2_path.sci path_2_nodes.sci \
	plot_graph.sci plot_graph1.sci plot_graph2.sci \
	save_graph.sci shortest_path.sci \
	show_arcs.sci show_graph.sci show_nodes.sci \
	strong_con_nodes.sci strong_connex.sci \
	trans_closure.sci	

OBJ = $(MACROS:.sci=.bin)
MACROSN = $(MACROS:.sci=)

all:: $(OBJ) lib

lib: $(OBJ) names
	@echo generating lib and names
	@$(SCIDIR)/bin/scilab -lib $(NAME) SCI/macros/$(NAM)

names: $(OBJ)
	@$(RM) names;touch names;
	@for i in $(MACROSN); do  (echo $$i >> names );done

distclean::
	$(RM) lib names *.bin

.sci.bin:
	@$(SCIDIR)/bin/scilab -comp  $*.sci
