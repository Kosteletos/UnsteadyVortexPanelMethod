function [b] = buildRHS(normal_rel, xyCollocation_rel, xyCollocation, normal, np, pos, vel, alphaDot, alpha, xygFSVortex_rel, totalBoundCirc)
%Build RHS of matrix A.gam = b
b = zeros([np+1,1]);

    % velocity due to flat plate kinematics
    inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame
    
    uvKinVel = zeros(np,2); 
    uvKinRot = zeros(np,2);
    
    uvKinVel = uvKinVel - (inerToRel*vel.').';
    uvKinRot(:,2) = alphaDot*xyCollocation_rel(:,1);
    uvKinematics = uvKinVel - uvKinRot;
    
    % velocity due to wake 
    [noFreeVortices,~] = size(xygFSVortex_rel);
    uvFSVortex = zeros(np,2);
    for i = 1:np
        for j = 1:noFreeVortices
            gam = xygFSVortex_rel(j,3);
            uvFSVortex(i,:) = uvFSVortex(i,:) + inducedVelocity(gam,xyCollocation_rel(i,:), xygFSVortex_rel(j,1:2)); 
        end
    end
    
    uv = uvFSVortex + uvKinematics;

    b(1:np) = uv(:,1).*normal_rel(1) + uv(:,2).*normal_rel(2);
    if noFreeVortices > 0
        b(np+1) = -sum(xygFSVortex_rel(:,3));
    else
        b(np+1) = 0;
    end

% for i = 1:np
%     
% 
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     %Velocity due to flat plate kinematics 
%     r = norm(xyCollocation(i,:) - pos);
%     if i >= np/2
%         r = -r;
%     end
%     
%     uvKinematics = vel + alphaDot*r*[sin(alpha), cos(alpha)];
%     
%     % Wake induced velocity
%     [noFreeVortices,~] = size(xygFSVortex);
%     uvFSVortex = [0,0];
%     for j = 1:noFreeVortices
%         gam = xygFSVortex(j,3);
%         uvFSVortex = inducedVelocity(gam,xyCollocation(i,:), xygFSVortex(j,1:2));
%     end
%     
%     uv = uvFSVortex - uvKinematics;
%     
%     b(i) = -dot(uv, normal);
% end
% 
% b(np+1) = totalBoundCirc;

end

