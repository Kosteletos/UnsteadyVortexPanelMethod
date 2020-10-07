function [pos, vel, alpha, alphaDot] = kinematics(t)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
vel = [-1,0];
pos = [vel(1)*t,vel(2)*t];

omega = 0.5;
alpha = sin(omega*t);
alphaDot = omega*cos(omega*t);

end

