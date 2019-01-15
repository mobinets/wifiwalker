function [ TraindataX,dimX ] = offlineonetrain( filename,filelen )
warning('off')
%csi_trace=read_bf_file2('/home/zzf/linux-80211n-csitool-supplementary/csi/csiwalk/lww/home/zzf/linux-80211n-csitool-supplementary/csi/csiwalk/hxy/5-20-hxy6.dat');
csi_trace=read_bf_file(filename);

%length=1000;
[length,oneitem]=size(csi_trace);
length=filelen;

%ֻѡ���˷�������2����������3����ݴ洢��csi��
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end

%load the filter designed before
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
component=squeeze(components(:,2,2,:));

%%DWT

dwtnum=3;
%%DWT
[C,L] = wavedec(squeeze(component(:,1)),dwtnum,'db4');
cA3 = appcoef(C,L,'db4',dwtnum);
DWTcomponent(:,i-1)=cA3;
[DWTlength,~]=size(DWTcomponent);

%%�����е����߶�DWT
%TraindataX=zeros(DWTlength*pcanum);

%add all the pca conponents together as the traindata
TraindataX=zeros(DWTlength,1);
for k=1:pcanum
        [C,L] = wavedec(squeeze(component(:,k)),dwtnum,'db4');
        cA3 = appcoef(C,L,'db4',dwtnum);
        TraindataX=TraindataX+cA3;
end

TraindataX=TraindataX';
[~,dimX]=size(TraindataX);
%TraindataY=id;

end

