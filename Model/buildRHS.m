function [b] = buildRHS(xyCollocation, normal, np, pos, vel, thetaDot, theta, xygFSVortex, totalBoundCirc)
%Build RHS of matrix A.gam = b
b = zeros([np+1,1]);

for i = 1:np
    
    %Velocity induced due to flat plate velocity 
    r = norm(xyCollocation(i,:) - pos);
    uvKinematics = vel + thetaDot*r*[sin(theta), cos(theta)];
    
    % Wake induced velocity
    [noFreeVortices,~] = size(xygFSVortex);
    uvFSVortex = [0,0];
    for j = 1:noFreeVortices
        gam = xygFSVortex(j,3);
        xyFSVortex = [xygFSVortex(j,1), xygFSVortex(j,2)];
        uvFSVortex = inducedVelocity(gam,xyCollocation(i,:), xyFSVortex);
    end
    
    uv = uvFSVortex + uvKinematics;
    b(i) = -dot(uv, normal);
end

b(np+1) = totalBoundCirc;

end

