function plotAlpha(alpha, alphaDot, LEVortex, pos, dt)
%Plot alpha and alphaDot

global chord folder subfolder

length = size(alpha);
t = 0:dt:(dt*length);

alpha_deg = alpha*180/pi;

% Alpha - Time Plot
figure(4)
plot(t(4:length(1)), alpha_deg(4:length(1)));
ylabel('Alpha [deg]')
xlabel("Time (s)")
title("PM  Alpha - Time")
if LEVortex == 1
    savefig(fullfile(folder,subfolder,"PM LEV alpha - time.fig"))
else
    savefig(fullfile(folder,subfolder,"PM alpha - time.fig"))
end

% Cl - Displacement Plot
figure(5)
s_ov_c = -pos(:,1)/chord;

plot(s_ov_c(4:length(1)), alpha_deg(4:length(1)));

ylabel('Alpha [deg]')
xlabel("Displacement (s / c)")
title("PM  Alpha - Displacement")
if LEVortex == 1
    savefig(fullfile(folder,subfolder,"PM LEV alpha - displacement.fig"))
else
    savefig(fullfile(folder,subfolder,"PM alpha - displacement.fig"))
end

end

