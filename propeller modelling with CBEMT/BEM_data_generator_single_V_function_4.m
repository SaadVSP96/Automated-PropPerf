clc;clear variables;close all

%Establishing atmospheric Parameters
alt_ft = 1000:1000:50000;%limit is 36K 
alt_m = alt_ft * 0.3048;
%Temp in K, Sound Speed in m/s, Pressure in Pa, rho in kg/m3
[T_si,a_si,P_si,rho_si] = atmoscoesa(alt_m);
%converting atmospheric values to english units
T_eng = 1.8*T_si; %Temperature in English 
a = 3.28084*a_si; %speed of sound in english
P = 0.02088547*P_si;%Pressure in english
rho = 0.00194032*rho_si;%density in english
mew = ((-2.05e-09).*(alt_ft/1000)) + 3.739e-07;%Dynamic Viscoscity curvefit

%lecture slides at all radial positions but for one climb velocity only
%defining some more constants
R_ft = 25;%ft
del_r = 0.0001;
r_by_R = 0.0001:del_r:0.9999;
c_ft = ones(1,length(r_by_R)).*1.5;
theta_o_deg = 12;%root angle - deg
theta_tw_deg = -6;%twist angle - deg
theta_deg = theta_o_deg + (theta_tw_deg*(r_by_R));
C_l_a_per_rad = ones(1,length(r_by_R)).*5.7; %1/rad
Omega = 26;%rad/s
Omega_R_fts = Omega*R_ft;%tip speed - ft/s
V_fts = 0;%ft/s
N_b = 3;%number of blades
%calling the function and producing the matrices at all radials-for V_climb = 0
for i = 1:1:length(r_by_R)
    [theta_rad(i),phi_rad(i),C_l(i),C_d(i),Lambda(i),sigma(i)]...
    = CBEMT_w_tip_losses_FEW_ASSP_function(r_by_R(i),c_ft(i),theta_deg(i),...
    C_l_a_per_rad(i), R_ft, Omega_R_fts, V_fts, N_b);
    %Now making the dT and dQ with fewer assumptions for each segment to
    %then add in the end
    d_T(i) = N_b*((C_l(i)*cos(phi_rad(i)))-(C_d(i)*sin(phi_rad(i))))*...
            (1/2)*rho(1)*(((Omega*(r_by_R(i)*R_ft))^2) + ((Lambda(i)*Omega_R_fts)^2))...
            *c_ft(i)*del_r;
    d_P(i) = N_b*(Omega*(r_by_R(i)*R_ft))*(((C_d(i)*cos(phi_rad(i)))+(C_l(i)*sin(phi_rad(i))))*...
            (1/2)*rho(1)*(((Omega*(r_by_R(i)*R_ft))^2) + ((Lambda(i)*Omega_R_fts)^2))...
            *c_ft(i)*del_r);            
end
T = sum(d_T)
P = sum(d_P)
%Turning to coefficients
C_T = T/(rho(1)*(pi*R_ft*R_ft)*((Omega*R_ft))^2)
C_P = P/(rho(1)*(pi*R_ft*R_ft)*((Omega*R_ft))^3)




