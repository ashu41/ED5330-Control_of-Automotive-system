freq_res = load('frequency_response_data_final.mat');
step_res = load('step_response_data_final.mat');


out_mat = zeros([12 4]);
%plotting freq reaponse to test LTI system
for i=1:12
    if i<=9
        volt = sprintf('freq_res.F_0_%d(:,2)', i);
        press = sprintf('freq_res.F_0_%d(:,3)', i);
        [maxi, maxo, freqi, freqo] = spectrum(eval(volt),eval(press));
    elseif i>10
        volt = sprintf('freq_res.F_1_%d(:,2)', i-10);
        press = sprintf('freq_res.F_1_%d(:,3)', i-10);
        [maxi, maxo, freqi, freqo] = spectrum(eval(volt),eval(press));
    elseif i==10
        [maxi, maxo, freqi, freqo] = spectrum(freq_res.F_1_0(:,3),freq_res.F_1_0(:,3));
    end

%     out_mat(i,1) = maxi;
%     out_mat(i,2) = maxo;    
%     out_mat(i,3) = freqi;
%     out_mat(i,4) = freqo;
    
end