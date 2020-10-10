function [b] = buildRHS(xyCollocation, normal, np, pos, vel, thetaDot, theta, xygFSVortex, totalBoundCirc)
%Build RHS of matrix A.gam = b
b = zeros([np+1,1]);

for i = 1:np
    
    %Velocity due to flat plate kinematics 
    r = norm(xyCollocation(i,:) - pos);
    if i >= np/2
        r = -r;
    end
    
    uvKinematics = vel + thetaDot*r*[sin(theta), cos(theta)];
    
    % Wake induced velocity
    [noFreeVortices,~] = size(xygFSVortex);
    uvFSVortex = [0,0];
    for j = 1:noFreeVortices
        gam = xygFSVortex(j,3);
        uvFSVortex = inducedVelocity(gam,xyCollocation(i,:), xygFSVortex(j,1:2));
    end
    
    uv = uvFSVortex - uvKinematics;
    %Free stream velicity
    uv = uv + [1,0];
    
    b(i) = -dot(uv, normal);
end

b(np+1) = totalBoundCirc;

end

