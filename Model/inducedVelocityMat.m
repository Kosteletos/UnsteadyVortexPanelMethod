function [uv_x, uv_y] = inducedVelocityMat(gam,xy,xyVortex)
%Calculate the induced velocity uv at a list of points xy due to a list of vortices at
% xyVortex

%Remember xy and xyVortex will be different lengths


x_mat = repmat(xy(:,1).',length(xy),1);
y_mat = repmat(xy(:,2).',length(xy),1);
gam_mat = repmat(gam,1,length(gam));

x_vor_mat = repmat(xyVortex(:,1).',length(xyVortex),length(xy));
y_vor_mat = repmat(xyVortex(:,1).',length(xyVortex),length(xy));

dx = x_mat - x_vor_mat;
dy = y_mat - y_vor_mat;

r = (dx.^2 + dy.^2).^0.5; 

%dxy = xy-xyVortex;
%r = vecnorm(dxy.')';
R = 1.5e-4 ;

% Rankine Vortex

idx = r<R; 

prefactor = gam_mat ./(2.*pi.*r.^2);
uv_x = prefactor.*dy; 
uv_y = -prefactor.*dx; 

try
    prefactor = gam_mat.*r./(2*pi*R^3);
    uv_x(idx) = prefactor(idx).*dy; 
    uv_y(idx) = prefactor(idx).*dy; 
catch
end

end