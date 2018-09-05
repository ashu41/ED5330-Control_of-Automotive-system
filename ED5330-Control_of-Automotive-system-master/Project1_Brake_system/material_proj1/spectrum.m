function [M1,M2] = spectrum (x,y)

%input
N=length(x);
NFFT = 2^nextpow2(N); % Next power of 2 from length of y
Y = fft(x,NFFT)/N;
f = 500/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
K=2*abs(Y(1:NFFT/2+1));

%neglecting very low frequencies
M=length(K);
K=K(4:M);
f=f(4:M);
maxi = max(K);
stem(f,K) 

hold on;

%output
N1=length(y);
NFFT1 = 2^nextpow2(N1); % Next power of 2 from length of y
Y1 = fft(y,NFFT1)/N1;
f1 = 500/2*linspace(0,1,NFFT1/2+1);
K1=2*abs(Y1(1:NFFT1/2+1));

%neglecting very low frequencies
M1=length(K1);
K1=K1(4:M);
M2=length(K1);
f1=f1(4:M);
maxo = max(K1);
disp(maxo);

%to find the magnitude of dominant frequency
 for k=4:length(K)
     k;
     if(K(k)==maxi)
         freqi = f(k);
         disp('entered');
     end
     
     if(K1(k)==maxo)
         freqo= f1(k);
         disp('I was here');
     end
 end
%Plot single-sided amplitude spectrum.
stem(f1,K1 , 'r') 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
legend('input', 'output')
xlim([0.06 1.5])
end