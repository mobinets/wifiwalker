function fest=dominantfrequency(x,Fs)
x = x - mean(x);                                            % <= ADDED LINE
nfft = 512; % next larger power of 2
y = fft(x,nfft); % Fast Fourier Transform
y = abs(y.^2); % raw power spectrum density
y = y(1:1+nfft/2); % half-spectrum
[v,k] = max(y); % find maximum
f_scale = (0:nfft/2)* Fs/nfft; % frequency scale
fest = f_scale(k); % dominant frequency estimate
