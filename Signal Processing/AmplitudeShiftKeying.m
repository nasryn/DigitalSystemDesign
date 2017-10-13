% Amplitude Shift Keying (ASK) function
function ASK (S, BW, SNR)
% BW defines the bandwidth, 0 = infinite, 1,2,3,... = number of freq components 
% SNR deifnes the signal to noise ratio in dB.  If SNR < 0, no noise
% S is the signaling rate wrt normalized carrier freqency, fc = 1
% Default values of function input parameters
if nargin < 3   SNR = 10;   end
if nargin < 2   BW = 3;  end
if nargin < 1   S = 0.1;  end

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

% Create carrier signal
fc = 1;                 % carrier frequency
c = cos(2*pi*fc*t);     % carrier signal

% Modulate carrier with baseband signal
s = A.*c;                % modulated signal

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

% Calculate the frequency spectrum of the baseband signal
a = fft(A);            % FFT of the baseband signal
a = abs(a);            % Magnitude of spectrum
a = a/max(a);          % Normalized magnitudes

% plot results
subplot(1,1,1); % clear previous plots
subplot(3,1,1); plot(t,c); % plot carrier
axis([xlim -1.5 1.5]);
title('{\bf Carrier Signal}')
disp('next...'); pause;
subplot(3,1,2); plot(t,A); % plot modulating signal
axis([xlim -.5 1.5]);
title('{\bf Modulating (Baseband) Signal}')
disp('next...'); pause;
subplot(3,1,3); plot(t,s); % plot modulated carrier
axis([xlim -1.5 1.5]);
title('{\bf Modulated Carrier Signal}')
disp('next...'); pause;

subplot(1,1,1); % clear previous plots
subplot(3,1,1); plot(t,swn); % plot modulated carrier w/noise
axis([xlim -1.5 1.5]);
title('{\bf Modulated Carrier Signal with Gaussian Noise}')
disp('next...'); pause;
subplot(3,1,2); plot(f,a);   % plot spectrum of baseband signal
axis([0 2*fc ylim]);
title('{\bf Spectrum of Baseband Signal}')
xlabel('Frequency')
disp('next...'); pause;
subplot(3,1,3); plot(f,S);   % plot spectrum of modulated carrier
axis([0 2*fc ylim]);
title('{\bf Spectrum of Modulated Signal}')
xlabel('Frequency')
disp('done');