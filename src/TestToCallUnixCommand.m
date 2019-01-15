clc;clear;close all;

% unix('./testsh.sh');
% unix('ls')
unix('sudo ping -i 0.001 192.168.0.1 &')
unix('./testshcommand.sh');