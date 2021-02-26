function plotKinematics(dt,pos,vel)
% velocity - time and displacement - time graphs

global chord rho folder subfolder

length = size(pos);
t = 0:dt:(dt*(length(1)-1));
vel_x = -vel(:,1);
pos_x = -pos(:,1);

% Velocity Time
figure(6)
plot(t(2:end),vel_x(2:end))
ylabel("Velocity [m/s]")
xlabel("Time [s]")
savefig(fullfile(folder,subfolder,"vel - time"))

% Position Time
figure(7)
plot(t ,pos_x)
ylabel("Displacement [m]")
xlabel("Time [s]")
savefig(fullfile(folder,subfolder,"pos - time"))

end

