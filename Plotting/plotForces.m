function plotForces(Lift,Drag,dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

length = size(Lift);

t = 0:dt:(dt*length);

plot(t(2:length(1)), Lift(2:length(1)));
hold on
plot(t(2:length(1)), Drag(2:length(1)));
hold off
end

