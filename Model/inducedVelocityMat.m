function [uv_x, uv_y] = inducedVelocityMat(gam,xy,xyVortex)
%Calculate the induced velocity uv at a list of points xy due to a list of vortices at
% xyVortex

    x_mat = repmat(xy(:,1).',length(xyVortex),1);
    y_mat = repmat(xy(:,2).',length(xyVortex),1);
    
    gam_mat = repmat(gam,1,length(xy));
    x_vor_mat = repmat(xyVortex(:,1),1,length(xy));
    y_vor_mat = repmat(xyVortex(:,2),1,length(xy));

    dx = x_mat - x_vor_mat;
    dy = y_mat - y_vor_mat;

    r = (dx.^2 + dy.^2).^0.5; 
    R = 1e-5 ;


    % Standard vortex model 
    prefactor = gam_mat ./(2.*pi.*r.^2);
    uv_x = prefactor.*dy; 
    uv_y = -prefactor.*dx; 

    % Rankine vortex model for vortices close together
    idx = r<R; 
    uv_x(isnan(uv_x))=0;
    uv_y(isnan(uv_y))=0;
    prefactor = gam_mat.*r./(2*pi*R^3);
    uv_x = uv_x.*(~idx) + idx.*prefactor.*dy; 
    uv_y = uv_y.*(~idx) - idx.*prefactor.*dx; 
    

end