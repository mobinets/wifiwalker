
%clc;
%clear;
%close all;

warning('off');
%csi_trace=read_bf_file('C:\Users\NGMI-zzf\Desktop\CSI��·\csi\csiwalk\lww\5-20-lwy13.dat');
%csi_trace=read_bf_file2('/home/zzf/linux-80211n-csitool-supplementary/csi/csiwalk/lww/home/zzf/linux-80211n-csitool-supplementary/csi/csiwalk/hxy/5-20-hxy6.dat');
csi_trace=read_bf_file('~/linux-80211n-csitool-supplementary/csi/code/data/hwj-29.dat');

%length=1000;
[length,oneitem]=size(csi_trace);

%ֻѡ���˷�������2����������3����ݴ洢��csi��
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end

%%multipath remove just for try
%csi=RemoveMultiplePath(csi);


%�����˲���
Hd=MyButterworth;

%%�����ǶԱ��˲��ͷ��˲���ͼ
% for i =1:1:15
%    subplot(6,5,i);
%    plot(abs(csi(:,1,1,i)));
%   % plot(filter(Hd,abs(csi(:,1,1,i))));
% end
% 
% for i=1:1:15
%    subplot(6,5,i+15);
%    %plot(abs(csi(:,1,1,i)));
%    %�˲����˲�
%    plot(filter(Hd,abs(csi(:,1,1,i))));
% end

%%�˲�
filterCSI=filter(Hd,abs(csi));

%PCA
[flength,fsender,freceiver,fcarrier]=size(filterCSI);

pcanum=4;
components=zeros(flength,fsender,freceiver,pcanum);
for i=1:fsender
    for j=1:freceiver
        [coef,score,latent,t2] = pca(squeeze(filterCSI(:,i,j,:)));
        components(:,i,j,:)=squeeze(filterCSI(:,i,j,:))*coef(:,2:5);
    end
end

%�����ɷ�ͼ
component=squeeze(components(:,2,3,:));
Addcomponent=zeros(flength,1);
figure 
for i=1:4
    plot(component(:,i),'color',[rand(),rand(),rand()]);
    Addcomponent=Addcomponent+component(:,i);
    grid on;
    hold on;
end
figure
plot(Addcomponent);
grid on;


%%DWT

dwtnum=3;
%%DWT
[C,L] = wavedec(squeeze(components(:,1,1,1)),dwtnum,'db4');
cA3 = appcoef(C,L,'db4',dwtnum);
DWTcomponent(:,i-1)=cA3;
[DWTlength,~]=size(DWTcomponent);

%%�����е����߶�DWT
DWTcomponents=zeros(DWTlength,fsender,freceiver,pcanum);
for i=1:fsender
    for j=1:freceiver
        for k=1:pcanum
        [C,L] = wavedec(squeeze(components(:,i,j,k)),dwtnum,'db4');
        cA3 = appcoef(C,L,'db4',dwtnum);
        DWTcomponents(:,i,j,k)=cA3;
        end
    end
end
size(cA3)

%%��DWTͼ
figure 
DWTcomponent=squeeze(DWTcomponents(:,2,2,:));
for i=1:4
    plot(DWTcomponent(:,i),'color',[rand(),rand(),rand()]);
    hold on;
end






