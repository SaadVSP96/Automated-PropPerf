%lecture slides at all radial positions but for one climb velocity only
%defining some more constants
C_d_o = 0.008;
%defining radial positions
r_by_R = [0.3 0.5 0.7 0.8 0.9 1.0];
c_ft = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5];%ft
theta_deg = [10.2, 9.0, 7.8, 7.2, 6.6, 6];%deg
C_l_a_per_rad = [5.7, 5.7, 5.7, 5.7, 5.7, 5.7]; %1/rad
R_ft = 25;%ft
Omega_R_fts = 650;%tip speed - ft/s
V_fts = 0;%ft/s
N_b = 3;%number of blades
%calling the function and producing the matrices at all radials-for V_climb = 0
for i = 1:1:6
  [theta_deg(i),theta_rad(i),phi_rad(i),alpha_deg(i),C_l(i),Lambda(i),Lambda_c(i),sigma(i)]=...
   CBEMT_function(r_by_R(i),c_ft(i),theta_deg(i),C_l_a_per_rad(i),R_ft,...
   Omega_R_fts,V_fts,N_b);
end
%printing the data in a good fashion
disp(theta_deg)
disp(theta_rad)
disp(phi_rad)
disp(alpha_deg)
disp(C_l)
%now moving towards the calculation of C_T and C_P
%for C_T
X1 = r_by_R;
Y1 = (sigma/2).*(r_by_R.^2).*C_l;
figure(1)
plot(X1,Y1,'r','LineWidth',2)
grid on
C_T = trapz(X1,Y1)
%for C_P
X2 = r_by_R;
Y2_a = (r_by_R.^3).*C_d_o;
Y2_b = (r_by_R.^3).*C_l.*phi_rad
figure(2)
plot(X2,Y2_a,'g','LineWidth',2)
grid on
C_P = ((sigma*C_d_o)/8)+((sigma/2)*trapz(X2,Y2))

