function [spf] = spectral_flatness(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%figure(1)
%plot(a)
pxx = periodogram(a);
%figure(2)
%plot(pxx)
num=geomean(pxx);
den=mean(pxx);
spf=num/den;
end

