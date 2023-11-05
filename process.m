[y, fs] = audioread('files/audio_signal.wav');
desired_fs = 24000;
y = resample(y, desired_fs, fs);

% Define the number of quantization bits
num_bits = 16;
y_digital = round(y * (2^(num_bits-1)));

% Create the time vector 't'
t = (0:length(y)-1) / desired_fs;  % Assuming the signal starts at time 0

% Plot the original and quantized signals
figure;
subplot(2, 1, 1);
plot(t, y, 'b');
title('Original Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, y_digital, 'r');
title('Quantized Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the frequency spectra
n = length(y);  % Length of the signals
f = (0:(n-1)) * (desired_fs / n);

% Compute the FFT of the original and quantized signals
Y = fft(y, n);
Y_digital = fft(y_digital, n);

% Plot the magnitude spectra
figure;
subplot(2, 1, 1);
plot(f, abs(Y), 'b');
title('Frequency Spectrum of Original Audio Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f, abs(Y_digital), 'r');
title('Frequency Spectrum of Quantized Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

audiowrite('files/audio_signal_int16.wav', y_digital, desired_fs);
