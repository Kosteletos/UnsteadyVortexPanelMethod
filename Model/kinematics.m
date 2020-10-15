function [pos, vel, alpha, alphaDot] = kinematics(t)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
vel = [-1,0];
pos = vel*t;


%accel = [0, 0];
%vel = accel*t; % e.g. moving to the left at constant speed => [-1,0]
%pos = (vel*t^2)/2;

% omega = pi;
% alpha = 0.5*sin(omega*t);
% alphaDot = 0.5*omega*cos(omega*t);

% alphaDotDot = 1;
% alphaDot = alphaDotDot*t;
% alpha = alphaDotDot * t^2 / 2;

alphaDot = 0;
alpha = pi/4;

end

