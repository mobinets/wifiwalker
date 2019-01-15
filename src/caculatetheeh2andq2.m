clc;
clear;
close all;
load walk.mat;
load walks.mat;
load walks2.mat;
csi_trace=read_bf_file('5.21samples//walkyy5-5-4.dat');

length=900;
eh2=zeros(1,length);
eq2=zeros(1,length);
for li=3:1:length
csi=zeros(li,2,3,30);
for i=1:1:li
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end

[wtf,sender,receiver,channel]=size(csi);
amptitude=zeros(wtf,sender,receiver,channel);
b=zeros(wtf,sender,receiver,channel);
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
amptitude(:,:,:,:)=(abs(csi(:,:,:,:)));

thenormalcsi=zeros(li,sender*receiver*channel);
for i=1:1:sender
    for j=1:1:receiver
        for k=1:1:channel
        thenormalcsi(:,i*j*k)=amptitude(:,i,j,k);
        end
    end
end


[coef,score,latent,t2] = pca(thenormalcsi);

component=thenormalcsi*coef(:,1:2);
q2=coef(:,2);

h2=component(:,2).^2;
eh2(1,li)=mean(h2);
sum=0;
for i=2:1:180
    sum=sum+abs(q2(i,1)-q2(i-1,1));
end
eq2(1,li)=sum/(179);

end
figure
plot(h2);

figure 
plot(eh2(1,3:length));
figure
plot(eq2(1,3:length));

eh2vseq2=zeros(1,length);
for i=3:1:length
    eh2vseq2(1,i)=eh2(1,i)/eq2(1,i);
end

figure
plot(eh2vseq2(1,3:length));
 