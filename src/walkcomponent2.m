clc;
clear;
close all;
csi_trace=read_bf_file('C:\Users\NGMI-zzf\Desktop\CSI×ßÂ·\csi\csiwalk\lww\5-20-lwy2.dat');
length=920;
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end
initialsignal=(abs(squeeze(csi(:,:,:,:))));


thenormalcsi=zeros(length,180);
%%convert the csi
for i=1:1:2
    for j=1:1:3
        for k=1:1:30
        thenormalcsi(:,i*j*k)=initialsignal(:,i,j,k);
        end
    end
end


%%pca
[coef,score,latent,t2] = pca(thenormalcsi);
size(thenormalcsi)
size(coef);
latent=100*latent/sum(latent);
pareto(latent);
component=thenormalcsi*coef(:,1:5);
%%
h2=component(:,2).^2;
h3=component(:,3).^2;
h4=component(:,4).^2;
h5=component(:,5).^2;


figure 
plot(h2);






















