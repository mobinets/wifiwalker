clc;close all;clear;
load fisheriris;
X=meas;
Y=species;
Mdl=fitcknn(X,Y,'NumNeighbors',4);
%Mdl.Distance=@disfun;
flwr = [5.0 3.0 5.0 1]; 
preclass=predict(Mdl,flwr)