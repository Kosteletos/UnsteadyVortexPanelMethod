function [newfsVortex] = BiotSavart(FinalPanelCirc, xs, ys, fsVortex)
% Vortex transport of existing vortices and movement of trailing edge
% vortex to free stream

inputSize = size(fsVortex);
newfsVortex = inputSize;
for i = 1:inputSize(1)
    for j = 1:inputSize(1)
        [infau, infav, infbu, infbv ] = InfCoeffDerivative(xa,ya,xb,yb,x,y)
        %[infa, infb] =  panelinf(xs(1),ys(1),xs(2),ys(2),xs(1:np),ys(1:np));
        
end

end

