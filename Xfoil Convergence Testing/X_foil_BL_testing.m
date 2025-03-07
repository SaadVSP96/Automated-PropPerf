% This code will allow to change BL conditions unitl convergence is
% achieved for the problem condition
clc;clear;close all
% entering values of the problem condition:
mach = 0.342949367012242;
Re_number = 35678.5966663039;
aoa = 8.81706276053845;
airfoil_dat_file = 'ClarkY.dat';
%entering BL parameter arrays:
Xtrip_c_top = 1;
Xtrip_c_bottom = 1; 
Ncrit = 7;
vacc = 0.02;
[cl, cd] = XFoil_Analysis(mach, Re_number, aoa, airfoil_dat_file,...
                    Xtrip_c_top, Xtrip_c_bottom, Ncrit, vacc);
cl
cd
