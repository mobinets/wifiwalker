function DWT=GetDWTcomponents(csi_trace)
%csi_trace=read_bf_file('/home/zzf/linux-80211n-csitool-supplementary/netlink/cs1.dat');

%length=1000;
[length,~]=size(csi_trace);

%ֻѡ���˷�������2����������3����ݴ洢��csi��
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end

%�����˲���
Hd=MyButterworth;


%%filter the csi
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


%%DWT

dwtnum=3;
%%�����DWT֮��Ĳ��γ���
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
[DWTSize,~,~,~]=size(DWTcomponents);
DWT=zeros(1,DWTSize*fsender*freceiver*pcanum);

m=0;
for i=1:fsender
    for j=1:freceiver
        for k=1:pcanum
        DWT(m*DWTSize+1:(m+1)*DWTSize)=DWTcomponents(:,i,j,k);
        m=m+1;
        end
    end
end

end
