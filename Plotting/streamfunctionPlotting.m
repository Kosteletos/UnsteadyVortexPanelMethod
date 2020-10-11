function streamfunctionPlotting(gam, xyPanel, xyBoundVortex,uv_vec, xygFSVortex_rel, xyCollocation, alpha_rad, np)

    xmin =-1.5;
    xmax =1.5;
    ymin =-1.5;
    ymax =1.5;
    nx = 101;
    ny = 101;   

    x = xmin:((xmax-xmin)/(nx-1)):xmax;
    y = ymin:((ymax-ymin)/(ny-1)):ymax;
    [ym,xm]=meshgrid(y,x);

    
    %psi = ym;
    psi = zeros([nx,ny]);
    
   for i = 1:np
       xV = xyBoundVortex(i,1);
       yV = xyBoundVortex(i,2);
       r = sqrt((xm-xV).^2 + (ym-yV).^2);  
       psi = psi - (gam(i)/(2*pi))*log(r);
   end
   
   inputSize = size(xygFSVortex_rel);
   for i = 1:inputSize(1)
       xV = xygFSVortex_rel(i,1);
       yV = xygFSVortex_rel(i,2);
       r = sqrt((xm-xV).^2 + (ym-yV).^2);  
       psi = psi - (gam(i)/(2*pi))*log(r);
   end

    
    %c = -5:0.04:5;
    linkdata on
    figure('Name','streamlines');
    contour(xm,ym,psi,50,'b')
    axis equal
    hold on
    
    quiver(xyCollocation(:,1),xyCollocation(:,2),uv_vec(:,1),uv_vec(:,2) );
    
    plot(xyPanel(:,1),xyPanel(:,2),'k','linewidth',2);
    if size(xygFSVortex_rel) ~= 0
        noVortices = size(xygFSVortex_rel);
        noVortices = noVortices(1);
        plot(xygFSVortex_rel(1:noVortices/2,1), xygFSVortex_rel(1:noVortices/2,2));
        plot(xygFSVortex_rel(noVortices/2+1:noVortices,1), xygFSVortex_rel(noVortices/2+1:noVortices,2));
        %scatter(xygFSVortex(:,1), xygFSVortex(:,2));
    end
    hold off 
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    title(strcat('Streamlines at alpha (deg) =',num2str(alpha_rad*180/pi)));
    
end