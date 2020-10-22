function [uv] = inducedVelocity(gam,xy,xyVortex)
%Calculate the induced velocity uv at a point xy due to a list of vortices at
% xyVortex

dxy = xy-xyVortex;
r = vecnorm(dxy.')';
R = 1.5e-4 ;

% Rankine Vortex

idx = r<R; 

uv = gam ./(2.*pi.*r.^2).*([0,1;-1,0]*dxy.').'; 

if idx ~= 0 
    uv(idx,1:2) = gam.*r./(2*pi*R^3).*([0,1;-1,0]*dxy.').';
end

end

