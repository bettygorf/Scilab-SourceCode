function [min_sp,min_lsp,nsp]=MFAG_net(n,m,lp_norm);

// This Software is ( Copyright INRIA . 1998  1 )
// 
// INRIA  holds all the ownership rights on the Software. 
// The scientific community is asked to use the SOFTWARE 
// in order to test and evaluate it.
// 
// INRIA freely grants the right to use modify the Software,
// integrate it in another Software. 
// Any use or reproduction of this Software to obtain profit or
// for commercial ends being subject to obtaining the prior express
// authorization of INRIA.
// 
// INRIA authorizes any reproduction of this Software.
// 
//    - in limits defined in clauses 9 and 10 of the Berne 
//    agreement for the protection of literary and artistic works 
//    respectively specify in their paragraphs 2 and 3 authorizing 
//    only the reproduction and quoting of works on the condition 
//    that :
// 
//    - "this reproduction does not adversely affect the normal 
//    exploitation of the work or cause any unjustified prejudice
//    to the legitimate interests of the author".
// 
//    - that the quotations given by way of illustration and/or 
//    tuition conform to the proper uses and that it mentions 
//    the source and name of the author if this name features 
//    in the source",
// 
//    - under the condition that this file is included with 
//    any reproduction.
//  
// Any commercial use made without obtaining the prior express 
// agreement of INRIA would therefore constitute a fraudulent
// imitation.
// 
// The Software beeing currently developed, INRIA is assuming no 
// liability, and should not be responsible, in any manner or any
// case, for any direct or indirect dammages sustained by the user.
// 
// Any user of the software shall notify at INRIA any comments 
// concerning the use of the Sofware (e-mail : FracLab@inria.fr)
// 
// This file is part of FracLab, a Fractal Analysis Software



// uses scilab shortest path utilities to find the min of the sum of lp norm

// input: lp_norm is a [n-1,m*m] matrix of lp norm
// output: sp contains the shortest path
//         lsp contains the length of the shortest path
// set n and m
[height,width]=size(lp_norm);
n=height+1;
m=sqrt(width);

// set head and tail nodes row vectors
head_nodes=zeros(1:(n-1)*m*m);
tail_nodes=zeros(1:(n-1)*m*m);
for i=1:n-1
	for j=1:m
		for k=1:m
			head_nodes((i-1)*m*m+(j-1)*m+k)=(i-1)*m+j;
			tail_nodes((i-1)*m*m+(j-1)*m+k)=i*m+k;
		end;
	end;
end;
g=make_graph('lp',1,n*m,head_nodes,tail_nodes);

// set node_x and node_y
g('node_x')=zeros(1:n*m);
g('node_y')=zeros(1:n*m);
for i=1:n
	for j=1:m
	g('node_x')((i-1)*m+j)=100*j;
	g('node_y')((i-1)*m+j)=100*i;
	end;
end;
show_graph(g);

// set lengths
for i=1:n-1
	for j=1:m
		for k=1:m
			len((i-1)*m*m+(j-1)*m+k)=lp_norm(i,(j-1)*m+k);
		end;
	end;
end; 
g('edge_length')=len';

// find shortest paths and shortest path lengths
sp=zeros(m*m,n-1);
lsp=zeros(1:m*m);
for j=1:m
	for k=1:m
		[p,lp]=shortest_path(j,(n-1)*m+k,g,'length');
		sp((j-1)*m+k,:)=p;
		lsp((j-1)*m+k)=lp;
	end;
end;

// find min of shortest path lengths
min_lsp=min(lsp);
min_sp=sp(min(find(lsp==min_lsp)),:)

// plot shortest path
g1=g;
g1('edge_name')=string(g1('edge_length'));
ma=prod(size(g1('head')));
edgecolor=ones(1:ma);
edgecolor(min_sp)=11*ones(min_sp);
g1('edge_color')=edgecolor;
edgefontsize=12*ones(1,ma);
edgefontsize(min_sp)=18*ones(min_sp);
g1('edge_font_size')=edgefontsize;
show_graph(g1);

// shortest path to nodes
nsp=path_2_nodes(min_sp,g); 

// plot nodes
show_nodes(nsp);

// plot arcs
show_arcs(min_sp,'sup')

// return results
return;



