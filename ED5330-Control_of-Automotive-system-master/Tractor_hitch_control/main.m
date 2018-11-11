clear all;
%% Frequency response analysis
freq_res = load('freq.mat');

out_mat = zeros([12 4]);
%plotting freq reaponse to test LTI system    % storing data in a mtrix

for i=1:13
    volt = sprintf('freq_res.F_%dHz(:,2)', i);
    force = sprintf('freq_res.F_%dHz(:,3)', i);
    [maxi, freqi, maxo, freqo] = spectrum(eval(volt),eval(force),i);
    
    out_mat(i,1) = maxi;
    out_mat(i,2) = maxo;    
    out_mat(i,3) = freqi;
    out_mat(i,4) = freqo;
    out_mat(i,5) = -20*log10(maxi/maxo);  %gain
    % csvwrite('dom_freq_mat.csv',out_mat);
end

stem(out_mat(:,3),out_mat(:,1),'r');
hold on;
stem(out_mat(:,4),out_mat(:,2),'b');
title('Stem plot of Maximum value vs frequency');
legend('Maximum input current', 'Maximum Output flow');

%% Bode plot and slope calculation

x = log10(out_mat(:,3));
y = out_mat(:,5);

figure(2);
plot(x,y,'g');
hold on;
grid on;

%Curve fitting
linearCoefficients = polyfit(x(5:13), y(5:13), 1);
xFit = linspace(x(5), x(13), 500);
yFit = polyval(linearCoefficients, xFit);
plot(xFit, yFit, 'b');
set(gca, 'xticklabel', []);
title('Bode plot and slope estimation');
legend('Bode plot','Polyfit curve');
hold on;
slope = (yFit(13)-yFit(5))/(xFit(13)-xFit(5));
disp(slope);

%% Step response analysis
step_res = load('time.mat');
c= {'2','2_5','3','3_3'};

for i=1:4
    current = eval(sprintf('step_res.Step_%s(:,2)', c{i}));
    time = eval(sprintf('step_res.Step_%s(:,1)', c{i}));
    force = eval(sprintf('step_res.Step_%s(:,3)', c{i}));
    
    figure(3);
    subplot(2,2,i);
    plot(time,current,'b');
    hold on;
    grid on;
    plot(time,force,'g');
    
    [fmax,fmax_i] = max(force);
    f_tau_i = find(force<0.02*fmax & force>0);
    Ts = time(f_tau_i(1))-time(fmax_i);
    tau(i) = Ts/4;
     
    X = time(fmax_i:end);
    plot((X),fmax*exp(-(X-X(1))/tau(i)));
    plot(time(fmax_i),fmax,'+');
    plot(time(f_tau_i(1)),force(f_tau_i(1)),'*');
    title(sprintf('Step response analysis for %sA current', c{i}));
    legend('Input current','Experimental','Theoretical','Peak value','Intersection point at Ts');
    
    % K calculation
    k(i) = tau(i)*force(100)/current(end);

% Controller parameter calculation and bode plot
    s = tf('s');
    Ps(i) = k(i)*s/(1+tau(i)*s);
    figure(4);
    subplot(2,2,i);
    bode(Ps(i)), grid;
    title(sprintf('Bode plot for %sA current', c{i}));
    [mag,phase,wout] = bode(Ps(i));
    Kc(i) =1/mag(end);
end

%% noise modelling
tsim =  0:0.01:14;
sin1 = sin(tsim*pi/2).*(heaviside(tsim)-heaviside(tsim-4));
sin2 = sin(tsim*pi*2).*(heaviside(tsim-5)-heaviside(tsim-9));

Dt = 2500*(sin1 + sin2 + heaviside(tsim-12)+ (tsim-10).*(heaviside(tsim-10)-heaviside(tsim-11)));
plot(tsim,Dt);
%% Controller design

Tc = 1/(2*pi);
beta = 1/(Tc*10*pi); 
Kc_i = digits(7);

Kc_initial = [0.00126757,0.00125287,0.0012364,0.00123238];

for i =1:4
    for Kc_i = Kc_initial(i)%:-0.00000001:0

        Cs = Kc_i*beta*(Tc*s+1)/(beta*Tc*s+1);
        D_tf = Cs/(1+Cs*Ps(i));
        Sys_tf = (Ps(i)*Cs)/(1+Cs*Ps(i));
        Ut = lsim(D_tf,Dt,tsim);
        Yt = lsim(Sys_tf,Dt,tsim);

        figure(5);  
        
        plot(tsim,Dt,tsim,Ut,'r',tsim,Yt,'g');
        legend('disturbance','controller output','System output');
        attenuation(i) = ((max(Dt)-max(Yt))/max(Dt))*100;
        
        if max(Ut)<2.3
            Kc_op(i) = vpa(Kc_i);
             disp(max(Ut));
            break;
        end
    end
end

csvwrite('Optimised_Kc.csv', vpa(Kc_op));

