function plotForces(Lift, LiftComponents, Drag, cl, alpha, alphaDot, dt)%, PIV)
%Plot force, alpha, and alphaDot obtained for the flow.

length = size(Lift);

t = 0:dt:(dt*length);
figure(2)
%yyaxis left
plot(t(4:length(1)), Lift(4:length(1)),'k');
ylabel('Lift [N]')
hold on
%plot(t(4:length(1)), LiftComponents(4:length(1),1),'r');
%plot(t(4:length(1)), LiftComponents(4:length(1),2),'b');

yyaxis right
ylabel('alpha [deg]')
alpha = alpha*180/pi;
plot(t(4:length(1)), alpha(4:length(1)));
%plot(t(2:length(1)), cl(2:length(1)));
%plot(t(2:length(1)), 0.01*alphaDot(2:length(1)));
%plot((PIV.Time - PIV.Time(1)), -PIV.Lift)
hold off
legend("Lift","alpha") %, "cl", "0.01*alphaDot",'Location','northwest');
%legend("lift", "Experimental Lift")
%legend("lift", "Added-mass", "Circulatory")
xlabel("Time (s)")
end

