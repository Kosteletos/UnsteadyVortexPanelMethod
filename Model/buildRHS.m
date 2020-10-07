function [b] = buildRHS(xyCollocation, normal, np, pos, vel, thetaDot, theta, xygFSVortex)
%Build RHS of matrix A.gam = b
b = zeros([np+1,1]);

for i = 1:np
    
    %Velocity induced due to flat plate velocity 
    r = norm(xyCollocation(1,:) - pos);
    uvKinematics = vel + thetaDot*r*[sin(theta), cos(theta)];
    
    % Wake vortices
    [noFreeVortices,~] = size(xygFSVortex);
    uvFSVortex = [0,0];
    for j = 1:noFreeVortices
        gam = xygFSVortex(j,3);
        xyFSVortex = [xygFSVortex(1,j), xygFSVortex(2,j)];
        uvFSVortex = inducedVelocity(gam,xyCollocation(:,i), xyFSVortex);
    end
    
    uv = uvFSVortex + uvKinematics;
    b(i) = -dot(uv, normal);
end

b(np+1) = 1; % <- needs to equal sum of vorticity in the flow

end

