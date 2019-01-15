clc
clear
close all
load filenames.mat;
traineddataX=zeros(45,64);
traineddataX2=zeros(45,64);
traineddataY=zeros(45,3);
traineddataY2=zeros(45,3);
count=0;
for i=1:1:3
for j=1:1:15
[means,means2,medians,medians2,stds,stds2,mins1,maxs1,mins2,maxs2,skewnesses,skewnesses2,dominantfres,dominantfres2,iqrs,iqrs2,zcrs,zcrs2,mcrs,mcrs2,cmrs,cmrs2,spen,spen2,spcec,spcec2,spces,spces2,sprf,sprf2,spfl,spfl2]=total(filenames{i,j});
  traineddataX((i-1)*15+j,:)=[means,medians,stds,mins1,maxs1,skewnesses,dominantfres,iqrs,zcrs,mcrs,cmrs,spen,spcec,spces,sprf,spfl];  
  traineddataX2((i-1)*15+j,:)=[means2,medians2,stds2,mins2,maxs2,skewnesses2,dominantfres2,iqrs2,zcrs2,mcrs2,cmrs2,spen2,spcec2,spces2,sprf2,spfl2];  
  count=count+1   
end
end


    for j=1:1:15
        traineddataY(j,1)=1;
        traineddataY(j,2)=0;
        traineddataY(j,3)=0;
        traineddataY2(j,1)=1;
        traineddataY2(j,2)=0;
        traineddataY2(j,3)=0;
    end
    
    for j=16:1:30
        traineddataY(j,1)=0;
        traineddataY(j,2)=1;
        traineddataY(j,3)=0;
        traineddataY2(j,1)=0;
        traineddataY2(j,2)=1;
        traineddataY2(j,3)=0;
    end
    
      
    for j=31:1:45
        traineddataY(j,1)=0;
        traineddataY(j,2)=0;
        traineddataY(j,3)=1;
        traineddataY2(j,1)=0;
        traineddataY2(j,2)=0;
        traineddataY2(j,3)=1;
    end
 save traindata;
