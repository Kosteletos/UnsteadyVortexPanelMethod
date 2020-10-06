function [uv] = inducedVelocity(gam,xy,xyVortex)
%Calculate the induced velocity uv at a point xy due to a vortex at
%xyVortex
x = xy(1);
y = xy(2);

xV = xyVortex(1);
yV = xyVortex(2);

rSqr = (x-xV)^2+(y-yV)^2;

u = (gam/(2*pi))*(y-yV)/rSqr;
v = (-gam/(2*pi))*(x-xV)/rSqr;

uv = [u,v];

end

