clc;
clear;
close all;
filenames=cell(3,15);
str=cell(1,3);
str{1,1}='csiwalk//lww//5-20-lwy';
str{1,2}='csiwalk//hxy//5-20-hxy';
str{1,3}='csiwalk//ymh//5-20-ymh';

for i=1:1:3
    for j=1:1:15
    filenames{i,j}=strcat(strcat(str{1,i},num2str(j)),'.dat');
    end
end
save filenames;
