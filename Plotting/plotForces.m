function plotForces(Lift, Drag, alpha, dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

length = size(Lift);

t = 0:dt:(dt*length);

plot(t(2:length(1)), Lift(2:length(1)));
hold on
plot(t(2:length(1)), 0.05*alpha(2:length(1)));
hold off
legend("Lift","0.05*AoA");
end

