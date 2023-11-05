% Load the transmitted signals with noise
[transmitted_signal_direct_with_noise, ~] = audioread('files/transmitted_signal_direct_with_noise.wav');
[transmitted_signal_hilbert_with_noise, fs] = audioread('files/transmitted_signal_hilbert_with_noise.wav');

% Define the carrier frequency (should match the transmitter)
carrier_freq = 1000;  % 1 kHz
t = (0:(length(transmitted_signal_direct_with_noise) - 1)) / fs;

% Create the carrier signal
carrier = cos(2 * pi * carrier_freq * t);

% Demodulation
received_signal_direct = transmitted_signal_direct_with_noise .* carrier';
received_signal_hilbert = transmitted_signal_hilbert_with_noise .* carrier';

% Apply Adaptive Noise Cancellation (ANC) using dsp.LMSFilter
[total_noise, fs] = audioread('files/total_noise.wav');

% Choose an appropriate ANC algorithm (e.g., LMS)
step_size = 0.01;  % Adjust as needed
filter_length = min(length(total_noise), 32);  % Choose a suitable filter length

% Initialize ANC filters
anc_direct = dsp.LMSFilter('StepSize', step_size, 'Length', filter_length);
anc_hilbert = dsp.LMSFilter('StepSize', step_size, 'Length', filter_length);

% Apply ANC to remove noise
anc_output_direct = anc_direct(received_signal_direct, total_noise);
anc_output_hilbert = anc_hilbert(received_signal_hilbert, total_noise);

% Combine ANC output and demodulated signal
recovered_audio_direct = received_signal_direct - anc_output_direct;
recovered_audio_hilbert = received_signal_hilbert - anc_output_hilbert;

audiowrite('files/recovered_audio_direct.wav', recovered_audio_direct, fs);
audiowrite('files/recovered_audio_hilbert.wav', recovered_audio_hilbert, fs);

% Apply wavelet denoising to the recovered audio signals
denoised_audio_direct = wdenoise(recovered_audio_direct, 4);
denoised_audio_hilbert = wdenoise (recovered_audio_hilbert, 4);

% Visualize the denoised audio signals
figure;
subplot(1,2,1);
plot(recovered_audio_direct);
title('Recovered Audio (Direct Multiplication)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(1, 2, 2);
plot(denoised_audio_direct);
title('Denoised Audio (Direct Multiplication)');
xlabel('Time (s)');
ylabel('Amplitude');

figure;
% Visualize the denoised audio signals from Hilbert transform
subplot(1, 2, 1);
plot(recovered_audio_hilbert);
title('Recovered Audio (Hilbert Transform)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(1,2,2);
plot(denoised_audio_hilbert);
title('Denoised Audio (Hilbert Transform)');
xlabel('Time (s)');
ylabel('Amplitude');

audiowrite('files/denoised_audio_hilbert.wav', denoised_audio_hilbert, fs);
audiowrite('files/denoised_audio_direct.wav', denoised_audio_direct, fs);
