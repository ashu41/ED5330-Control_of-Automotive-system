%% Writing Quater car model equations and finding transfern functions
clear all
% 
Ms=300; Mu=50; 
ks=15000;
kt=150000; 
bs =900;
s = tf('s');

%to be usedo only once for getting tf for report
% syms ks Ms bs Mu kt s

A = [0,1,0,-1;
    -ks/Ms,-bs/Ms,0,bs/Ms;
    0,0,0,1;
    ks/Mu,bs/Mu,-kt/Mu,-bs/Mu];
B = [0;1/Ms;0;-1/Ms];
l = [0;0;-1;0];

L_X = inv(s*eye(4)-A)*l;

tf_a = s*L_X(2);
tf_r = L_X(1);
tf_t = L_X(3);
% 
% tf_a_2 = s*L_X(2);
% tf_r_2 = L_X(1);
% tf_t_2 = L_X(3);
%  
% tf_a_3 = s*L_X(2);
% tf_r_3 = L_X(1);
% tf_t_3 = L_X(3);

%% Finding natural frequencies

M = [Ms 0; 0 Mu];
K = [ks -ks;-ks ks+kt];
P = [0 -1];
syms omega
eqn = det(M*omega^2-K) == 0;
omega_n = double(solve(eqn));

%deleting negative values
omega_n(3) = [];
omega_n(3) = [];

%% Bode plot part 2b

w1_range = omega_n(1)/20:omega_n(2)*20;

figure(1);
bode(tf_a, tf_r, tf_t, w1_range);
legend('Acceleration tf','Rattle space tf','Tyre deflection tf');
saveas(gcf,'plots/Part2b_bode.png');
%% bode plot part 2c,d,e
figure(1);
bode(tf_a, tf_a_2, tf_a_3, w1_range);
title('Effect of suspension damping on Acceleration')
legend('bs=900','bs=600','bs=1200');
saveas(gcf,'plots/Part2d_bode_acc.png');

figure(2);
bode(tf_r, tf_r_2, tf_r_3, w1_range);
title('Effect of suspension damping on Rattle space')
legend('bs=900','bs=600','bs=1200');
saveas(gcf,'plots/Part2d_bode_rattle.png');

figure(3);
bode(tf_t, tf_t_2, tf_t_3, w1_range);
title('Effect of suspension damping on Tyre deflection')
legend('bs=900','bs=600','bs=1200');
saveas(gcf,'plots/Part2d_bode_tyre.png');

%% LQR controller derivation and tuning

%rho = [0.2 0.1 0.2 0.1];
% rho = [20000 100 20000 100];
rho = [200 10 200 10];

Q = [rho(1)+(ks/Ms)^2  bs*ks/Ms^2    0   -bs*ks/Ms^2;
     bs*ks/Ms^2     rho(2)+(bs/Ms)^2 0   -(bs/Ms)^2;
         0                0         rho(3)    0    ;
    -bs*ks/Ms^2        -(bs/Ms)^2    0    rho(4)+(bs/Ms)^2];

N = [ -ks/Ms^2; -bs/Ms^2; 0; bs/Ms^2];
R = 1/Ms^2;

[K,S,e] = lqr(A,B,Q,R,N);

%% finding closed loop tf
A_cl = A-B*K;
L_X_cl = inv(s*eye(4)-A_cl)*l;

tf_a_cl = s*L_X_cl(2);
tf_r_cl = L_X_cl(1);
tf_t_cl = L_X_cl(3);

figure(1);
bode(tf_a, tf_a_cl);
title('Bode plot for Acceleration transfer function'); 
legend('open loop','closed loop');
saveas(gcf,'plots/Part3biii_bode_acc.png');

figure(2);
bode(tf_r, tf_r_cl);
title('Bode plot for Rattle Space transfer function');
legend('open loop','closed loop');
saveas(gcf,'plots/Part3biii_bode_rattle.png');

figure(3);
bode(tf_t, tf_t_cl);
title('Bode plot for Tyre Deflection transfer function');
legend('open loop','closed loop');
saveas(gcf,'plots/Part3biii_bode_tyre.png');
