% Load the original quantized audio signal
[y_digital, fs] = audioread('files/audio_signal_int16.wav');

% Load the recovered audio signals
[recovered_audio_direct, ~] = audioread('files/recovered_audio_direct.wav');
[recovered_audio_hilbert, ~] = audioread('files/recovered_audio_hilbert.wav');

% Load the denoised audio signals
[denoised_audio_direct, ~] = audioread('files/denoised_audio_direct.wav');
[denoised_audio_hilbert, ~] = audioread('files/denoised_audio_hilbert.wav');

snr_original_vs_recovered_direct = snr(y_digital, recovered_audio_direct);
snr_original_vs_recovered_hilbert = snr(y_digital, recovered_audio_hilbert);
snr_original_vs_denoised_direct = snr(y_digital, denoised_audio_direct);
snr_original_vs_denoised_hilbert = snr(y_digital, denoised_audio_hilbert);

fprintf('SNR for Original vs Recovered (Direct Multiplication): %.2f dB\n', snr_original_vs_recovered_direct);
fprintf('SNR for Original vs Recovered (Hilbert Transform): %.2f dB\n', snr_original_vs_recovered_hilbert);
fprintf('SNR for Original vs Denoised (Direct Multiplication): %.2f dB\n', snr_original_vs_denoised_direct);
fprintf('SNR for Original vs Denoised (Hilbert Transform): %.2f dB\n', snr_original_vs_denoised_hilbert);

% Plot the frequency spectra
n = length(y_digital);
f = (-fs/2):(fs/n):(fs/2 - fs/n);

% Compute FFT of the audio signals
fft_original = fft(y_digital, n);
fft_recovered_direct = fft(recovered_audio_direct, n);
fft_recovered_hilbert = fft(recovered_audio_hilbert, n);
fft_denoised_direct = fft(denoised_audio_direct, n);
fft_denoised_hilbert = fft(denoised_audio_hilbert, n);

% Plot magnitude spectra
figure;
plot(f, abs(fft_original));
title('Frequency Spectrum - Original Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
figure;
subplot(2, 1, 1);
plot(f, abs(fft_recovered_direct));
title('Frequency Spectrum - Recovered Audio (Direct Multiplication)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f, abs(fft_recovered_hilbert));
title('Frequency Spectrum - Recovered Audio (Hilbert Transform)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

figure;
subplot(2, 1, 1);
plot(f, abs(fft_denoised_direct));
title('Frequency Spectrum - Denoised Audio (Direct Multiplication)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f, abs(fft_denoised_hilbert));
title('Frequency Spectrum - Denoised Audio (Hilbert Transform)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
