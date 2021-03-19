function [pos, vel] = translation(t)
%Defines the translation of the plate 

pos = zeros(length(t),2);
vel = zeros(length(t),2);


% Constant
% vel = vel + [-2,0];

% Surge
% accel = [-2, 0]; % e.g. moving to the left at unit constant acceleration => [-1,0]
% vel = t.'*accel; 

% % %SS -> accel -> ss
t1 = 1.5; i1 = t <= t1;
t2 = t1+0.5; i2 = (t <= t2) & (t > t1);
i3 = t>t2;

v1 = [-2, 0];
v2 = [-4, 0];


% 0 < t < t1       Steady-state
vel(i1,:) = vel(i1,:) + v1;

% t1 < t < t2      Acceleration
accel = (v2-v1)/(t2-t1);
vel(i2,:) = vel(i2,:) + v1 + ((t(i2)-t1)).'*accel;

% t2 < t < tmax    Steady-state
vel(i3,:) = vel(i3,:) + v2;

% % SS -> Accel -> Deccel -> SS
% t1 = 15; i1 = t <= t1;
% t2 = 16; i2 = (t <= t2) & (t > t1);
% t3 = 17; i3 = (t <= t3) & (t > t2);
% i4 = t>t3;
% 
% v1 = [-1,0];
% v2 = [-2,0];
% 
% 
% % 0 < t < t1       Steady-state
% vel(i1,:) = vel(i1,:) + v1;
% % t1 < t < t2      Acceleration
% accel = (v2-v1)/(t2-t1);
% vel(i2,:) = vel(i2,:) + v1 + (t(i2)-t1).'*accel;
% % t2 < t < t3      Decceleration
% accel = (v1-v2)/(t3-t2);
% vel(i3,:) = vel(i3,:) + v2 + (t(i3)-t2).'*accel;
% 
% % t2 < t < tmax    Steady-state
% vel(i4,:) = vel(i4,:) + v1;

%%
% pos
pos = cumtrapz(t,vel);

end
