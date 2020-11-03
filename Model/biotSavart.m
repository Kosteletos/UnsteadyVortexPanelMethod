function [NEWxygFSVortex_rel] = biotSavart(LEVortex, TEVortex, dt, np, vel, alpha, alphaDot, xyBoundVortex_rel, gam, xygFSVortex_rel)
% Vortex transport of existing vortices and movement of LE and TE
% vortices into free stream

%TE Vortex release
if TEVortex == 1
    xygFSVortex_rel = [xygFSVortex_rel; xyBoundVortex_rel(end,1) ,xyBoundVortex_rel(end,2), gam(end)];
    endPoint = np;
else
    endPoint = np+1;
end

% LE Vortex release
if LEVortex ==1 
    xygFSVortex_rel = [xyBoundVortex_rel(1,1), xyBoundVortex_rel(1,2), gam(1) ; xygFSVortex_rel];
    startPoint = 2;
else
    startPoint = 1;
end

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


gam_sliced = gam(startPoint:endPoint);
xyBoundVortex_rel_sliced = xyBoundVortex_rel(startPoint:endPoint,:);
xygFSVortex_rel_positions = xygFSVortex_rel(:,1:2);
xygFSVortex_rel_gam = xygFSVortex_rel(:,3);
parfor i = 1:inputSize(1)
    
    %Contribution due to bound vorticity (not including Wake)
    uvBoundVorticity = sum(inducedVelocity(gam_sliced, xygFSVortex_rel_positions(i,:), xyBoundVortex_rel_sliced));
    uvBoundVorticityRef(i,:) = uvBoundVorticity;
    
    
    % Contribution due wake vortices (including TE wake)
    uvWakeVorticity =  sum(inducedVelocity(xygFSVortex_rel_gam, xygFSVortex_rel_positions(i,:), xygFSVortex_rel_positions));
    
    % Distance travelled by vortex
    dxy = (uvBoundVorticity + uvWakeVorticity - uvKinematics(i,:)) * dt;

    % New vortex position & magnitude
    NEWxygFSVortex_rel(i,:) = xygFSVortex_rel(i,:) + [dxy,0];
end

    [uv_BoundVorticityTest_x, uv_BoundVorticityTest_y] = inducedVelocityMat(gam_sliced,xygFSVortex_rel_positions,xyBoundVortex_rel_sliced);


end

