% Define the parameters
fs = 24000;  % Sampling frequency (samples per second)
duration = 1;  % Duration of the audio signal (in seconds)
t = 0:1/fs:duration-1/fs;  % Time vector
frequencies = [400, 800, 1200, 1600];  % Frequencies in Hz
num_components = length(frequencies);

% Generate random amplitudes for each component
amplitudes = rand(1, num_components);

% Generate the audio signal by summing the sinusoidal components
audio_signal = zeros(1, length(t));
for i = 1:num_components
    audio_signal = audio_signal + amplitudes(i) * sin(2 * pi * frequencies(i) * t);
end

% Normalize the audio signal to the range [-1, 1]
audio_signal = audio_signal / max(abs(audio_signal));

% Visualize the time domain signal
figure;
subplot(2, 1, 1);
plot(t, audio_signal);
title('Time Domain Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Compute the FFT of the audio signal
L = length(audio_signal);  % Length of the signal
N = 2^nextpow2(L);  % Next power of 2 from length of audio_signal
f = fs/2 * linspace(0, 1, N/2+1);  % Frequency vector
audio_fft = fft(audio_signal, N);
audio_fft = 2*abs(audio_fft(1:N/2+1));

% Visualize the frequency spectrum
subplot(2, 1, 2);
plot(f, audio_fft);
title('Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Save the audio signal to a WAV file
output_file = 'files/audio_signal.wav';
audiowrite(output_file, audio_signal, fs);

% Display some information
disp('Audio file has been generated.');
disp(['Frequencies: ' num2str(frequencies)]);
disp(['Amplitudes: ' num2str(amplitudes)]);
disp(['Saved as ' output_file]);
