// adj_lists
ta=[2 3 3 5 3 4 4 5 8];
he=[1 2 4 2 6 6 7 7 4];
gt=make_graph('foo',1,8,ta,he);
[lp,la,ls]=adj_lists(1,gt('node_number'),ta,he)

// circuit
g=make_graph('foo',1,3,[1 2 3],[2 3 1]);
circuit(g)
g=make_graph('foo',1,4,[1 2 2 3],[2 3 4 4]);
[p,r]=circuit(g)

// con_nodes
ta=[1 1 2 2 2 3 4 4 5 7 7 9 10 12 12 13 13 14 15];
he=[2 6 3 4 5 1 3 5 1 8 9 8 11 10 11 11 15 13 14];
gt=make_graph('foo',1,15,ta,he);
con_nodes(2,gt)

// connex
ta=[1 1 2 2 2 3 4 4 5 6 7 7 7 8 9 10 12 12 13 13 14 15];
he=[2 6 3 4 5 1 3 5 1 7 5 8 9 5 8 11 10 11 11 15 13 14];
gt=make_graph('foo',1,15,ta,he);
[nc,ncomp]=connex(gt)

// find_path
ta=[1 1 2 2 2 3 4 5 5 7 8 8 9 10 10 10 11 12 13 13 13 14 15 16 16 17 17];
he=[2 10 3 5 7 4 2 4 6 8 6 9 7 7 11 15 12 13 9 10 14 11 16 1 17 14 15];
gt=make_graph('foo',1,17,ta,he);
p=find_path(1,14,gt)

// is_connex
g=make_graph('foo',1,3,[1,2,3,1],[2,3,1,3]);
is_connex(g)
g=make_graph('foo',1,4,[1,2,3,1],[2,3,1,3]);
is_connex(g)

// mat_2_graph
g=load_graph(SCI+'/demos/metanet/colored');
a=graph_2_mat(g)
g1=mat_2_graph(a,1)

// max_cap_path
ta=[1 1 2 2 2 3 4 5 5 7 8 8 9 10 10 10 11 12 13 13 13 14 15 16 16 17 17];
he=[2 10 3 5 7 4 2 4 6 8 6 9 7 7 11 15 12 13 9 10 14 11 16 1 17 14 15];
gt=make_graph('foo',1,17,ta,he);
ma=gt('edge_number');
gt('edge_max_cap')=[8 17 5 10 15 15 18 15 19 6 13 15 16 8 13 8 8 8 19 15 9 19 8 10 10 9 14];
[p,cap]=max_cap_path(1,14,gt)

// max_flow
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15 14 9 11 10];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14 4 6 9 1];
gt=make_graph('foo',1,15,ta,he);
g1=gt; ma=g1('edge_number');
g1('edge_min_cap')=0*ones(1,ma);
rand('uniform');
g1('edge_max_cap')=[10.7 7.6 12.9 11.0 9.7 6.4 13.7 9.1 19.4 1.9 10.6 6.3 9.3 6.6 3.6 16.6 5.2 3.2 14.7 4.1 14.9 17.8 9.1 9.2 18.6 3.3 5.0 12.2 12.8];
[v,phi]=max_flow(15,1,g1)

// min_lcost_cflow
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15 14 9 11 10];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14 4 6 9 1];
gt=make_graph('foo',1,15,ta,he);
g1=gt;ma=g1('arc_number');
g1('edge_min_cap')=0*ones(1,ma);
g1('edge_max_cap')=[15 8 16 6 9 7 19 4 14 7 17 10 12 6 9 10 9 14 6 17 14 8 8 15 17 18 16 8 16];
g1('edge_cost')=[10.7 3.6 8.4 9.3 7.6 10.7 4.9 6.8 2.3 6.0 5.5 3.0 5.0 1.9 2.6 6.1 7.4 2.3 9.2 10.8 3.2 4.4 8.9 2.8 3.9 8.2 4.0 9.8 2.1];
cv=5;
[c,phi,v,flag]=min_lcost_cflow(15,1,cv,g1)

// min_lcost_flow1
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15 14 9 11 10 1 8];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14 4 6 9 1 12 14];
gt=make_graph('foo',1,15,ta,he);
g1=gt;ma=g1('arc_number');
g1('edge_min_cap')=[17 11 10 5 2 5 16 3 20 15 11 4 6 5 5 3 2 8 0 4 14 1 11 14 13 17 3 3 20 2 17];
g1('edge_max_cap')=[37 36 37 25 26 42 35 23 56 52 43 40 42 26 42 33 24 27 34 23 45 29 49 48 45 42 25 24 56 34 45];
g1('edge_cost')=[8 7 3 2 6 10 6 3 5 10 7 11 2 8 1 2 2 4 8 4 4 4 6 8 9 7 5 11 8 2 8];
[c,phi,flag]=min_lcost_flow1(g1)

// min_lcost_flow2
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15 14 9 11 10 1 8];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14 4 6 9 1 12 14];
gt=make_graph('foo',1,15,ta,he);
g1=gt;ma=g1('arc_number');
g1('edge_min_cap')=0.*ones(1,ma);
n=g1('node_number');
g1('edge_max_cap')=[32 19 15 33 32 27 32 32 27 27 34 21 18 33 24 32 15 18 19 30 34 24 25 22 17 29 15 27 15 27 29];
g1('edge_cost')=[2 11 5 2 5 7 8 8 4 5 2 4 2 7 10 2 10 8 8 4 4 6 5 5 7 8 7 6 7 6 5];
dd=[14 -20 -4 8 -3 16 5 -23 0 7 -5 16 4 -24 9];
g1('node_demand')=dd;
[c,phi,flag]=min_lcost_flow2(g1)

// min_qcost_flow
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15 14 9 11 10 1 8];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14 4 6 9 1 12 14];
gt=make_graph('foo',1,15,ta,he);
g1=gt;ma=g1('arc_number');
g1('edge_min_cap')=[3 4 3 0 2 4 1 4 2 0 1 1 4 4 4 1 3 4 1 3 0 3 0 3 1 1 0 2 0 3 5];
g1('edge_max_cap')=[19 9 15 6 16 16 20 22 12 16 13 16 23 16 14 7 15 21 4 15 8 24 2 10 4 4 20 14 11 18 9];
g1('edge_q_orig')=0*ones(1,ma);
g1('edge_q_weight')=ones(1,ma);
[c,phi,flag]=min_qcost_flow(0.2,g1)

// min_weight_tree
ta=[1 1 2 2 2 3 4 5 5 7 8 8 9 10 10 10 11 12 13 13 13 14 15 16 16 17 17];
he=[2 10 3 5 7 4 2 4 6 8 6 9 7 7 11 15 12 13 9 10 14 11 16 1 17 14 15];
gt=make_graph('foo',1,17,ta,he);
t=min_weight_tree(1,gt)

// nodes_2_path
ta=[1 1 2 2 2 3 4 5 5 7 8 8 9 10 10 10 11 12 13 13 13 14 15 16 16 17 17];
he=[2 10 3 5 7 4 2 4 6 8 6 9 7 7 11 15 12 13 9 10 14 11 16 1 17 14 15];
gt=make_graph('foo',1,17,ta,he);
ns=[1 10 15 16 17 14 11 12 13 9 7 8 6];
p=nodes_2_path(ns,gt)

// path_2_nodes
ta=[1 1 2 2 2 3 4 5 5 7 8 8 9 10 10 10 11 12 13 13 13 14 15 16 16 17 17];
he=[2 10 3 5 7 4 2 4 6 8 6 9 7 7 11 15 12 13 9 10 14 11 16 1 17 14 15];
gt=make_graph('foo',1,17,ta,he);
p=[2 16 23 25 26 22 17 18 19 13 10 11];
ns=path_2_nodes(p,gt)

// shortest_path
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15 14 9 11 10];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14 4 6 9 1];
gt=make_graph('foo',1,15,ta,he);
g1=gt;ma=prod(size(g1('head')));
g1('edge_length')=[13 17 10 6 7 18 18 6 7 14 5 9 5 10 10 2 4 12 15 0 13 4 7 16 11 9 4 16 2];
[p,lp]=shortest_path(13,1,g1,'length')

// strong_con_nodes
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14];
gt=make_graph('foo',1,15,ta,he);
ncomp=strong_con_nodes(3,gt)

// strong_connex
ta=[1 1 2 2 2 3 4 4 5 6 6 6 7 7 7 8 9 10 12 12 13 13 13 14 15];
he=[2 6 3 4 5 1 3 5 1 7 10 11 5 8 9 5 8 11 10 11 9 11 15 13 14];
gt=make_graph('foo',1,15,ta,he);
[nc,ncomp]=strong_connex(gt)

// trans_closure
ta=[2 3 3 5 3 4 4 5 8];
he=[1 2 4 2 6 6 7 7 4];
gt=make_graph('foo',1,8,ta,he);
g1=trans_closure(gt)
