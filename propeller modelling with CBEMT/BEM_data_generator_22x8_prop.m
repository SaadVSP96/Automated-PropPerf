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
=BEM_function_w_tip_loss_TEST(radial_posn(i));
end
%now moving towards the calculation of C_T and C_P
%for C_T
X1 = radial_posn;
Y1 = (radial_posn.^2).*C_l;
C_T = (sigma/2)*trapz(X1,Y1)
T = C_T*([0.00230811312846199]*(pi*25*25)*((26*25)^2))
%for C_P
X2 = radial_posn;
Y2 = (radial_posn.^3).*C_l.*phi_rad;
C_P = ((sigma*C_d_o)/8)+((sigma/2)*trapz(X2,Y2))
