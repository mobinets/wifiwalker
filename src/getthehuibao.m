%'csiwalk//lww//5-20-lwy6.dat'
clc
clear
close all
load walks2.mat;
csi_trace=read_bf_file('csiwalk//lww//5-20-lwy6.dat');
length=1800;
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end
%%initial data
sender=2;
receiver=3;
channel=30;
initial=zeros(length,sender*receiver*channel);
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
        initial(:,i*j*k)=abs(csi(:,i,j,k));
        end
    end
end
figure
for i=1:1:180
    plot(initial(:,i));
    hold on;
end
hold off;


%%particalpathremoval
[length,sender,receiver,channel] = size(csi);
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
remove2=zeros(length,sender*receiver*channel);
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
        remove2(:,i*j*k)=abs(removedCSIInformation(:,i,j,k));
        end
    end
end
figure
for i=1:1:180
    plot(remove2(:,i));
    hold on;
end
hold off;

%hold off;
figure
[cirn,cirm]=size(cir);
plot(t(1:cirm),abs(real(cir)));
[mm,nn]=size(cir);
plot(t(1:nn),abs(real(cir)));

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
amptitude(:,:,:,:)=(abs(removedCSIInformation(:,:,:,:)));
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
    b(:,i,j,k)=filter(walks2,amptitude(:,i,j,k));
        end
    end
end
thenormalcsi=zeros(length,sender*receiver*channel);
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
        thenormalcsi(:,i*j*k)=b(:,i,j,k);
        end
    end
end
figure
for i=1:1:180
    plot(thenormalcsi(:,i));
    hold on;
end
hold off;
%%pca
[coef,score,latent,t2] = pca(thenormalcsi);
sizes=5;
component=thenormalcsi*coef(:,1:sizes);
figure
plot(component(:,1));
figure
plot(component(:,2));
figure
plot(component(:,3));
figure
plot(component(:,4));
figure
plot(component(:,5));
component2=component.^2;

