%% Frequency response analysis
freq_res = load('freq.mat');

out_mat = zeros([12 4]);
%plotting freq reaponse to test LTI system
for i=1:13
    volt = sprintf('freq_res.F_%dHz(:,2)', i);
    force = sprintf('freq_res.F_%dHz(:,3)', i);
    [maxi, freqi, maxo, freqo] = spectrum(eval(volt),eval(force),i);
    
    % storing data in a mtrix
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
legend('Maximum input', 'Maximum Output');

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
    
    figure(i+2);
    plot(time,current,'b');
    hold on;
    grid on;
    plot(time,force,'g');
    
    [fmax,fmax_i] = max(force);
    f_tau_i = find(force<0.02*fmax & force>0);
    Ts = time(f_tau_i(1))-time(fmax_i);
    tau(i) = Ts/3.91;
     
%     X = time(fmax_i:end);
%     plot(X-X(1),fmax*exp(-(X-X(1))));
    plot(time(fmax_i),fmax,'*');
    plot(time(f_tau_i(1)),force(f_tau_i(1)),'+');
    title(sprintf('Step response analysis for %sA current', c{i}));
    legend('Current','Force','Peak value','Intersection point at Ts');
    
    % K calculation
    k(i) = tau(i)*force(100);
    
end

% s = tf('s');
% sys = k(i)*s/(1+tau(i)*s);
    
