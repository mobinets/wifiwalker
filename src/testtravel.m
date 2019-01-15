clc;
clear;
close all;
filenamesfortest=cell(3,10);
str2=cell(1,3);
str2{1,1}='testpart//lww//5-20-lwy';
str2{1,2}='testpart//hxy//5-20-hxy';
str2{1,3}='testpart//ymh//5-20-ymh';

for i=1:1:3
    for j=11:1:20
    filenamesfortest{i,j-10}=strcat(strcat(str2{1,i},num2str(j)),'.dat');
    end
end
save filenamesfortest;