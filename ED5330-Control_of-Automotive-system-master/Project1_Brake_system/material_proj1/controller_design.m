%% proportional controller controller
s=tf('s');
K=0.9001; Td=0.0530; tau=0.4480; K_p=1;

P_s =  K *(2 - Td * s) / ((1 + (tau * s)) * (2 + Td * s));

I=1; D=1; %tweak this for P, PI,PD or PID
C_s = K_p*(1+I/(tau*s)+(D*0.001*s));

open_loop = P_s*C_s;

root_locus_plot(open_loop);

%% Optimizing for steady state error with controller gains from rlocus plot


 for h=5:8
     i=0;
    for K_p=3.2:0.1:6.5   %done for PID controller
        i=i+1;
        C_s = K_p*(1+1/(tau*s)+(0.001*s));
        closed_loop = P_s*C_s/(1+P_s*C_s); 
        step_in = stepDataOptions('InputOffset',0,'StepAmplitude',h);
        sim_step_res = step(closed_loop,0:0.002:7,step_in);
        
        ERROR(i,h-4) = sim_step_res(end)-h;
        
    end
       
        plot(0:0.002:7,sim_step_res,'g'); hold on;
        plot(0:0.002:7,step_in,'--b');hold on;
 end

%% plotting system final response
K_p = 6.15; K_i=14.0625; K_d=0;
C_s = K_p+K_i/s+K_d*s;

closed_loop = P_s*C_s/(1+P_s*C_s); 

step_in = stepDataOptions('InputOffset',0,'StepAmplitude',5);
sim_step_res = step(closed_loop,0:0.002:7,step_in);

plot(0:0.002:7,sim_step_res,'g','LineWidth', 1.5); hold on;
plot(0:0.002:7,step_in,'--b');hold on;