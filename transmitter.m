% Load the quantized audio signal
[y_digital, fs] = audioread('files/audio_signal_int16.wav');

% Define the carrier frequency
carrier_freq = 1000;  % 1 kHz
t = (0:(length(y_digital) - 1)) / fs;

% Create the carrier signal
carrier = cos(2 * pi * carrier_freq * t);

% 1. Direct Multiplication
transmitted_signal_direct = y_digital' .* carrier;

% 2. Using Hilbert Transform
hilbert_transform = imag(hilbert(carrier));
transmitted_signal_hilbert = y_digital' .* hilbert_transform;

% Add Gaussian Noise
SNR_dB = 20;  % Signal-to-Noise Ratio in dB
noise_power = 10^(-SNR_dB / 10);
gaussian_noise = randn(size(transmitted_signal_direct)) * sqrt(noise_power);

% Add Impulse Noise
impulse_noise = zeros(size(transmitted_signal_direct));
impulse_indices = randperm(length(impulse_noise), round(0.01 * length(impulse_noise)));
impulse_noise(impulse_indices) = 1;

% Combine Gaussian and Impulse Noise
total_noise = gaussian_noise + impulse_noise;
audiowrite("files/total_noise.wav",total_noise,fs);

% Add Total Noise to Transmitted Signals
transmitted_signal_direct_with_noise = transmitted_signal_direct + total_noise;
transmitted_signal_hilbert_with_noise = transmitted_signal_hilbert + total_noise;


% Plot frequency spectra
n = length(y_digital);
f = (-fs/2):(fs/n):(fs/2 - fs/n);  % Frequency vector covering both positive and negative frequencies

% Compute FFT of the transmitted signals
fft_direct = fft(transmitted_signal_direct, n);
fft_hilbert = fft(transmitted_signal_hilbert, n);

% Plot magnitude spectra
figure;
subplot(2, 1, 1);
plot(f, abs(fft_direct));
title('Frequency Spectrum - Direct Multiplication');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f, abs(fft_hilbert));
title('Frequency Spectrum - Hilbert Transform');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Save the transmitted signals with noise as WAV files
audiowrite('files/transmitted_signal_direct_with_noise.wav', transmitted_signal_direct_with_noise, fs);
audiowrite('files/transmitted_signal_hilbert_with_noise.wav', transmitted_signal_hilbert_with_noise, fs);

