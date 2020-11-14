function [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, deltaLift, alphaPrev, alpha0, rho, chord, pos,vel)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
%vel = [-1,0];
%pos = vel*t;


accel = [-0.3, 0]; % e.g. moving to the left at constant acceleration => [-1,0]

if optimisationFlag == 0
    vel = accel*t; 
    pos = (accel*t^2)/2;
    
    alphaDot = 0;
    %alpha = pi/4 + 0.035;
    alpha = pi/4; 
elseif optimisationFlag == 1
    vel = accel*t; 
    pos = (accel*t^2)/2;
    
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*100);
    alphaDot = (alpha - alpha0)/dt;  
else
    alpha = alphaPrev;
    alphaDot = 0;
    pos = pos + vel*dt;
end


%vel = [-0.3,0];
%pos = vel*t;


end

