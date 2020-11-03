function plotForces(Lift, Drag, alpha, alphaDot, dt)
%Plot force, alpha, and alphaDot obtained for the flow.

length = size(Lift);

t = 0:dt:(dt*length);

plot(t(2:length(1)), Lift(2:length(1)));
hold on
plot(t(2:length(1)), 0.05*alpha(2:length(1)));
%plot(t(2:length(1)), 0.01*alphaDot(2:length(1)));
hold off
legend("Lift","0.05*alpha","0.01*alphaDot",'Location','southwest');
xlabel("Time (s)")
end

