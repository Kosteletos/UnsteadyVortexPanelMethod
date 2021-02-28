
function [alpha, alphaDot] = rotation(t, dt, optimisationFlag, deltaLift, alphaPrev, alpha0,vel)
%Defines the rotation of the plate

global chord rho

if optimisationFlag == 0
    
    % Prescribed rotation
    %omega = 0.8;
    %alpha = omega*t;
    %alphaDot = omega;
    
    % Constant alpha
    alpha = 0.05; 
    alphaDot = (alpha - alpha0)/dt;
    if t == dt
        alphaDot = 0; % this is a poor fix as initial alphaDot could be non-zero
    end
    %alpha = pi/4 + 0.035;

elseif optimisationFlag == 1
    
    
    % Lift mitigation
    cl = deltaLift/(0.5*rho*norm(vel)^2*chord);
    alpha = alphaPrev + cl/(2*pi*600); %500 for 1 chords/s, 10 for 10 chords/s
    if abs(alpha)> pi
       alpha = 0; 
    end
    alphaDot = (alpha - alpha0)/dt;  
else
    
    alpha = alpha0; 
    alphaDot = (alpha - alpha0)/dt;

end


end

