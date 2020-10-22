function [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, deltaLift, alphaPrev, alpha0)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
%vel = [-1,0];
%pos = vel*t;


accel = [-1, 0];
vel = accel*t; % e.g. moving to the left at constant speed => [-1,0]
pos = (accel*t^2)/2;

%  omega = pi;
%  alpha = 0.5*sin(omega*t);
%  alphaDot = 0.5*omega*cos(omega*t);

%alphaDotDot = 1;
%alphaDot = alphaDotDot*t;
%alpha = alphaDotDot * t^2 / 2;

if optimisationFlag == 0
    alphaDot = 0;
    alpha = pi/4;
else 
    alpha = alphaPrev + deltaLift*0.001;
    alphaDot = (alpha - alpha0)/dt;
end
end

