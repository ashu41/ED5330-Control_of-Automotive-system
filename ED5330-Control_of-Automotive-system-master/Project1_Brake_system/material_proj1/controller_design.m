% proportional controller controller
s=tf('s');
K=0.9001; Td=0.0530; tau=0.4480; K_p=1;

P_s =  K *(2 - Td * s) / ((1 + (tau * s)) * (2 + Td * s));

I=1; D=1; %tweak this for P, PI,PD or PID
C_s = K_p*(1+I/(tau*s)+(D*0.001*s));

open_loop = P_s*C_s;
closed_loop = open_loop/(1+open_loop);

root_locus_plot(open_loop);