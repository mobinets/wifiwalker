clc
clear
close all
load filenamesfortest.mat;
testdataX=zeros(30,64);
testdataX2=zeros(30,64);
testdataY=zeros(30,3);
testdataY2=zeros(30,3);
count=0;
for i=1:1:3
for j=11:1:20
[means,means2,medians,medians2,stds,stds2,mins1,maxs1,mins2,maxs2,skewnesses,skewnesses2,dominantfres,dominantfres2,iqrs,iqrs2,zcrs,zcrs2,mcrs,mcrs2,cmrs,cmrs2,spen,spen2,spcec,spcec2,spces,spces2,sprf,sprf2,spfl,spfl2]=total(filenamesfortest{i,j-10});
  testdataX((i-1)*10+j-10,:)=[means,medians,stds,mins1,maxs1,skewnesses,dominantfres,iqrs,zcrs,mcrs,cmrs,spen,spcec,spces,sprf,spfl];  
  testdataX2((i-1)*10+j-10,:)=[means2,medians2,stds2,mins2,maxs2,skewnesses2,dominantfres2,iqrs2,zcrs2,mcrs2,cmrs2,spen2,spcec2,spces2,sprf2,spfl2];  
  count=count+1   
end
end

for j=1:1:10
        testdataY(j,1)=1;
        testdataY(j,2)=0;
        testdataY(j,3)=0;
        testdataY2(j,1)=1;
        testdataY2(j,2)=0;
        testdataY2(j,3)=0;
end
    
    for j=11:1:20
        testdataY(j,1)=0;
        testdataY(j,2)=1;
        testdataY(j,3)=0;
        testdataY2(j,1)=0;
        testdataY2(j,2)=1;
        testdataY2(j,3)=0;
    end
    
      
    for j=21:1:30
        testdataY(j,1)=0;
        testdataY(j,2)=0;
        testdataY(j,3)=1;
        testdataY2(j,1)=0;
        testdataY2(j,2)=0;
        testdataY2(j,3)=1;
    end
    save testdata;