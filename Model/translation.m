function [pos, vel] = translation(t)
%Defines the translation of the plate 

pos = zeros(length(t),2);
vel = zeros(length(t),2);


% Constant
vel = vel + [-0.12,0];
pos = pos + [t.'.*vel(:,1),t.'.*vel(:,1)];

% Surge
%accel = [-1.2, 0]; % e.g. moving to the left at unit constant acceleration => [-1,0]
%vel = t.'*accel; 
%pos = ((t.^2).'*accel)/2;

% SS -> accel -> ss
% t1 = 1.0; i1 = t <= t1;
% t2 = 1.5; i2 = (t <= t2) & (t > t1);
% i3 = t>t2;
% 
% v1 = [-0.24, 0];
% v2 = [-0.48, 0];
% 
% % 0 < t < t1       Steady-state
% vel(i1,:) = vel(i1,:) + v1;
% 
% % t1 < t < t2      Acceleration
% accel = (v2-v1)/(t2-t1);
% vel(i2,:) = vel(i2,:) + v1 + ((t(i2)-t1)).'*accel;
% 
% % t2 < t < tmax    Steady-state
% vel(i3,:) = vel(i3,:) + v2;
% 
% % pos
% pos = cumtrapz(t,vel);

end
