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

    % velocity due to kinematics
    inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame

    uvKinVel = zeros(inputSize(1), 2); 
    uvKinRot = zeros(inputSize(1), 2);

    uvKinVel = uvKinVel + (inerToRel*vel.').';
    if inputSize(1) >0
        uvKinRot(:,1:2) = [-alphaDot*xygFSVortex_rel(:,2),alphaDot*xygFSVortex_rel(:,1)];
    end
    uvKinematics = uvKinVel - uvKinRot;

    xygFSVortex_rel_positions = xygFSVortex_rel(:,1:2);

    %Contribution due to bound vorticity (not including Wake)
    [uvBoundVorticity_x, uvBoundVorticity_y] = inducedVelocityMat(gam(startPoint:endPoint),xygFSVortex_rel_positions,xyBoundVortex_rel(startPoint:endPoint,:));
    uvBoundVorticity = [sum(uvBoundVorticity_x).', sum(uvBoundVorticity_y).'];
    
    % Contribution due wake vortices (including TE wake)
    [uvWakeVorticity_x, uvWakeVorticity_y] = inducedVelocityMat(xygFSVortex_rel(:,3),xygFSVortex_rel_positions,xygFSVortex_rel_positions);
    uvWakeVorticity = [sum(uvWakeVorticity_x).', sum(uvWakeVorticity_y).'];
    
    % Distance travelled by vortices
    dxy = (uvBoundVorticity + uvWakeVorticity - uvKinematics) * dt;
    
    % New vortex positions & magnitudes
    NEWxygFSVortex_rel = xygFSVortex_rel + [dxy,zeros(inputSize(1),1)];
end

