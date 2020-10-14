function [uv] = inducedVelocity(gam,xy,xyVortex)
%Calculate the induced velocity uv at a point xy due to a vortex at
%xyVortex

dxy = xy-xyVortex;
r = norm(dxy);
R = 1e-3 ;

% Rankine Vortex
if r < R
    uv = gam*r/(2*pi*R^3)*[0,1;-1,0]*dxy.'; 
else
    uv = gam /(2*pi*r^2)*[0,1;-1,0]*dxy.'; 
end

uv = uv.';
end

