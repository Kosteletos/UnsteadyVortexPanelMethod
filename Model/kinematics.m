function [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, startOptimise, deltaLift, alphaPrev, alpha0, pos,vel)
%Defines the movement of the plate 

%position, velocity and rotation of moving ref frame
%vel = [-1,0];
%pos = vel*t;

global chord rho

accel = [-1.2, 0]; % e.g. moving to the left at unit constant acceleration => [-1,0]

if optimisationFlag == 0
    % Surge Translation
    %vel = accel*t; 
    %pos = (accel*t^2)/2;
    
    % SS Translation
    vel = [-0.24,0];
    pos = vel*t;
    
    % Prescribed rotation
    %omega = 0.8;
    %alpha = omega*t;
    %alphaDot = omega;
    
    % Constant alpha
    alpha = 0.2; 
    alphaDot = (alpha - alpha0)/dt;
    if t == dt
        alphaDot = 0; % this is a poor fix as initial alphaDot could be non-zero
    end
    %alpha = pi/4 + 0.035;

elseif optimisationFlag == 1
    
    % Surge Translation if t_opt = 2
    vel = accel/2 + accel*(t-startOptimise);   % v = u0 + a*(t-tstart) 
    pos = accel/8 + accel/2*(t-startOptimise) + (accel*(t-startOptimise)^2)/2; % s = s0 + u(t-tStart) + 0.5a(t-tStart)^2
    
    
    % Lift mitigation
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*10); %500 for 1 chords/s, 10 for 10 chords/s
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

