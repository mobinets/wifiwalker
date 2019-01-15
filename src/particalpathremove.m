%%removethemultipath
clc
clear
close all
load csi.mat
[length,sender,receiver,channel]=size(csi);
removedCSIInformation=zeros(length,sender,receiver,channel);
for i=1:1:length
    for j=1:1:sender
        for k=1:1:receiver
    a=csi(i,j,k,:);
    b=a(:,:);
%figure
%plot(abs(csi));
%hold on
% approximate interval of subcarriers
interval = 20/30;
%freq: 5290~5330 MHz 2431-2453
%number of zeros before CSI
numZeros = ceil(2433/interval);
%make up carrier frequency response
cfr = [zeros(1,numZeros),b];
%slot of ifft
N = numZeros + 30;
%get approximate channel impluse response
cir = ifft(cfr,N);
t = 0:1/(2453*2):1;
[tn,tm]=size(t);
%%?delay??0.5ms???????????
RemovedCir=cir(1:round(tm/2));
RemovedCSI=fft(RemovedCir);
RemovedCSI=RemovedCSI((2433+20/30):20/30:2453);
removedCSIInformation(i,j,k,:)=RemovedCSI;
        end
    end
end
save removedCSIInformation;
%size(RemovedCSI)
%plot(abs(RemovedCSI));
%hold off;
%[cirn,cirm]=size(cir);
%plot(t(1:cirm),abs(real(cir)));
%plot(t(1:length(cir)),abs(real(cir)));

% This function calculate the CIR from CSI in 5G 40MHz freq
% Assumption: the noise is very low

