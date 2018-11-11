clear all
%initialising variables 
Ms=1250; Mu=150; h1=1; h2=2.2; Iu=200; Is=2000; ksl=50000;
g=9.8182; t=2.5; bsl=3000; ktl=350000; ktr=ktl; ksr=ksl; bsr=bsl; 

Iu1 = Iu+Mu*h1^2;
Is1 = Is+Ms*h2^2;
A21 = -((ksl+ksr+ktl+ktr)*t^2/4-Mu*g*h1)/Iu1;
A22 = -(bsl+bsr)*t^2/(4*Iu1);
A23 = (ksl+ksr)*t^2/(4*Iu1);
A24 = (bsl+bsr)*t^2/(4*Iu1);
A41 = (ksl+ksr)*t^2/(4*Is1);
A42 = (bsl+bsr)*t^2/(4*Is1);
A43 = -((ksl+ksr)*t^2/4-Ms*g*h2)/Is1;
A44 = -(bsl+bsr)*t^2/(4*Is1);

A = [  0   1   0   0;
      A21 A22 A23 A24;
       0   0   0   1;
      A41 A42 A43 A44];

B = [ 0 0; -t/(2*Iu1) t/(2*Iu1); 0 0; t/(2*Is1) -t/(2*Is1)];
l = [ 0; Mu*h1/Iu1; 0; Ms*h2/Is1];

%% LQR controller design
rho = [16 16 40000 16 10^-9 10^-9];

Q = diag([rho(1:4)]);
N = 0;
R = diag([rho(5:6)]);

[K,S,e] = lqr(A,B,Q,R,N);


%% Finding tf for sprung and unsprung mass
A_cl = A-B*K;

L_X = inv(s*eye(4)-A)*l;
L_X_cl = inv(s*eye(4)-A_cl)*l;

tfs = L_X(1);
tfu = L_X(3);

tfs_cl = L_X_cl(1);
tfu_cl = L_X_cl(3);

%% Input Simulation
tsim = (0:0.01:10);

impulse = 5*(tsim==0);
step = 5*heaviside(tsim-5);

imp_res = lsim(closed_loop,impulse,tsim);
step_res = lsim(closed_loop,step,tsim);
