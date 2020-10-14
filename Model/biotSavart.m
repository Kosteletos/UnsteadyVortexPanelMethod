function [xygFSVortex_rel] = biotSavart(dt, np, vel, alpha, alphaDot, xyPanel_rel, xyBoundVortex_rel, gam, xygFSVortex_rel)
% Vortex transport of existing vortices and movement of LE and TE
% vortices into free stream

%TE Vortex release
xygFSVortex_rel = [xygFSVortex_rel; xyBoundVortex_rel(end,1) ,xyBoundVortex_rel(end,2), gam(end)];

% LE Vortex release
%xygFSVortex_rel = [xyPanel_rel(1,1), xyPanel_rel(1,2), 0.5*gam(1) ; xygFSVortex_rel];


inputSize = size(xygFSVortex_rel);

% velocity due to kinematics
inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame
    
uvKinVel = zeros(inputSize(1), 2); 
uvKinRot = zeros(inputSize(1), 2);
    
uvKinVel = uvKinVel + (inerToRel*vel.').';
uvKinRot(:,1:2) = [-alphaDot*xygFSVortex_rel(:,2),alphaDot*xygFSVortex_rel(:,1)];
uvKinematics = uvKinVel - uvKinRot;

xygFSVortex_rel(:,1:2) = xygFSVortex_rel(:,1:2) - uvKinematics*dt;


for i = 1:inputSize(1)
    uv = [0,0];
    
    % Contribution due to bound vorticity (not including TE Wake)
    for j = 1:np
        uv = uv + inducedVelocity(gam(j), xygFSVortex_rel(i,1:2), xyBoundVortex_rel(j,:));
    end     

    % Contribution due wake vortices (including TE wake)
    for k = 1:inputSize(1)
        if k ~= i            
            uv = uv + inducedVelocity(xygFSVortex_rel(k,3), xygFSVortex_rel(i,1:2), xygFSVortex_rel(k,1:2));
        end
    end
    
    % Distance travelled by vortex
    dxy = uv * dt;
    
    % New vortex position
    xygFSVortex_rel(i,:) = xygFSVortex_rel(i,:) + [dxy,0];
   
end


end

