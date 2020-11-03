function [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, deltaLift, alphaPrev, alpha0, rho, chord, it)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
%vel = [-1,0];
%pos = vel*t;


accel = [-1, 0]; % e.g. moving to the left at constant acceleration => [-1,0]
vel = accel*t; 
pos = (accel*t^2)/2;

if optimisationFlag == 0
    alphaDot = 0;
    %alpha = pi/4 + 0.035;
    alpha = pi/4; 
elseif optimisationFlag == 1
    %alpha = alphaPrev + deltaLift*0.015; %a good value when forces aren't dimensional
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*100);
    alphaDot = (alpha - alpha0)/dt;  
else
    alpha = alphaPrev;
    alphaDot = 0;
end

end

