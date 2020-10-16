function [b] = buildRHS(normal_rel, xyCollocation_rel, np, vel, alphaDot, alpha, xygFSVortex_rel, totalBoundCirc)
%Build RHS of matrix A.gam = b
b = zeros([np+1,1]);

    % velocity due to flat plate kinematics
    inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame
    
    uvKinVel = zeros(np,2); 
    uvKinRot = zeros(np,2);
    
    uvKinVel = uvKinVel - (inerToRel*vel.').';
    uvKinRot(:,2) = alphaDot*xyCollocation_rel(:,1);
    uvKinematics = uvKinVel + uvKinRot;
    
    % velocity due to wake 
    [noFreeVortices,~] = size(xygFSVortex_rel);
    uvFSVortex = zeros(np,2);
%     for i = 1:np
%         for j = 1:noFreeVortices
%             gam = xygFSVortex_rel(j,3);
%             uvFSVortex(i,:) = uvFSVortex(i,:) + inducedVelocity(gam,xyCollocation_rel(i,:), xygFSVortex_rel(j,1:2)); 
%         end
%     end
    if noFreeVortices ~= 0 
        for i = 1:np
            gam = xygFSVortex_rel(:,3);
            uvFSVortex(i,:) = uvFSVortex(i,:) + sum(inducedVelocity(gam,xyCollocation_rel(i,:), xygFSVortex_rel(:,1:2)));   
        end
    end
    
    uv = uvFSVortex(1:np,:) + uvKinematics;

    b(1:np) = -uv(:,1).*normal_rel(1) - uv(:,2).*normal_rel(2);
     
    b(np+1) = totalBoundCirc;

end

