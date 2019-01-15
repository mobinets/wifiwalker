clc
clear
close all;
load traindata.mat;
load testdata.mat;
load fisheriris;
%%decision tree
X=traineddataX;
Y=cell(45,1);
for i=1:1:3
    for j=1:1:15
       if i==1
           Y{(i-1)*15+j,1}='lww'; 
      elseif i==2
           Y{(i-1)*15+j,1}='hxy'; 
       elseif i==3
           Y{(i-1)*15+j,1}='ymh';
       end
    end  
 end

tc  = fitcnb(X,Y);


%testdataX2;
%testdataY;
%testdataY2;


%traineddataX2;
%Y=traineddataY;
%traineddataY2;



%%
    
%%Mdl=fitcknn(X,Y2,'NumNeighbors',3);
%pY = predict(Mdl,pX);