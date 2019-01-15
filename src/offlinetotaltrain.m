clc;close all;clear;

IDNum=4;
TrainNum=20;
TestNum=10;

n=IDNum;
m=TrainNum;
t=TestNum;

mypath='~/linux-80211n-csitool-supplementary/csi/code/data/';

%dim represents the data dimesion

[aa,dim]=offlineonetrain('~/linux-80211n-csitool-supplementary/csi/code/data/quiet1.dat',1000);

 dataX=zeros(n*m,dim);
 dataY=cell(n*m,1);

IDarray={'csw','ymh','hwj','ylq'};

k=1;

for i=1:1:IDNum
    for j=1:1:TrainNum        
        [X,~]=offlineonetrain([mypath IDarray{i} '-' num2str(j) '.dat'],1000);   
        dataX(k,:)= X;
        dataY{k,:}= IDarray{i};
        k=k+1;
    end
end

%%create classifier with KNN
Mdl=fitcknn(dataX,dataY,'NumNeighbors',4);


TestdataX=zeros(n*t,dim);
PredictResult=cell(n*t,1);
k=1;
for i=1:1:IDNum
    for j=21:1:30
        [X,~]=offlineonetrain([mypath IDarray{i} '-' num2str(j) '.dat'],1000);   
        TestdataX(k,:)=X;
        PredictResult{k,:}=predict(Mdl,X);
        k=k+1;
    end
end

fprintf('Prediction Completed!\n');

SuccessPredictNum=0;
k=1;
TrueResult=cell(n*t,1);
for i=1:1:IDNum
    for j=1:1:TestNum
        TrueResult{k,:}=IDarray(i);
        k=k+1;
    end
end
for i=1:n*t
    if(isequal(TrueResult{i,:},PredictResult{i,:}))
        SuccessPredictNum=SuccessPredictNum+1;
    end
end
accuracy=SuccessPredictNum/(n*t)
