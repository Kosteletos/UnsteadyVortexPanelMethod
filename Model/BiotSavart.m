function [NEWxygFSVortex] = biotSavart(dt, np, xyPanel, xyBoundVortex, gam, xygFSVortex)
% Vortex transport of existing vortices and movement of trailing edge
% vortex into free stream

inputSize = size(xygFSVortex);
NEWxygFSVortex = zeros(inputSize);


for i = 1:inputSize(1)
    uv = [0,0];
    
    % Contribution due to bound vorticity
    for j = 1:np+1
        uv = uv + inducedVelocity(gam(j), xygFSVortex(i,1:2), xyBoundVortex(j,1:2)); %needs testing
    end     

    % Contribution due to other wake vortices
    for k = 1:inputSize(1)
        if k ~= i
            delxy = xygFSVortex(k,1:2)-xygFSVortex(i,1:2);
            r = norm(delxy);
            r_sq = r^2;
            
            uv = uv + (xygFSVortex(k,3)/(2*pi*r_sq))*[-delxy(2) , delxy(1)];
        end
    end
    
    % Distance travelled by vortex
    dxy = uv * dt;
    
    % New vortex position
    NEWxygFSVortex(i,:) = xygFSVortex(i,:) + [dxy,0];
   
end

% This needs work, the new vortex doesn't necessarily go at the end point
% of the panel, but more likely at 0.2-0.3 times the distance travelled by
% the trailing edge in this times step
NEWxygFSVortex = [NEWxygFSVortex; xyBoundVortex(end,1) ,xyBoundVortex(end,2), gam(end)];
NEWxygFSVortex = [xyPanel(1,1) ,xyPanel(1,2), gam(1) ; NEWxygFSVortex];
end

