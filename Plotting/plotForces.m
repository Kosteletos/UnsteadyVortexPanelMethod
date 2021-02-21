function plotForces(Lift, Lift_am, alpha, alphaDot, pos, vel, dt)%, PIV)
%Plot force, alpha, and alphaDot obtained for the flow.

global chord rho

characteristic_velocity = abs(vel(end,1));

length = size(Lift);
t = 0:dt:(dt*length);
Lift_c = Lift - Lift_am;
Cl_factor = 0.5*rho*chord*characteristic_velocity^2;


% Cl - Time Plot
figure(2)
plot(t(5:length(1)), Lift(5:length(1))/Cl_factor);
ylabel('C_l')
hold on
plot(t(5:length(1)), Lift_am(5:length(1))/Cl_factor);
plot(t(5:length(1)), Lift_c(5:length(1))/Cl_factor);

%yyaxis right
%ylabel('alpha [deg]')
%alpha = alpha*180/pi;
%plot(t(4:length(1)), alpha(4:length(1)));
%plot(t(2:length(1)), 0.01*alphaDot(2:length(1))); % plot alphaDot
%plot((PIV.Time - PIV.Time(1)), -PIV.Lift)  % compare PIV data with PM
hold off
legend("Total Lift", "Added-Mass","Circulatory","alpha","Location","northwest"); %, "cl", "0.01*alphaDot",'Location','northwest');
%legend("lift", "Experimental Lift")
%legend("lift", "Added-mass", "Circulatory")
xlabel("Time (s)")
title("PM  Lift Coefficient - Time")


% Cl - Displacement Plot
figure(3)
s_ov_c = -pos(:,1)/chord;

plot(s_ov_c(5:length(1)), Lift(5:length(1))/Cl_factor);
hold on 
plot(s_ov_c(5:length(1)), Lift_am(5:length(1))/Cl_factor);
plot(s_ov_c(5:length(1)), Lift_c(5:length(1))/Cl_factor);
hold off 
ylabel('C_l')
xlabel("Displacement (s / c)")
legend("Total Lift", "Added-mass", "Circulatory","Location","northwest");
title("PM  Lift Coefficient - Displacement")

end

