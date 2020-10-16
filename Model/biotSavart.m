function [NEWxygFSVortex_rel] = biotSavart(dt, np, vel, alpha, alphaDot, xyPanel_rel, xyBoundVortex_rel, gam, xygFSVortex_rel)
% Vortex transport of existing vortices and movement of LE and TE
% vortices into free stream

%TE Vortex release
xygFSVortex_rel = [xygFSVortex_rel; xyBoundVortex_rel(end,1) ,xyBoundVortex_rel(end,2), gam(end)];

% LE Vortex release
xygFSVortex_rel = [xyBoundVortex_rel(1,1), xyBoundVortex_rel(1,2), gam(1) ; xygFSVortex_rel];


inputSize = size(xygFSVortex_rel);
NEWxygFSVortex_rel = zeros(inputSize);

% velocity due to kinematics
inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame
    
uvKinVel = zeros(inputSize(1), 2); 
uvKinRot = zeros(inputSize(1), 2);
    
uvKinVel = uvKinVel + (inerToRel*vel.').';
if inputSize(1) >0
    uvKinRot(:,1:2) = [-alphaDot*xygFSVortex_rel(:,2),alphaDot*xygFSVortex_rel(:,1)];
end
uvKinematics = uvKinVel - uvKinRot;

for i = 1:inputSize(1)
    
    % Contribution due to bound vorticity (not including TE Wake)
    uvBoundVorticity = [0,0];
    for j = 2:np
        uvBoundVorticity = uvBoundVorticity + inducedVelocity(gam(j), xygFSVortex_rel(i,1:2), xyBoundVortex_rel(j,:));
    end     

    % Contribution due wake vortices (including TE wake)
    uvWakeVorticity = [0,0];
    for k = 1:inputSize(1)
        if k ~= i            
            uvWakeVorticity = uvWakeVorticity + inducedVelocity(xygFSVortex_rel(k,3), xygFSVortex_rel(i,1:2), xygFSVortex_rel(k,1:2));
        end
    end
    
    % Distance travelled by vortex
    dxy = (uvBoundVorticity + uvWakeVorticity - uvKinematics(i,:)) * dt;

    % New vortex position & magnitude
    NEWxygFSVortex_rel(i,:) = xygFSVortex_rel(i,:) + [dxy,0];
end



end

