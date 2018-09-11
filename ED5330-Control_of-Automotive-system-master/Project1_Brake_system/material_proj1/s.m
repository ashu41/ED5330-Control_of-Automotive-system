%% Finding max of input and output dominant frequency
freq_res = load('frequency_response_data_final.mat');
step_res = load('step_response_data_final.mat');

out_mat = zeros([12 4]);
%plotting freq reaponse to test LTI system
for i=1:12
    if i<=9
        volt = sprintf('freq_res.F_0_%d(:,2)', i);
        press = sprintf('freq_res.F_0_%d(:,3)', i);
        [maxi, maxo, freqi, freqo] = spectrum(eval(volt),eval(press));
    else
        volt = sprintf('freq_res.F_1_%d(:,2)', i-10);
        press = sprintf('freq_res.F_1_%d(:,3)', i-10);
        [maxi, maxo, freqi, freqo] = spectrum(eval(volt),eval(press));
    end
% storing data in a mtrix
    out_mat(i,1) = maxi;
    out_mat(i,2) = maxo;    
    out_mat(i,3) = freqi;
    out_mat(i,4) = freqo;
    out_mat(i,5) = -20*log10(maxi/maxo);
    
end
out_mat(10,:)=[]; 

%% Bode plot and slope calculation

x = log10(out_mat(:,3));
y = out_mat(:,5);

plot(x,y,'g');
hold on;
grid on;

%Curve fitting
linearCoefficients = polyfit(x(1:3), y(1:3), 1);
xFit = linspace(x(1), x(3), 500);
yFit = polyval(linearCoefficients, xFit);
plot(xFit, yFit, 'b', 'LineWidth', 1);
hold on;
slope_l1= (yFit(3)-yFit(1))/(xFit(3)-xFit(1));
disp(slope_l1);

linearCoefficients = polyfit(x(4:11), y(4:11), 1);
xFit = linspace(x(4), x(11), 500);
yFit = polyval(linearCoefficients, xFit);
plot(xFit, yFit, 'b', 'LineWidth', 1);
legend('Bode Plot', 'Fit line', 'Location', 'Northeast');
slope_l2= (yFit(11)-yFit(4))/(xFit(11)-xFit(4));
disp(slope_l2);

%% Step response analysis
step_res = load('step_response_data_final.mat');

for i=5:8
    voltage = eval(sprintf('step_res.step_%d(:,2)', i));
    time = eval(sprintf('step_res.step_%d(:,1)', i));
    press = eval(sprintf('step_res.step_%d(:,3)', i));
    
    figure(2);
    plot(time,voltage,'b');
    hold on;
    grid on;
    plot(time,press,'--g');

    %calculating time delay
    [c,Td_index(i-4)] = min(abs(0.05-press));
    t_delay(i-4) = time(Td_index(i-4))-time(1);

    %calculating steady state gain
    ss_gain(i-4) = mean(press(2000:7000))/mean(voltage(2000:7000));
    % disp(ss_gain);

    %finding time constant
    [c,index] = min(abs(0.6325-press));
    % disp(press(index));
    tau(i-4) = time(index)-t_delay(i-4)-time(1);
end
Td = mean(t_delay);
gain = mean(ss_gain);

%% time constant using simulated step response
s = tf('s');
h=5;
c=1;
step_in = stepDataOptions('InputOffset',0,'StepAmplitude',h);
time = eval(sprintf('step_res.step_%d(:,1)', h));
press = eval(sprintf('step_res.step_%d(:,3)', h));

for tau_d = min(tau)%:0.002:max(tau)
    sum=0;
    sys = gain*(2-Td*s)/((1+tau_d*s)*(2+Td*s));
    sim_step_res = step(sys,[0:0.002:12],step_in);
    for t = time(Td_index(h-4))-10.5:0.002:12
        sum = sum+(sim_step_res(Td_index(1))-press(Td_index(1)))/press(Td_index(1));
    end
    MEAP(c) = sum*100/length(t);
    c=c+1;
end