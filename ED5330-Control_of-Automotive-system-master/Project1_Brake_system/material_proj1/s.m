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
    voltage = sprintf('step_res.step_%d(:,2)', i);
    time = sprintf('step_res.step_%d(:,1)', i);
    pressure = sprintf('step_res.step_%d(:,3)', i);
    
    time = step_res.step_5(:,1);
    voltage = step_res.step_5(:,2);
    press = step_res.step_5(:,3);
    figure(2);
    plot(time,voltage,'b');
    hold on;
    grid on;
    plot(time,press,'--g');

    %calculating time delay
    [c,index] = min(abs(0.05-press));
    time_delay=time(index);

    %calculating steady state gain
    ss_gain = mean(press(2000:7000))/mean(voltage(2000:7000));
    % disp(ss_gain);

    %finding time constant
    [c,index] = min(abs(0.6325-press));
    % disp(press(index));
    tau = time(index)-time_delay;
end