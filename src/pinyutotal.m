clc;
clear;
close all;
load walk.mat;
load walks.mat
csi_trace=read_bf_file('5.21samples//walk5-5-8.dat');
length=940;
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end
%%particalpathremoval
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
%%delay=0.5ms
RemovedCir=cir(1:round(tm/2));
RemovedCSI=fft(RemovedCir);
RemovedCSI=RemovedCSI((2433+20/30):20/30:2453);
removedCSIInformation(i,j,k,:)=RemovedCSI;
        end
    end
end


[length,sender,receiver,channel]=size(removedCSIInformation);
amptitude=zeros(length,sender,receiver,channel);
b=zeros(length,sender,receiver,channel);
%%csi=squeeze(csi);
%%t=1:1:30;
%%abs(csi(1,1,:))
%%figure;
%for i=1:1:2
%    for j=1:1:3
%         plot(t,squeeze(db(abs(csi(i,j,:)))));
%         hold on;
%     end
% end
% hold off;
%for k=1:1:length
%for i=1:1:sender
%    for j=1:1:receiver
%        amptitude(k,i,j,:)=db(abs(removedCSIInformation(k,i,j,:)));
%    end
%end
%end
%%amptitude(:,:,:,:)=(abs(removedCSIInformation(:,:,:,:)));
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
    b(:,i,j,k)=filter(walks,removedCSIInformation(:,i,j,k));
        end
    end
end
thenormalcsi=zeros(length,sender*receiver*channel);
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
        thenormalcsi(:,i*j*k)=abs(b(:,i,j,k));
        end
    end
end

figure
for i=1:1:180
plot(thenormalcsi(:,i));
hold on
end
hold off

hold off;
[coef,score,latent,t2] = pca(thenormalcsi);
size(thenormalcsi)
size(coef);
latent=100*latent/sum(latent);
figure
pareto(latent);
component=thenormalcsi*coef(:,1:5);
h1=component(:,1);
h2=component(:,2);
h3=component(:,3);
h4=component(:,4);
h5=component(:,5);


figure
plot(h2);

figure
plot(h5);

 