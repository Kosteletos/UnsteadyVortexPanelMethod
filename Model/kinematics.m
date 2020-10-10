function [pos, vel, alpha, alphaDot] = kinematics(t)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
vel = [-1,0];
pos = [vel(1)*t,vel(2)*t];

%omega = 0.2;
%alpha = sin(omega*t);
%alphaDot = omega*cos(omega*t);

%alphaDot = 0.01;
%alpha = alphaDot * t;

alphaDot = 0;
alpha = 1;

end

