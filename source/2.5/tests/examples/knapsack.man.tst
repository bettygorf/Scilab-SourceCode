clear;lines(0);
weight=ones(1,15).*.[1:4];
profit=ones(1,60);
capa=[15 45 30 60];
[earn,ind]=knapsack(profit,weight,capa)
