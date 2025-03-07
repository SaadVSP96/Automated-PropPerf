function [Thrust, Torque, Power, power_hp, C_P, C_T, C_Q, J, eeta_p] = ...
          Propeller_Performance_via_BET_iterative_14x13_EQN_func(...
              velocity_mph, RPM, altitude)
%Establishing atmospheric Parameters
alt_ft = 1000:1000:50000;%limit is 36K 
alt_m = alt_ft * 0.3048;
%Temp in K, Sound Speed in m/s, Pressure in Pa, rho in kg/m3
[T_si,a_si,Pres_si,rho_si] = atmoscoesa(alt_m);
%converting atmospheric values to english units
T_eng = 1.8*T_si; %Temperature in English 
a = 3.28084*a_si; %speed of sound in english
Pres = 0.02088547*Pres_si;%Pressure in english
rho = 0.00194032*rho_si;%density in english
mew = ((-2.05e-09).*(alt_ft/1000)) + 3.739e-07;%Dynamic Viscoscity curvefit

%Basic Data
V_0_fts = velocity_mph*1.46667;%ft/s
Dia_prop = 7*2;%inches
Dia_hub = 1.75*2;%inches
alt_op = altitude;% n*1000 ft
a_alt = a(alt_op);
%Preliminaries
n = RPM/60;%rps
Omega = 2*pi*(RPM/60);%rad/s
R_hub = (Dia_hub/2)*(1/12);%ft
R = (Dia_prop/2)*(1/12);%ft
n_blades = 3;
%Inputting UIUC Geometry:
r_by_R = [0.150000000000000,0.200000000000000,0.250000000000000,0.300000000000000,0.350000000000000,0.400000000000000,0.450000000000000,0.500000000000000,0.550000000000000,0.600000000000000,0.650000000000000,0.700000000000000,0.750000000000000,0.800000000000000,0.850000000000000,0.900000000000000,0.950000000000000,1];
c_by_R = [0.143000000000000,0.140000000000000,0.140000000000000,0.140000000000000,0.141000000000000,0.143000000000000,0.147000000000000,0.150000000000000,0.153000000000000,0.155000000000000,0.155000000000000,0.152000000000000,0.144000000000000,0.131000000000000,0.113000000000000,0.0880000000000000,0.0550000000000000,0.0210000000000000];
Beta_deg = [37.6400000000000,44.4600000000000,47.7900000000000,46.7100000000000,43.6300000000000,39.8200000000000,36.0600000000000,32.7700000000000,29.9900000000000,27.6200000000000,25.5400000000000,23.8000000000000,22.2500000000000,20.7800000000000,19.5600000000000,18.0400000000000,16,13.9300000000000];
no_elements = length(r_by_R);
r = R.*r_by_R;
c = R.*c_by_R;
del_r = r(5) - r(4);%Same across all given data points
for i = 1:1:no_elements
    ID(i) = i;
end

for i = 1:1:no_elements
    del_A(i) = c(i)*del_r;
    V(i) = V_0_fts;
    Omega_x_r(i) = Omega*r(i);
    V_R(i) = sqrt((V(i)^2)+(Omega_x_r(i)^2));
    M(i) = V_R(i)/a_alt;
    phi_rad(i) = atan(V(i)/Omega_x_r(i));
    phi_deg(i) = rad2deg(phi_rad(i));
end
alpha_zl_deg = 0.*(ones(1,no_elements));
alpha_zl_rad = deg2rad(alpha_zl_deg);
C_l_eqn = @(alpha_deg) (-0.000004582*alpha_deg^4) - (0.00002926*alpha_deg^3)...
          + (0.000249*alpha_deg^2) + (0.07239*alpha_deg) + 0.4426;
C_d_eqn = @(alpha_deg) (0.000006844*alpha_deg^3) + (0.0003439*alpha_deg^2)...
          + (0.003488*alpha_deg) + 0.01996;
%Columns 21 and 22 contain the differential lift and drag acting on element 
w(1:no_elements,1) = 1;%ft/s
alpha_deg(1:no_elements,1) = 7.143;%deg;
alpha_rad(1:no_elements,1) = deg2rad(alpha_deg(1:no_elements,1));%rad
for i = 1:1:no_elements
    Beta_rad(i) = deg2rad(Beta_deg(i));
    for j = 1:1:1
        V_E(i,j) = sqrt(((w(i,j)+V_0_fts)^2)+(Omega_x_r(i)^2));
        f_w(i,j) = (((8*pi*r(i))/(n_blades*c(i)))*w(i,j))-((V_E(i,j)/...
        (V_0_fts+w(i,j)))*((C_l_eqn(alpha_deg(i,j))*Omega_x_r(i))-(C_d_eqn...
        (alpha_deg(i,j))*(w(i,j)*V_0_fts))));
        f_prime_w(i,j) = ((8*pi*r(i))/(n_blades*c(i))) - (((C_l_eqn...
        (alpha_deg(i,j))*Omega_x_r(i)))*((1/V_E(i,j))-(V_E(i,j)/((V_0_fts+w...
        (i,j))^2)))) + (C_d_eqn(alpha_deg(i,j))*((w(i,j)*V_0_fts)/(V_E(i,j))));
        w(i,j+1) = w(i,j) - ((f_w(i,j))/(f_prime_w(i,j)));
        diff(i,j) = w(i,j+1) - w(i,j);
        alpha_i_rad(i,j) = atan(w(i,j)/V_E(i,j));  
        alpha_i_deg(i,j) = rad2deg(alpha_i_rad(i,j));
        alpha_rad(i,j+1) = Beta_rad(i)-phi_rad(i)-alpha_i_rad(i,j)+alpha_zl_rad(i);
        alpha_deg(i,j+1) = rad2deg(alpha_rad(i,j+1));
    end
    Re(i) = (rho(alt_op)*V_R(i)*c(i))/mew(alt_op);
    C_l(i) = C_l_eqn(alpha_deg(i,end));
    C_d(i) = C_d_eqn(alpha_deg(i,end));
    d_L(i) = 0.5*rho(alt_op)*V_R(i)*V_R(i)*c(i)*C_l(i)*del_r;
    d_D(i) = 0.5*rho(alt_op)*V_R(i)*V_R(i)*c(i)*C_d(i)*del_r;
end
for i = 1:1:no_elements
    %defining the prandtl tip and hub loss corrections
%     P_tip(i) = (n_blades/2)*((R-r(i))/(r(i)*sin(phi_rad(i))));
%     F_tip(i) = (2/pi)*acos(exp(-P_tip(i)));
%     P_hub(i) = (n_blades/2)*((r(i)-R_hub)/(r(i)*sin(phi_rad(i))));
%     F_hub(i) = (2/pi)*acos(exp(-P_hub(i)));
    F_P(i) = 1;%F_tip(i)*F_hub(i);
    d_T(i) = F_P(i)*((d_L(i)*cos(phi_rad(i)+alpha_i_rad(i,end))) - ...
    (d_D(i)*sin(phi_rad(i)+alpha_i_rad(i,end))));
    d_Q(i) = F_P(i)*(r(i)*((d_L(i)*sin(phi_rad(i)+alpha_i_rad(i,end)))+(d_D(i)*cos...
    (phi_rad(i)+alpha_i_rad(i,end)))));
    d_P(i) = F_P(i)*(Omega_x_r(i)*((d_L(i)*sin(phi_rad(i)+alpha_i_rad(i,end)))+...
    (d_D(i)*cos(phi_rad(i)+alpha_i_rad(i,end)))));
end
%Total values
Thrust = n_blades*sum(d_T);
Torque = n_blades*sum(d_Q);  
Power = n_blades*sum(d_P);
power_hp = Power/550;
%Coefficients
C_P = Power/(rho(alt_op)*(n^3)*((Dia_prop/12)^5));
C_T = Thrust/(rho(alt_op)*(n^2)*((Dia_prop/12)^4));
C_Q = Torque/(rho(alt_op)*(n^2)*((Dia_prop/12)^5));
%prop efficiency calculation
J = V_0_fts/(n*(Dia_prop/12));
eeta_p = J*(C_T/C_P);
end