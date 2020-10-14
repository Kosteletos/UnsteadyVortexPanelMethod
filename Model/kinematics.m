function [pos, vel, alpha, alphaDot] = kinematics(t)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
vel = [1,0]; % e.g. moving to the left at constant speed => [1,0]
pos = [vel(1)*t,vel(2)*t];

%omega = 1;
%alpha = sin(omega*t);
%alphaDot = omega*cos(omega*t);

%alphaDot = 1;
%alpha = alphaDot * t;

alphaDot = 0;
alpha = pi/4;

end

