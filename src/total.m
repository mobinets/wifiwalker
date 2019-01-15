%'csiwalk//lww//5-20-lwy6.dat'
function [means,means2,medians,medians2,stds,stds2,mins1,maxs1,mins2,maxs2,skewnesses,skewnesses2,dominantfres,dominantfres2,iqrs,iqrs2,zcrs,zcrs2,mcrs,mcrs2,cmrs,cmrs2,spen,spen2,spcec,spcec2,spces,spces2,sprf,sprf2,spfl,spfl2]=total(file)
load walks2.mat;
csi_trace=read_bf_file(file);
length=1800;
csi=zeros(length,2,3,30);
for i=1:1:length
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end
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

%%pca
[coef,score,latent,t2] = pca(thenormalcsi);
sizes=5;
component=thenormalcsi*coef(:,1:sizes);
component2=component.^2;
%%average
means=zeros(1,sizes-1);
means2=zeros(1,sizes-1);
%%median
medians=zeros(1,sizes-1);
medians2=zeros(1,sizes-1);
%%standard Deviation
stds=zeros(1,sizes-1);
stds2=zeros(1,sizes-1);
%%range
mins1=zeros(1,sizes-1);
maxs1=zeros(1,sizes-1);
mins2=zeros(1,sizes-1);
maxs2=zeros(1,sizes-1);
%%skewness??
skewnesses=zeros(1,sizes-1);
skewnesses2=zeros(1,sizes-1);
%%kurtosis????
kurtosises=zeros(1,sizes-1);
kurtosises2=zeros(1,sizes-1);
%%dominant frequency???
dominantfres=zeros(1,sizes-1);
dominantfres2=zeros(1,sizes-1);
%%Interquartile range????
iqrs=zeros(1,sizes-1);
iqrs2=zeros(1,sizes-1);
%%zero crossing rate???
zcrs=zeros(1,sizes-1);
zcrs2=zeros(1,sizes-1);
%%Mean crossing rate????
mcrs=zeros(1,sizes-1);
mcrs2=zeros(1,sizes-1);
%%crossing mean rate??mean?????
cmrs=zeros(1,sizes-1);
cmrs2=zeros(1,sizes-1);
%%Spectral Entropy
spen=zeros(1,sizes-1);
spen2=zeros(1,sizes-1);
%%spectral_centroid,spectral spread 
spcec=zeros(1,sizes-1);
spces=zeros(1,sizes-1);
spcec2=zeros(1,sizes-1);
spces2=zeros(1,sizes-1);
%%spectral_rolloff
sprf=zeros(1,sizes-1);
sprf2=zeros(1,sizes-1);
%%spectral_flatness
spfl=zeros(1,sizes-1);
spfl2=zeros(1,sizes-1);
for i=2:1:5
    %%mean
    means(1,i-1)=mean(component(:,i));
    means2(1,i-1)=mean(component2(:,i));
    %%median
    medians(1,i-1)=median(component(:,i));
    medians2(1,i-1)=median(component2(:,i));
    %%std
    stds(1,i-1)=std(component(:,i));
    stds2(1,i-1)=std(component2(:,i));
    %%range
    mins1(1,i-1)=min(component(:,i));
    maxs1(1,i-1)=max(component(:,i));
    mins2(1,i-1)=min(component2(:,i));
    maxs2(1,i-1)=max(component2(:,i));
    %%skewness
    skewnesses(1,i-1)=skewness(component(:,i));
    skewnesses2(1,i-1)=skewness(component2(:,i));
    %%kurtosis
    kurtosises(1,i-1)=kurtosis(component(:,i));
    kurtosises2(1,i-1)=kurtosis(component2(:,i));
    %%dominant frequency
    dominantfres(1,i-1)=dominantfrequency(component(:,i),2);
    dominantfres2(1,i-1)=dominantfrequency(component2(:,i),2);
    %%Interquartile range
    iqrs(1,i-1)=iqr(component(:,i));
    iqrs2(1,i-1)=iqr(component2(:,i));
    %%zeros crossing rate
    zcrs(1,i-1)=ZCR(component(:,i),0);
    zcrs2(1,i-1)=ZCR(component2(:,i),0);
    %%Mean Crossing rate
    mcrs(1,i-1)=ZCR(component(:,i),means(1,i-1));
    mcrs2(1,i-1)=ZCR(component2(:,i),means2(1,i-1));
    %%Crossing mean rate
    cmrs(1,i-1)=CMR(component(:,i));
    cmrs2(1,i-1)=CMR(component2(:,i));
    %%feature_spectral_entropy
    spen(1,i-1)=feature_spectral_entropy(getDFT(component(:,i),200),20);
    spen2(1,i-1)=feature_spectral_entropy(getDFT(component2(:,i),200),20);
    %%feature_spectral_centroid(window_FFT, fs),spectral_spread
    [c,s]=feature_spectral_centroid(getDFT(component(:,i),200),200);
    spcec(1,i-1)=c;
    spces(1,i-1)=s;
    [c,s]=feature_spectral_centroid(getDFT(component2(:,i),200),200);
    spcec2(1,i-1)=c;
    spces2(1,i-1)=s;
    %%feature_spectral_rolloff(windowFFT, c)
    sprf(1,i-1)=feature_spectral_rolloff(getDFT(component(:,i),200),0.95);
    sprf2(1,i-1)=feature_spectral_rolloff(getDFT(component2(:,i),200),0.95);  
    %%spectral_flatness
    spfl(1,i-1)=spectral_flatness(component(:,i));
    spfl2(1,i-1)=spectral_flatness(component2(:,i));
end
end


