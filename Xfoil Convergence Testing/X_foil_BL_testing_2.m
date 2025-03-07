% This code will allow to change BL conditions unitl convergence is
% achieved for the problem condition
clc;clear;close all
% entering values of the problem condition:
mach = [0.344198985905192];
Re_number = [4071.47245651451];
aoa =  [4.90626270184483]%[4.90702293761714]%[4.82677908990905];
airfoil_dat_file = 'ClarkY.dat';
%entering BL parameter arrays:
Xtrip_c_top = 1;
Xtrip_c_bottom = 1; 
Ncrit = 2.4;
vacc = 0.008;
[cl, cd] = XFoil_Analysis_new(mach, Re_number, aoa, airfoil_dat_file,...
                    Xtrip_c_top, Xtrip_c_bottom, Ncrit, vacc);
cl
cd
