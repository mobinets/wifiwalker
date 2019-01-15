clc;close all;clear;

IDNum=3;
TrainNum=20;
TestNum=10;

n=IDNum;
m=TrainNum;
t=TestNum;

mypath='~/linux-80211n-csitool-supplementary/csi/code/data/';

[aa,dim]=offlineonetrain('~/linux-80211n-csitool-supplementary/csi/code/data/quiet1.dat',1000);

 dataX=zeros(n*m+10,dim);
 dataY=cell(n*m+10,1);

IDarray={'csw','ymh','hwj','ylq'};

%result=[IDarray{1},num2str(i)]
k=1;

for i=1:1:IDNum
    for j=1:1:TrainNum        
        [X,~]=offlineonetrain([mypath IDarray{i} '-' num2str(j) '.dat'],1000);   
        dataX(k,:)= X;
        dataY{k,:}= IDarray{i};
        k=k+1;
    end
end

for j=1:15
    [X,~]=offlineonetrain([mypath IDarray{4} '-' num2str(j) '.dat'],1000);
    dataX(k,:)= X;
    dataY{k,:}= IDarray{4};
    k=k+1;
end

%%create classifier with KNN
Mdl=fitcknn(dataX,dataY,'NumNeighbors',4);


TestdataX=zeros(n*t+10,dim);
PredictResult=cell(n*t+10,1);
k=1;
for i=1:1:IDNum
    for j=21:1:30
        [X,~]=offlineonetrain([mypath IDarray{i} '-' num2str(j) '.dat'],1000);   
        TestdataX(k,:)=X;
        PredictResult{k,:}=predict(Mdl,X);
        k=k+1;
    end
end
for j=16:20
    [X,~]=offlineonetrain([mypath IDarray{4} '-' num2str(j) '.dat'],1000);   
    TestdataX(k,:)=X;
    PredictResult{k,:}=predict(Mdl,X);
    k=k+1;
end

fprintf('Prediction Completed!\n');