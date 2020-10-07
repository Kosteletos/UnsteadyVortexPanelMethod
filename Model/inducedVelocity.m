function [uv] = inducedVelocity(gam,xy,xyVortex)
%Calculate the induced velocity uv at a point xy due to a vortex at
%xyVortex

dxy = xy-xyVortex;
rSqr = norm(dxy)^2;

uv = gam/(2*pi*rSqr)*[dxy(2),-dxy(1)];

end

