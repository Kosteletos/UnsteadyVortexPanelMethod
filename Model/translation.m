function [pos, vel] = translation(t)
%Defines the translation of the plate 




pos = zeros(length(t),2);
vel = zeros(length(t),2);

% Constant velocity

vel = vel + [-1.2,0];
pos(:,1) = pos(:,1) + t.'.*vel(:,1);
pos(:,2) = pos(:,2) + t.'.*vel(:,1);

% Surge
%accel = [-1.2, 0]; % e.g. moving to the left at unit constant acceleration => [-1,0]
%vel = t.'*accel; 
%pos = ((t.^2).'*accel)/2;

% SS Translation
%vel = [-0.24,0];
%pos = vel*t;



% Surge Translation if t_opt = 2
%vel = accel/2 + accel*(t-startOptimiseTime);   % v = u0 + a*(t-tstart) 
%pos = accel/8 + accel/2*(t-startOptimiseTime) + (accel*(t-startOptimiseTime)^2)/2; % s = s0 + u(t-tStart) + 0.5a(t-tStart)^2
    





end
