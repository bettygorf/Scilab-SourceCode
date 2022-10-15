function [S]=sqroot(Q)
Q1=(Q+Q')/2;
if norm(q1-Q,1) > 100*%eps then warning('sqroot: input not symmetric!');end
tt=mini(spec(Q1));
if tt <-10*%eps then warning('sqroot: input not semi-definite positive!');end
if norm(Q,1) < sqrt(%eps) then S=[];return;end
[u,s,v,rk]=svd(Q);
S=v(:,1:rk)*sqrt(s(1:rk,1:rk));S=real(S);

