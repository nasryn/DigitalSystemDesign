% Binary Frequency Shift Keying (BFSK) function
function BFSK (fd, S, BW, SNR)
% BW defines the bandwidth, 0 = infinite, 1,2,3,... = number of freq components 
% SNR deifnes the signal to noise ratio in dB.  If SNR < 0, no noise
% S is the signaling rate wrt normalized carrier freqency, fc = 1
% Default values of function input parameters
if nargin < 4   SNR = 10;   end
if nargin < 3   BW = 3;  end
if nargin < 2   S = 0.1;  end
if nargin < 1   fd = 0.25; end

N = 2^14;    % total number of data points (power of 2)
i = [0:N-1]; % index for data points
M = 256;     % number of data points per carrier cycle
t = i/M;     % time samples

% Create modulating (baseband) signal of alternating 1/0 pattern
A = sin(pi*S*t);   % sinewave with frequency of 1/2 S
if BW == 0         % infinite BW: use squarewave
    A = A>0;       % create binary signal from sinewave (signaling rate = S)
elseif BW == 1     % use single sinewave with f = S/2
    A = 0.5 + (2/pi)*A; % make signal A unipolar
elseif BW > 1      % use summation of BW sinewaves
    for k = 2:BW
        h = 2*k-1; % used to scale amplitude and frequency for each sinewave
        A = A + (1/h)*sin(pi*h*S*t); % add sinewave with f = S*h/2
    end                               
    A = 0.5 + (2/pi)*A; % make A unipolar
end


% Create B which is an inverse of A
B = 1 - A;

% Create carrier signals
fc = 1;                 % carrier frequency
fc_a = fc + fd;         % carrier frequency for signal A
fc_b = fc - fd;         % carrier frequency for signal B
c = cos(2*pi*fc*t);     % carrier signal
c_a = cos(2*pi*fc_a*t); % carrier signal for signal A
c_b = cos(2*pi*fc_b*t); % carrier signal for signal B


% Modulate carrier with baseband signal
s_a = A.*c_a;                % modulated signal A
s_b = B.*c_b;                % modulated signal B

% Combine modulated signal
s = s_a + s_b;

% Add Gaussian noise, if desired
if SNR >= 0
    swn = s + 0.5*(1/10^(SNR/10))*randn(size(s)); % add Gaussian noise
else
    swn = s; % don't add noise
end 

% Calculate the frequency spectrum of modulated signal with noise
S = fft(swn);          % FFT of modulated signal with noise
f = (i*fc*M)/N;        % Frequency range
S = abs(S);            % Magnitude of spectrum
S = S/max(S);          % Normalized magnitudes


% plot results
subplot(1,1,1); % clear previous plots

subplot(3,2,1); plot(t,c); % plot carrier
axis([xlim -1.5 1.5]);
title('{\bf Carrier Signal}')

subplot(3,2,3); plot(t,A); % plot modulating signal A
axis([xlim -.5 1.5]);
title('{\bf Modulating (Baseband) Signal A}')

subplot(3,2,5); plot(t,B); % plot modulating signal B
axis([xlim -.5 1.5]);
title('{\bf Modulating (Baseband) Signal B}')

subplot(3,2,2); plot(t,s); % plot modulated carrier
axis([xlim -1.5 1.5]);
title('{\bf Modulated Carrier Signal}')

subplot(3,2,4); plot(t,swn); % plot modulated carrier w/noise
axis([xlim -1.5 1.5]);
title('{\bf Modulated Carrier Signal with Gaussian Noise}')

subplot(3,2,6); plot(f,S);   % plot spectrum of modulated carrier
axis([0 2*fc ylim]);
title('{\bf Spectrum of Modulated Signal with Noise}')
xlabel('Frequency')
disp('done');