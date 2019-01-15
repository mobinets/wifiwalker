clc;
clear;
close all;
load removedCSIInformation.mat;
load walk.mat;
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

b(:,:,:,:)=filter(walk,amptitude(:,:,:,:));
thenormalcsi=zeros(length,sender*receiver*channel);
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
        thenormalcsi(:,i*j*k)=b(:,i,j,k);
        end
    end
end

figure

plot(thenormalcsi(:,1));

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

 