%% Writing Quater car model equations and finding transfern functions
% clear all

Ms=300; Mu=50; 
ks=15000;
kt=150000; 
bs =900;
s = tf('s');

%to be usedo only once for getting tf for report
%syms ks Ms bs Mu kt s

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

w1_range = omega_n(1)/20:omega_n(1)*20;
w2_range = omega_n(2)/20:omega_n(2)*20;

figure(1);
bode(tf_a, tf_r, tf_t, w1_range);
legend('Acceleration tf','Rattle space tf','Tyre deflection tf');
saveas(gcf,'plots/Part2b_bode1.png');
figure(2);
bode(tf_a, tf_r, tf_t, w2_range);
legend('Acceleration tf','Rattle space tf','Tyre deflection tf');
saveas(gcf,'plots/Part2b_bode2.png');

%% bode plot part 2c,d,e
bode(tf_a, tf_a_2, tf_a_3, w1_range);
title('Effect of suspension damping on Acceleration')
legend('bs=900','bs=600','bs=1200');
saveas(gcf,'plots/Part2d_bode_acc.png');

bode(tf_r, tf_r_2, tf_r_3, w1_range);
title('Effect of suspension damping on Rattle space')
legend('bs=900','bs=600','bs=1200');
saveas(gcf,'plots/Part2d_bode_rattle.png');

bode(tf_t, tf_t_2, tf_t_3, w1_range);
title('Effect of suspension damping on Tyre deflection')
legend('bs=900','bs=600','bs=1200');
saveas(gcf,'plots/Part2d_bode_tyre.png');

%%