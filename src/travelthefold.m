clc
clear
close all;
fileFolder=fullfile('..//csiwalk//');
dirOutput=dir(fullfile(fileFolder,'*.dat'));
fileNames={dirOutput.name}'