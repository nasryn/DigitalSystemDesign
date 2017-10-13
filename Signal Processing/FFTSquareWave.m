function FFTSquareWave(W,N)
% define input parameters with default values
if nargin < 2  W = 40;   end  % W  = width of pulse 
if nargin < 1  N = 160;  end  % N  = number of simulation samples

%% 
single_t = [0:1:N-1]    % single_t  = time samples
periodic_t  = [0:1:N*10-1] % multi_t   = 10 cycles of N
% generate the square waves
single_pulse = rectpuls(single_t, 2*W); % makes a single pulse of length W
periodic_pulse = square(periodic_t/4/pi); % generate periodic square wave
periodic_pulse(periodic_pulse < 0) = 0; % zero out negative values
%% 


% Plot each square wave
subplot(2,2,1); plot(single_t,single_pulse); ylim([-0.5 1.5]);
xlabel('Sample)')
ylabel('Amplitude')
title('{\bf Square Pulse}')
subplot(2,2,2); plot(periodic_t,periodic_pulse); ylim([-0.5 1.5]); xlim([0 1600]);
xlabel('Sample)')
ylabel('Amplitude')
title('{\bf Periodic Square Pulse}')

% Take the FFT of both square waves
single_n = pow2(nextpow2(length(single_t)));  % n = power of 2 greater than number of samples
periodic_n = pow2(nextpow2(length(periodic_t)));

single_fft = fft(single_pulse,single_n);                   % single_n point FFT of single_pulse
periodic_fft = fft(periodic_pulse,periodic_n);              % periodic_n point FFT of periodic_pulse

single_f = (0:single_n-1)*(1/single_n);             % Frequency range
periodic_f = (0:periodic_n-1)*(1/periodic_n);

single_power = single_fft.*conj(single_fft)/single_n;           % Power of the FFT of single_fft
periodic_power = periodic_fft.*conj(periodic_fft)/periodic_n;

subplot(2,2,3); plot(single_f,single_power);  % Plot frequency spectrum
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Frequency Spectrum}')
subplot(2,2,4); plot(periodic_f,periodic_power);  % Plot frequency spectrum
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Frequency Spectrum}')


