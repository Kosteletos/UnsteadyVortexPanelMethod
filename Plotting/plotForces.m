function plotForces(Lift, Lift_am, Drag, cl, alpha, alphaDot, pos, dt)%, PIV)
%Plot force, alpha, and alphaDot obtained for the flow.

global chord

length = size(Lift);

t = 0:dt:(dt*length);
Lift_c = Lift - Lift_am;


% Lift - Time Plot
figure(2)
%yyaxis left
plot(t(5:length(1)), Lift(5:length(1)),'k');
ylabel('Lift [N]')
hold on
plot(t(5:length(1)), Lift_am(5:length(1)),'b');
plot(t(5:length(1)), Lift_c(5:length(1)),'g');

yyaxis right
ylabel('alpha [deg]')
alpha = alpha*180/pi;
plot(t(4:length(1)), alpha(4:length(1)));
%plot(t(2:length(1)), cl(2:length(1)));
%plot(t(2:length(1)), 0.01*alphaDot(2:length(1)));
%plot((PIV.Time - PIV.Time(1)), -PIV.Lift)
hold off
legend("Total Lift", "Added-Mass","Circulatory","alpha") %, "cl", "0.01*alphaDot",'Location','northwest');
%legend("lift", "Experimental Lift")
%legend("lift", "Added-mass", "Circulatory")
xlabel("Time (s)")
title("Lift - Time")


% Lift - Displacement Plot
figure(3)
s_ov_c = -pos(:,1)/chord;

plot(s_ov_c(5:length(1)), Lift(5:length(1)));
hold on 
plot(s_ov_c(5:length(1)), Lift_am(5:length(1)));
plot(s_ov_c(5:length(1)), Lift_c(5:length(1)));
hold off 
ylabel('Lift [N]')
xlabel("Displacement (s / c)")
legend("Total Lift", "Added-mass", "Circulatory")
title("Lift - Displacement")

end

