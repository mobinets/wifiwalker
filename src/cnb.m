clc
clear
load fisheriris
X = meas;
Y = species;

Mdl = fitcnb(X,Y)