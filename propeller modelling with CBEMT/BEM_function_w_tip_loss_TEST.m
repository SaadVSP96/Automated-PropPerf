function [theta_deg,theta_rad,phi_rad,alpha_deg,C_l,Lambda,sigma]...
=BEM_function_w_tip_loss_TEST(radial_posn)
%Defining the constant values
N_b = 3;
theta_o_deg = 12;%root angle - deg
theta_o_rad = deg2rad(theta_o_deg);%root angle - rad
theta_tw_deg = -6;%twist angle - deg
theta_tw_rad = deg2rad(theta_tw_deg);%twist angle - rad
theta_R = 650;%tip speed - ft/s
R = 25;%blade radius - ft
C_l_a = 5.7;%1/rad
c = 1.5;%blade constant chord - ft
r_by_R = radial_posn;%radial position
%beginning calculation for one radial position and one climb velocity
%calcualte solidity
sigma = (N_b*c)/(pi*R);
theta_deg = theta_o_deg + (theta_tw_deg*(r_by_R));
theta_rad = theta_o_rad + (theta_tw_rad*(r_by_R));
%Inflow iterative loop
F = 1;
for j=1:1:10
A = (sigma*C_l_a)/(16*F);
B = ((32*F)/(sigma*C_l_a))*theta_rad*(r_by_R);
Lambda = A*(sqrt(1+B)-1);
f = (N_b/2)*((1-r_by_R)/Lambda);
F = (2/pi)*acos(exp(-f));
end
phi_rad = Lambda / r_by_R;
alpha = theta_rad - phi_rad;
alpha_deg = rad2deg(alpha);
C_l = C_l_a*alpha;
end