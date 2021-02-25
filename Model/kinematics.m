function [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, startOptimise, deltaLift, alphaPrev, alpha0, pos,vel)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
%vel = [-1,0];
%pos = vel*t;

global chord rho

accel = [-0.12, 0]; % e.g. moving to the left at unit constant acceleration => [-1,0]

if optimisationFlag == 0
    vel = accel*t; 
    pos = (accel*t^2)/2;
    
    %vel = [-0.4,0];
    %pos = vel*t;
    
    %omega = 0.8;
    %alpha = omega*t;
    %alphaDot = omega;
    
    alpha = pi/4; 
    alphaDot = (alpha - alpha0)/dt;
    if t == dt
        alphaDot = 0; % this is a poor fix as initial alphaDot could be non-zero
    end
    %alpha = pi/4 + 0.035;

elseif optimisationFlag == 1
    %vel = accel*t; 
    %pos = (accel*t^2)/2;
    
    vel = [-0.06,0] + accel*(t-startOptimise);   % v = u0 + a*(t-tstart) 
    pos = -0.015 + [-0.06,0]*(t-startOptimise) + (accel*(t-startOptimise)^2)/2; % s = s0 + u(t-tStart) + 0.5a(t-tStart)^2
    
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*500); %500 for 1 chords/s, 10 for 10 chords/s
    if abs(alpha)> pi
       alpha = 0; 
    end
    alphaDot = (alpha - alpha0)/dt;  
else
    pos = pos + vel*dt;
    accel = [0,0];
    
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*100);
    if abs(alpha)> pi
       alpha = 0; 
    end
    alphaDot = (alpha - alpha0)/dt;  
    

end


%vel = [-0.36,0];
%pos = vel*t;


end

