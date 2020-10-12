function [uv] = inducedVelocity(gam,xy,xyVortex)
%Calculate the induced velocity uv at a point xy due to a vortex at
%xyVortex

dxy = xy-xyVortex;
r = norm(dxy);
rSqr = r^2;
R = 1e-3 ;

% Rankine Vortex
if r < R
    uv = gam*r/(2*pi*R^3)*[dxy(2),-dxy(1)];
else
    uv = gam/(2*pi*rSqr)*[dxy(2),-dxy(1)]; 
end


end

