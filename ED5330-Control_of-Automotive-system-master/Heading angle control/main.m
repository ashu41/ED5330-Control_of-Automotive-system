clear all
%% initialising varialbles
V0 = 2.5; %m/s
l = 2;
m = 1000;
g = 9.81;
J = 960;
Cf = 35973;
Cr = 53959;
a = 1.2;
b = l-a;
s_freq = [1,2,5];

%% defining equations
s = tf('s');
Ps =(45*s+1620)/(s^3+72*s^2+1295*s);
Gs = 604/(0.044*s^2+9.164*s+604);
Ps_n = Ps*Gs;
% 
% figure(1);
% bode(Ps); grid;
%% input function definitions
tsim = (0:0.01:10);

impulse = 20*(tsim==0);

step = deg2rad(20)*heaviside(tsim-5);
% plot(tsim,[impulse,step,sinus]);

%% simulating system response
% 
% Yt_im = lsim(Ps,impulse,tsim);
% plot(tsim,[Yt_im,impulse]);
% axis([-0.5 0.5 0 22]);
% 
% Yt_st = lsim(Ps,step,tsim);
% plot(tsim,[Yt_st,step]);
% axis([-1 10 0 250]);
% 
% figure(2);
% for i = 1:3
%     sinus = 20*sin(s_freq(i)*tsim);
%     Yt_sin = lsim(Ps,sinus,tsim);
%     subplot(3,1,i);
%     plot(tsim,[Yt_sin,sinus]);
% 
% end
%% controller design
K_p = 11; K_i = 0.01*K_p;

Cs = K_p + (K_i/s);

Ps=Ps_n;
step = deg2rad(20)*heaviside(tsim-5);
open_loop = Ps*Cs;

% figure(3);
% root_locus_plot(open_loop);

closed_loop = (Ps*Cs)/(1+Ps*Cs);

step_res = lsim(closed_loop,step,tsim);
[value,index] = min(abs(step_res-0.35));
rise_time = index*0.01-5;
[v,i] = max(step_res);
disp(100*(step_res(i)-0.35)/0.35);
disp(rise_time);
figure(4);
plot(tsim,step); hold on;
plot(tsim,step_res); hold on;