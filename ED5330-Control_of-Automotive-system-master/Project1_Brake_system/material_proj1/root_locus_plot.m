%% root locus plotting function
function root_locus_plot(sys_tf)
% rise time criteria         
i = 1;
for B = 0:((2*pi)/1000):2*pi
    Wd(i,1) = (pi - B)/0.7;        %% Rise Time < 0.7 Condition
    Xd(i,1) = Wd(i,1)/tan(pi-B);  %% THE X-POINTS FOR w_ds
    i = i+1;
end
    
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
line(Xd,Wd,'color','g');
xlim([-50,10]);
ylim([-60,60]);
end