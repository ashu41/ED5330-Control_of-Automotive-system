 function [maxi freqi maxo freqo]= spectrum (ip,op,freq)
N=length(ip);
N1=length(op);
NFFT = 2^nextpow2(N); % Next power of 2 from length of y
Y = fft(ip,NFFT)/N;
f = 1000/2*linspace(0,1,NFFT/2+1);
K=2*abs(Y(1:NFFT/2+1));
NFFT1 = 2^nextpow2(N1); % Next power of 2 from length of y
Y1 = fft(op,NFFT1)/N1;
f1 = 1000/2*linspace(0,1,NFFT1/2+1);
K1=2*abs(Y1(1:NFFT1/2+1));
for (i=1:length(f))
     if f(i)>freq-.5 && f(i)<freq+.5;
           break;
     end
end
%   Input max values
fi=f(i-10:i+50);
Ki=K(i-10:i+50);
maxi = max(Ki);
for(i=1:length(Ki))
    if Ki(i)== maxi;
        break;
    end
end
freqi=fi(i);
%   Output max values
  for (i=1:length(f1))
    
       if f1(i)>freq-.5 && f1(i)<freq+.5;
          break;
      end
end
fo=f1(i-10:i+50);
Ko=K1(i-10:i+50);
maxo = max(Ko);
for(i=1:length(Ko))
    if Ko(i)== maxo;
        break;
    end
end
  freqo=fo(i);
 end
      
   