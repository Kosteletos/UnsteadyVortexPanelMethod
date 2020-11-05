function plotForces(Lift, Drag, cl, alpha, alphaDot, dt)
%Plot force, alpha, and alphaDot obtained for the flow.

length = size(Lift);

t = 0:dt:(dt*length);

plot(t(2:length(1)), Lift(2:length(1)));
hold on
plot(t(2:length(1)), 5*alpha(2:length(1)));
plot(t(2:length(1)), cl(2:length(1)));
%plot(t(2:length(1)), 0.01*alphaDot(2:length(1)));
hold off
legend("Lift","5*alpha", "cl","0.01*alphaDot",'Location','northwest');
xlabel("Time (s)")
end

