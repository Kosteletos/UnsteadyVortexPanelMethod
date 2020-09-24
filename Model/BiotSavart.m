function [NEWxfsVortex,NEWyfsVortex,NEWgamfsVortex] = BiotSavart(FinalPanelCirc, xs, ys, xfsVortex, yfsVortex, gamfsVortex)
% Vortex transport of existing vortices and movement of trailing edge
% vortex to free stream

inputSize = size(fsVortex);
newfsVortex = inputSize; % fix the assignments
for i = 1:inputSize(1)
    u = 0;
    v = 0;
    for j = 1:length(xs)
        [infau, infav, infbu, infbv ] = InfCoeffDerivative(xs(j),ys(j),xs(j+1),ys(j+1),x(i),y(i));
        u = u + gamma_a*infau + gamma_b*infbu;
        v = v + gamma_a*infav + gamma_b*infbv;
    end     
    % Add contribution from other free vortices here
    
    %new vortex position 
    newfsVortex(i)
end

% Trailing edge circulation leaves trailing edge and joins free-stream
NEWxfsVortex = [NEWxfsVortex, xs(end)];
NEWyfsVortex = [NEWyfsVortex, ys(end)];
NEWgamfsVortex = [NEWgamfsVortex, FinalPanelCirc];

end

