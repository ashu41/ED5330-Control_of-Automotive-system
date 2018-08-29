freq_res = load('frequency_response_data_final.mat');
step_res = load('step_response_data_final.mat');

%plotting freq reaponse to test LTI system
spectrum(a.F_0_2(:,1),a.F_0_2(:,3))