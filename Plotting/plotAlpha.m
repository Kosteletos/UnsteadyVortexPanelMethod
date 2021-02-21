function plotAlpha(alpha, alphaDot, pos, dt)
%Plot alpha and alphaDot

global chord

length = size(alpha);
t = 0:dt:(dt*length);

alpha_deg = alpha*180/pi;

% Alpha - Time Plot
figure(4)
plot(t(4:length(1)), alpha_deg(4:length(1)));
ylabel('Alpha [deg]')
xlabel("Time (s)")
title("PM  Alpha - Time")


% Cl - Displacement Plot
figure(5)
s_ov_c = -pos(:,1)/chord;

plot(s_ov_c(4:length(1)), alpha_deg(4:length(1)));

ylabel('Alpha [deg]')
xlabel("Displacement (s / c)")
title("PM  Alpha - Displacement")

end

