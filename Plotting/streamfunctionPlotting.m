function streamfunctionPlotting(alpha_rad, pos, vel, gam ,uv_vec, xygFSVortex_rel, np, t, dt, panelLength)

    xmin =-2.5;
    xmax =2.5;
    ymin =-2.5;
    ymax =2.5;
    nx = 101;
    ny = 101;   

    x = xmin:((xmax-xmin)/(nx-1)):xmax;
    y = ymin:((ymax-ymin)/(ny-1)):ymax;
    [ym,xm]=meshgrid(y,x);

    
    [xyPanel, xyCollocation, xyBoundVortex, ~] = makePanels(alpha_rad, pos, np, panelLength);
    
    %Rel frame to inertial frame transform
    inerToRel = [cos(alpha_rad), sin(alpha_rad); -sin(alpha_rad), cos(alpha_rad)]; % inertial frame to relative frame
    
    if size(xygFSVortex_rel) ~= 0 
        xygFSVortex_rel(:,1:2) = (inerToRel*xygFSVortex_rel(:,1:2).').' + pos;
    end
    
    %psi = ym;
    psi = zeros([nx,ny]);
    
    % psi due to bound vorticity
   for i = 1:np+1
       xV = xyBoundVortex(i,1);
       yV = xyBoundVortex(i,2);
       r = sqrt((xm-xV).^2 + (ym-yV).^2);  
       psi = psi - (gam(i)/(2*pi))*log(r);
   end
   
   % psi due to free stream vortices
   inputSize = size(xygFSVortex_rel);
   for i = 1:inputSize(1)
       xV = xygFSVortex_rel(i,1);
       yV = xygFSVortex_rel(i,2);
       gam_fsv = xygFSVortex_rel(i,3);
       r = sqrt((xm-xV).^2 + (ym-yV).^2);  
       psi = psi - (gam_fsv/(2*pi))*log(r);
   end

    
    figure('Name','streamlines');
    %contour(xm,ym,psi,50,'b')
    axis equal
    hold on
    
    %quiver(xyCollocation(:,1),xyCollocation(:,2),uv_vec(:,1),uv_vec(:,2) );
    
    plot(xyPanel(:,1),xyPanel(:,2),'k','linewidth',2);
    if size(xygFSVortex_rel) ~= 0
        noVortices = size(xygFSVortex_rel);
        noVortices = noVortices(1);
        %plot(xygFSVortex_rel(1:noVortices/2,1), xygFSVortex_rel(1:noVortices/2,2), '-o');
        %plot(xygFSVortex_rel(noVortices/2+1:noVortices,1), xygFSVortex_rel(noVortices/2+1:noVortices,2), '-o');
        scatter(xygFSVortex_rel(:,1), xygFSVortex_rel(:,2),[], xygFSVortex_rel(:,3)*10, 'x', 'linewidth',2);
        %plot(xygFSVortex_rel(:,1), xygFSVortex_rel(:,2), 'linewidth', 2);
    end
    hold off 
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    title(strcat('alpha (deg) = ',num2str(alpha_rad*180/pi,3), ';  V = [', num2str(vel), '];  t = ', num2str(t), ';  dt = ', num2str(dt), ';  Np = ', num2str(np)));
    
end