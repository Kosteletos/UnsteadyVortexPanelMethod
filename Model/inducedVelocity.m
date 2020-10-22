function [uv] = inducedVelocity(gam,xy,xyVortex)
%Calculate the induced velocity uv at a point xy due to a list of vortices at
% xyVortex

dxy = xy-xyVortex;
r = vecnorm(dxy.')';
R = 1.5e-4 ;

% Rankine Vortex

idx = r<R; 

uv = gam ./(2.*pi.*r.^2).*([0,1;-1,0]*dxy.').'; 

try
    uv(idx,:) = gam(idx,:).*r(idx,:)./(2*pi*R^3).*([0,1;-1,0]*dxy(idx,:).').';
catch
end

end

