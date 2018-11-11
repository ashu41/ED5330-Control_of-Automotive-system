%% root locus plotting function
function root_locus_plot(sys_tf)
% rise time criteria         
i = 1;

% peak overshoot criteria
x      = -70:(70/1000):0;
zeta   = 0.59115;           %% FROM CALCULATIONS
Beta   = acos(zeta);        %% M.P < 10% CONDITION is Beta < acos(zeta)
l1   =  tan(Beta).* x;    %% FOR PLOTTING THE UPPER BOUND
l2 = -tan(Beta).* x;    %% FOR PLOTTING THE LOWER BOUND


rlocus(sys_tf);
hold on;
line(x,l1,'color','b'); 
hold on;
line(x,l2,'color','b'); 
hold on;
% xlim([-50,10]);
% ylim([-60,60]);
end