function [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, deltaLift, alphaPrev, alpha0, rho, chord, pos,vel)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
%vel = [-1,0];
%pos = vel*t;


accel = [-0.4, 0]; % e.g. moving to the left at unit constant acceleration => [-1,0]

if optimisationFlag == 0
    vel = accel*t; 
    pos = (accel*t^2)/2;
    
    %vel = [-0.4,0];
    %pos = vel*t;
    
    alpha = pi/6; 
    alphaDot = (alpha - alpha0)/dt;
    if t == dt
        alphaDot = 0; % this is a poor fix
    end
    %alpha = pi/4 + 0.035;

elseif optimisationFlag == 1
    vel = accel*t; 
    pos = (accel*t^2)/2;
    
    %vel = [-0.4,0] + accel*(t-0.5); 
    %pos = [-0.4,0]*t + (accel*(t-0.5)^2)/2;
    
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*400);
    alphaDot = (alpha - alpha0)/dt;  
else
    pos = pos + vel*dt;
    accel = [0,0];
    
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*400);
    alphaDot = (alpha - alpha0)/dt;  
    

end


%vel = [-0.36,0];
%pos = vel*t;


end

