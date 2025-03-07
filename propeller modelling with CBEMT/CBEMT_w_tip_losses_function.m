%This function applies the principles of the CBEMT on a singular station 
%(dr) of the propeller and generates all the data needed to get the thrust
%and power later down the road.
function [theta_deg,theta_rad,phi_rad,alpha_deg,C_l,Lambda,Lambda_c,sigma]...
= CBEMT_w_tip_losses_function(r_by_R, c_ft, theta_deg, C_l_a_per_rad, R_ft, Omega_R_fts, V_fts, N_b)
%Defining the constant values
V_forward = V_fts;%Climb velocity
%beginning calculation for one radial position and one forward velocity
%calcualte solidity
sigma = (N_b*c_ft)/(pi*R_ft);
theta_rad = deg2rad(theta_deg); 
Lambda_c = V_forward / Omega_R_fts;
%Inflow iterative loop
F = 1;
for i = 1:1:10
    A = ((sigma*C_l_a_per_rad)/(16*F)) - (Lambda_c/2);
    B = ((sigma*C_l_a_per_rad)/(8*F))*(theta_rad)*(r_by_R);
    Lambda = (sqrt(((A)^2)+B))-A;
    f = (N_b/2)*((1-r_by_R)/Lambda);
    F = (2/pi)*acos(exp(-f));
end
phi_rad = Lambda / r_by_R;
alpha = theta_rad - phi_rad;
alpha_deg = rad2deg(alpha);
C_l = C_l_a_per_rad*alpha;
end

