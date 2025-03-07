%This Code allows the visualization of the trends which will be generated
%by the BEMT code for the propeller performance thereby allowing a better
%comparison of these trends with the ones in online data
clc;clear variables;close all
%FIRST LET US IMPORT THE DATA FROM THE BET CODE
%The function itself has 14x13 prop geometry data from UIUC website
%Defining the different velocity sets against each RPM
Velocities_structure(1).V = 1:1:15;%mph
Velocities_structure(2).V = 1:1:30;%mph
Velocities_structure(3).V = 1:1:46;%mph
Velocities_structure(4).V = 1:1:61;%mph
Velocities_structure(5).V = 1:1:76;%mph
Velocities_structure(6).V = 1:1:92;%mph
Velocities_structure(7).V = 1:1:107;%mph
Velocities_structure(8).V = 1:1:122;%mph
Velocities_structure(9).V = 1:1:137;%mph
Velocities_structure(10).V = 1:1:152;%mph
Velocities_structure(11).V = 1:1:168;%mph
Velocities_structure(12).V = 1:1:183;%mph
Velocities_structure(13).V = 1:1:199;%mph
Velocities_structure(14).V = 1:1:214;%mph
%defining the RPMs in the performance file
RPMs = 1000:1000:14000;
altitude = 1;%n x 1000 ft
figure(1)
for i = 1:1:length(Velocities_structure)
    for j = 1:1:length(Velocities_structure(i).V)
        [Thrust(i,j), Torque(i,j), Power(i,j), power_hp(i,j), C_P(i,j),...
         C_T(i,j), C_Q(i,j), J(i,j), eeta_p(i,j)] =...
         Propeller_Performance_via_BET_iterative_14x13_EQN_func(...
              Velocities_structure(i).V(j), RPMs(i), altitude);
    end
    plot(Velocities_structure(i).V,eeta_p(i,:),'LineWidth',1.5); hold on  
end
legend(num2str(RPMs'),'Location','East')
grid on;hold on;
xlabel('V_{mph}');ylabel('eeta')
title('14x13 propeller efficiencies at different RPMs (BEMT code)')

%NOW LET US IMPORT THE DATA FROM THE PERFORMANCE FILE
filename = 'PER3_14x13.dat';
[V_mat,J_mat,Pe_mat,Ct_mat,Cp_mat,PWR_mat,Torque_mat,Thrust_mat]=...
          prop_perf_read_function(filename);
figure(3)
for i = 1:1:length(V_mat(1,:))
    plot(V_mat(:,i),Pe_mat(:,i));hold on    
end
legend(num2str(RPMs'),'Location','East')
grid on;hold on;
xlabel('V_{mph}');ylabel('eeta')
title('14x13 propeller efficiencies at different RPMs (PERF File)')

