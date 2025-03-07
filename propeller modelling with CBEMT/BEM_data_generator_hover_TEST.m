clc; clear variables; close all
%this function calls,c stores and can display the BEM code outputs as
%specified in the lecture slides at all radial positions but for hover only
%defining some more constants
C_d_o = 0.008;
%defining radial positions
radial_posn = 0.0001:0.00001:0.9999;
%calling the function and producing the matrices at all radials-for V_climb = 0
for i = 1:1:length(radial_posn)
[theta_deg(i),theta_rad(i),phi_rad(i),alpha_deg(i),C_l(i),Lambda(i),sigma]...
=BEM_function_w_tip_loss_22x8(radial_posn(i));
end
%Tabulation of values at different radial locations
r_by_R = [0.3 0.5 0.7 0.8 0.9 0.999]*100000;
for i=1:1:length(r_by_R)
theta_deg_1(i) = theta_deg(r_by_R(i));
theta_rad_1(i) = theta_rad(r_by_R(i));
phi_rad_1(i) = phi_rad(r_by_R(i));
alpha_deg_1(i) = alpha_deg(r_by_R(i));
C_l_1(i) = C_l(r_by_R(i));
Lambda_1(i) = Lambda(r_by_R(i));
end
%Making the inflow ratio graph on slide 33
plot(radial_posn,Lambda,'c','LineWidth',1.5)
xlabel('Radial Locations - (r/R)')
ylabel('Inflow Ratio')
title('Inflow Ratio Variation with Radial Location')
grid on
%Making the Sectional lift vs radial location graph on slide 28
figure(2)
plot(radial_posn,C_l,'b','LineWidth',1.5)
xlabel('Radial Locations - (r/R)')
ylabel('Section Lift - C_l')
title('Section Lift Variation with Radial Location')
grid on
%now moving towards the calculation of C_T and C_P
%for C_T
X1 = radial_posn;
Y1 = (radial_posn.^2).*C_l;
figure(3)
plot(X1,Y1,'r','LineWidth',2)
ylim([0 0.4]);grid on
title('For C_T');xlabel('Radial Locations - (r/R)');
ylabel('Thrust, (r/R)^2*C_l')
C_T = (sigma/2)*trapz(X1,Y1)
T = C_T*([0.00230811312846199]*(pi*25*25)*((26*25)^2))
%for C_P
X2 = radial_posn;
Y2 = (radial_posn.^3).*C_l.*phi_rad;
figure(4)
plot(X2,Y2,'g','LineWidth',2)
ylim([0 0.02]);grid on
title('For C_P');xlabel('Radial Locations - (r/R)');
ylabel('Power, (r/R)^3*C_l*phi')
C_P = ((sigma*C_d_o)/8)+((sigma/2)*trapz(X2,Y2))
