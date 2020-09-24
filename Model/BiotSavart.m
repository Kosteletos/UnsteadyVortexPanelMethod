function [NEWxfsVortex,NEWyfsVortex,NEWgamfsVortex] = BiotSavart(FinalPanelCirc, dt, xs, ys, gam, xfsVortex, yfsVortex, gamfsVortex)
% Vortex transport of existing vortices and movement of trailing edge
% vortex into free stream

inputSize = size(xfsVortex);
NEWxfsVortex = zeros(inputSize);
NEWyfsVortex = zeros(inputSize);
NEWgamfsVortex = zeros(inputSize);

for i = 1:inputSize(2)
    u = 0;
    v = 0;
    for j = 1:(length(xs)-1)
        %[infau, infav, infbu, infbv ] = InfCoeffDerivative(xs(j),ys(j),xs(j+1),ys(j+1),xfsVortex(i),yfsVortex(i));
        %u = u + gam(j)*infau + gam(j+1)*infbu;
        %v = v + gam(j)*infav + gam(j+1)*infbv;
    end     
    u = u + 0.1; % needs deleting !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
    
    % Add contribution from other free vortices here
    for k = 1:inputSize(2)
        if k ~= i
            %relative coords
            delx = xfsVortex(k) - xfsVortex(i);
            dely = yfsVortex(k) - yfsVortex(i);
            r_sq = delx^2 + dely^2;
            
            u = u - dely*gamfsVortex(k)/(2*pi*r_sq);
            v = v + delx*gamfsVortex(k)/(2*pi*r_sq);
        end
    end
    
    % Distance travelled by vortex
    dx = u * dt;
    dy = v * dt;
    
    % New vortex position 
    NEWxfsVortex(i) = xfsVortex(i) + dx;
    NEWyfsVortex(i) = yfsVortex(i) + dy;
    NEWgamfsVortex(i) = gamfsVortex(i);
end

% Trailing edge circulation leaves trailing edge and joins free-stream
NEWxfsVortex = [NEWxfsVortex, xs(end)];
NEWyfsVortex = [NEWyfsVortex, ys(end)];
NEWgamfsVortex = [NEWgamfsVortex, FinalPanelCirc];

end

